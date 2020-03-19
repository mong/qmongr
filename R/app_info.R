#' Functions providing informational text about the app(s)
#'
#' @param newline String element defining line break for formatting. Default is
#' \code{<br>}
#' @return String formatted in some sensible manner
#' @name app_info
#' @aliases version_info no_opt_out_ok
NULL


#' @rdname app_info
#' @importFrom utils installed.packages
#' @export
#' @examples
#' version_info()

version_info <- function(newline = "<br>") {

  conf <- get_config()
  pkg <- conf$app_text$info$version$app
  m <- installed.packages()[pkg, c(1, 3)]
  paste0(pkg, " v", m[pkg, "Version"], newline, collapse = "")
}


#' @rdname app_info
#' @export
#' @examples
#' no_opt_out_ok()

no_opt_out_ok <- function() {

  conf <- get_config()
  msg <- conf$app_text$info$action_button$no_opt_out_ok
  sample(msg, 1)

}
