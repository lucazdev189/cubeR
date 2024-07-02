#' get_record()
#'
#' Gets the record of the chosen event and region
#'
#' @importFrom dplyr quo
#' @importFrom rvest read_html html_element html_table
#' @param event Event of the record to be searched for. Note that we use
#' the short version of the event name, e.g. 3x3 is 333, Square-1 is sq1, and so on
#' @param region Region of the record to be search for (World on default)
#' @export
get_record <- function(event, region="World") {
  region <- switch(region,
                   "Africa" = "_Africa",
                   "Asia" = "_Asia",
                   "Europe" = "_Europe",
                   "North America" = "_North%20America",
                   "Oceania" = "_Oceania",
                   "South America" = "_South%20America",
                   URLencode(region, reserved = TRUE))

  html <- rvest::read_html(paste0("https://www.worldcubeassociation.org/results/records?event_id=", event, "&region=", region))

  record <- html |>
    rvest::html_element(".table-responsive") |>
    rvest::html_table()

  return(record)
}
