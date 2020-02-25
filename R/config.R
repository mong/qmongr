# MIT License
# Copyright (c) 2020 John Coene
#
# Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated
# documentation files (the "Software"), to deal in the Software without restriction, including without limitation
# the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software,
# and to permit persons to whom the Software is furnished to do so, subject to the following conditions:
#
# The above copyright notice and this permission notice shall be included in all copies or substantial portions of
# the Software.
#
# THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO
# THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
# AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT,
# TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
# SOFTWARE.

#' Configuration
#'
#' Creates a configuration file.
#'
#' @rdname config
#' @export
create_config <- function() {
  file <- system.file("qmongr.yml", package = "qmongr")
  created <- file.copy(file, to = config_file)
  if (created)
    cli::cli_alert_success("_qmongr.yml file copied: fill it in")
  else
    cli::cli_alert_danger("Cannot create config file")

  invisible()
}

config_file <- "_qmongr.yml"

#' Retrieve Config
#'
#' Retrieves config file.
#'
#' @keywords internal
get_config <- function() {
  has_config()
  config <- yaml::read_yaml(config_file)
  check_config(config)
  return(config)
}

check_config <- function(config) {
  if (config$database$user == "me" && config$database$password == "password" && config$database$name == "name")
    stop("Complete the config file: _qmongr.yml")
  invisible()
}

#' Has Config
#'
#' Ensure config file is present.
#'
#' @keywords internal
has_config <- function() {
  has_config <- file.exists(config_file)
  if (!has_config)
    stop(
      "Missing config file, see `create_config`", call. = FALSE
    )

  invisible()
}
