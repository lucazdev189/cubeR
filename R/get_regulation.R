#' get_regulation
#'
#' Gets the chosen regulation from the WCA website.
#'
#' @importFrom rvest read_html html_element html_text
#' @importFrom dplyr quo
#' @param id Number or ID of the regulation to be searched for.
#' @export
get_regulation <- function(id) {
  html <- rvest::read_html(paste0("https://www.worldcubeassociation.org/regulations/#", id))

  requested_reg <- html |>
    rvest::html_element(paste0("#", id)) |>
    rvest::html_text() |>
    trimws()

  print(requested_reg)
}
