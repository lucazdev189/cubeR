#' get_comp_data
#'
#' Gets competition data from WCA using the ID provided.
#'
#' @importFrom rvest read_html html_node html_text html_table html_element
#' @importFrom dplyr quo
#' @param id ID of the competition to be searched for.
#' @param export_csv Whether or not the data should be exported. Set to false by default.
#' @param directory Directory where the .csv file will be saved.
#' @export
get_comp_data <- function(id, export_csv=FALSE, directory=NULL) {
  html <- rvest::read_html(paste0("https://www.worldcubeassociation.org/competitions/", id))

  name <- html |>
    rvest::html_node("h3") |>
    rvest::html_text()

  date <- html |>
    rvest::html_node(".compact dd:nth-child(2)") |>
    rvest::html_text()

  venue <- html |>
    rvest::html_node(".compact dd:nth-child(6) p") |>
    rvest::html_text()

  organizers <- html |>
    rvest::html_node("dd:nth-child(14)") |>
    rvest::html_text()

  cat("Name:", name, "\n")
  cat("Date:", date, "\n")
  cat("Venue:", venue, "\n")
  cat("Organizer(s):", organizers, "\n")
}
