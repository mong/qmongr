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
#' Creates a configuration file based on the default shipped with qmongr package.
#'
#' @param dir Folder to put config file
#'
#' @export
create_config <- function(dir = ".") {
  ref_file <- system.file("qmongr.yml", package = "qmongr")
  new_file <- paste(dir, "_qmongr.yml", sep = "/")
  if (!file.exists(new_file)) {
    file.copy(ref_file, to = new_file)
    return(paste0(new_file, " file created: fill it in"))
  } else {
    return(paste0("Cannot create ", new_file, " config file: already exists"))
  }
}

#' Retrieve Config
#'
#' Retrieves config file.
#'
#' @param dir Folder location of _qmongr.yml file
#'
#' @export
get_config <- function(dir = ".") {
  config_file <- paste(dir, "_qmongr.yml", sep = "/")
  if (!file.exists(config_file)) {
    # Use the default if _qmongr.yml does not exist
    config_file <- system.file("qmongr.yml", package = "qmongr")
  }
  config <- yaml::read_yaml(config_file)
  check_config(config)
  return(config)
}

#' Check config file
#'
#' @param config Config file to check
#'
check_config <- function(config) {
  if ((class(config) != "list") | (!("app_text" %in% attributes(config)$names))) {
    stop("Complete the config file: _qmongr.yml")
  }
  invisible()
}
