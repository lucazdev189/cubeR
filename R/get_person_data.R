#' get_person_data
#'
#' Gets person data from WCA website using the ID provided.
#'
#' @importFrom rvest read_html html_node html_text html_attr
#' @importFrom dplyr %>%
#' @param id ID of the person to be searched.
#' @export
get_person_data <- function(id) {
  html <- rvest::read_html(paste("https://www.worldcubeassociation.org/persons/", id, sep = ""))

  name <- html %>%
    rvest::html_node("div.text-center h2") %>%
    rvest::html_text()

  image_url <- html %>%
    rvest::html_node("div.text-center img.avatar") %>%
    rvest::html_attr("src")

  cat("Name:", name, "\n")
  cat("Image URL:", image_url, "\n")
}
