#' get_person_data
#'
#' Gets person data from WCA website using the ID provided.
#'
#' @importFrom rvest read_html html_node html_text html_attr
#' @importFrom dplyr %>%
#' @param id ID of the person to be searched.
#' @param export_csv Whether or not the data should be exported. Set to false by default.
#' @export
get_person_data <- function(id, export_csv=FALSE, directory=NULL) {
  html <- rvest::read_html(paste("https://www.worldcubeassociation.org/persons/", id, sep = ""))

  name <- html %>%
    rvest::html_node("div.text-center h2") %>%
    rvest::html_text()

  image_url <- html %>%
    rvest::html_node("div.text-center img.avatar") %>%
    rvest::html_attr("src")

   country <- html %>%
    rvest::html_node(".country") %>%
    rvest::html_text()

   gender <- html %>%
     rvest::html_node("table.table tbody td:nth-child(3)") %>%
     rvest::html_text()

   comps <- html %>%
     rvest::html_node("table.table tbody td:nth-child(4)") %>%
     rvest::html_text()

   comp_solves <- html %>%
     rvest::html_node("table.table tbody td:nth-child(5)") %>%
     rvest::html_text()

   events <- html %>%
     rvest::html_nodes("table.table tbody tr")

   event_data <- lapply(events, function(event) {
     event_name <- event %>%
       rvest::html_node("td:nth-child(1)") %>%
       rvest::html_text(trim=TRUE)

     single <- event %>%
       rvest::html_node("td:nth-child(5)") %>%
       rvest::html_text(trim=TRUE)

     average <- event %>%
       rvest::html_node("td:nth-child(6)") %>%
       rvest::html_text(trim=TRUE)

     data.frame(
       Event = event_name,
       Single = single,
       Average = average,
       stringsAsFactors = FALSE
     )
   })

   event_data <- do.call(rbind, event_data)

   if(export_csv) {
     key_data <- data.frame(
       name,
       id,
       image_url,
       country,
       gender,
       comps,
       comp_solves
     )
     names(key_data) <- c("Name", "ID", "Avatar", "Country", "Gender", "Competitions", "Completed Solves")

     final_data <- cbind(key_data, event_data)

     write.csv(final_data, file=paste0(directory, "/person_data.csv"), fileEncoding = "UTF-8")
     print("Saved to directory")
   }

  cat("Name:", name, "\n")
  cat("ID:", id, "\n")
  cat("Image URL:", image_url, "\n")
  cat("Country:", country, "\n")
  cat("Gender:", gender, "\n")
  cat("Competitions:", comps, "\n")
  cat("Completed Solves:", comp_solves, "\n")
  cat("Event Data:\n")
  print(event_data)
}
