#' get_comp_data
#'
#' Gets competition data from WCA using the ID provided.
#'
#' @importFrom rvest read_html html_node html_text html_table html_element
#' @importFrom dplyr quo select
#' @param id ID of the competition to be searched for.
#' @param export_csv Whether or not the data should be exported. Set to false by default.
#' @param directory Directory where the .csv file will be saved.
#' @param file_name File name of the .csv file.
#' @export
get_comp_data <- function(id, export_csv=FALSE, directory=NULL, file_name) {
  html <- rvest::read_html(paste0("https://www.worldcubeassociation.org/competitions/", id))

  name <- html |>
    rvest::html_node("h3") |>
    rvest::html_text() |>
    trimws()

  date <- html |>
    rvest::html_node(".compact dd:nth-child(2)") |>
    rvest::html_text() |>
    trimws()

  venue <- html |>
    rvest::html_node(".compact dd:nth-child(6) p") |>
    rvest::html_text()

  competitors <- html |>
    rvest::html_node(".competition-events-list~ dd:nth-child(6)") |>
    rvest::html_text()

  first_placers <- html |>
    rvest::html_element(".table-responsive") |>
    rvest::html_table() |>
    dplyr::select("Event", "Name", "Best", "Average", "Representing")

  if(export_csv) {
    key_data <- data.frame(
      name,
      date,
      venue,
      competitors,
      first_placers
    )
    names(key_data) <- c("Name", "Date", "Venue", "Competitors", "First Placers")
    final_data <- cbind(key_data, first_placers)
    write.csv(final_data, file=paste0(directory, "/", file_name, ".csv"), fileEncoding = "UTF-8")
    print("Saved to directory")
  }

  cat("Name:", name, "\n")
  cat("Date:", date, "\n")
  cat("Venue:", venue, "\n")
  cat("Competitors:", competitors, "\n")
  cat("1st Placers:")
  print(first_placers)
}
