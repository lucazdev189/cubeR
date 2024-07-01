#' get_person_data
#'
#' Gets person data from WCA website using the ID provided.
#'
#' @importFrom rvest read_html html_node html_text html_table html_element
#' @importFrom dplyr quo select
#' @importFrom tibble tibble as_tibble
#' @param id ID of the person to be searched.
#' @param export_csv Whether or not the data should be exported. Set to false by default.
#' @param directory Directory where the .csv file will be saved.
#' @param file_name File name of the .csv file.
#' @export
get_person_data <- function(id, export_csv=FALSE, directory=NULL, file_name) {
  options(pillar.sigfig=7)
  html <- rvest::read_html(paste("https://www.worldcubeassociation.org/persons/", id, sep = ""))

  name <- html |>
    rvest::html_node("div.text-center h2") |>
    rvest::html_text() |>
    trimws()

  image_url <- html |>
    rvest::html_node("div.text-center img.avatar") |>
    rvest::html_attr("src")

   country <- html |>
    rvest::html_node(".country") |>
    rvest::html_text()

   gender <- html |>
     rvest::html_node("table.table tbody td:nth-child(3)") |>
     rvest::html_text()

   comps <- html |>
     rvest::html_node("table.table tbody td:nth-child(4)") |>
     rvest::html_text()

   comp_solves <- html |>
     rvest::html_node("table.table tbody td:nth-child(5)") |>
     rvest::html_text()

   events <- html |>
     rvest::html_element(".personal-records table") |>
     rvest::html_table() |>
     dplyr::select(Event, Single, Average)

   if(export_csv) {
     key_data <- data.frame(
       name,
       id,
       image_url,
       country,
       gender,
       comps,
       comp_solves,
       events
     )
     names(key_data) <- c("Name", "ID", "Avatar", "Country", "Gender", "Competitions", "Completed Solves", "PR Data")
     final_data <- cbind(key_data, events)
     write.csv(final_data, file=paste0(directory, "/", file_name, "person_data.csv"), fileEncoding = "UTF-8")
     print("Saved to directory")
   }

   person_data <- tibble::tibble(Name = name, ID = id, Avatar = image_url, From = country, Gender = gender, Competitions = comps, Completed_Solves = comp_solves)
   person_events <- tibble::as_tibble(events)
   return(list(person_data = person_data, person_events = person_events))
}
