#' get_comp_data
#'
#' Gets competition data from WCA using the ID provided.
#'
#' @importFrom rvest read_html html_node html_text html_table html_element
#' @importFrom dplyr quo select
#' @importFrom tibble tibble as_tibble
#' @param id ID of the competition to be searched for.
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

  comp_data <- tibble::tibble(Comp_Name = name, Date = date, Venue = venue, Competitiors = competitors)
  top_1s <- tibble::as_tibble(first_placers)
  return(list(comp_data = comp_data, top_1s = top_1s))
}
