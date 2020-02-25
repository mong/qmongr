#' Creates a configuration file.
#' 
#' @rdname config
#' @export
create_config <- function(){
  file <- system.file("qmongr.yml", package = "qmongr")
  created <- file.copy(file, to = config_file)
  if(created)
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
get_config <- function(){
  has_config()
  config <- yaml::read_yaml(config_file)
  check_config(config)
  return(config)
}

check_config <- function(config){
  if(config$database$user == "me" && config$database$password == "password" && config$database$name == "name")
    stop("Complete the config file: _qmongr.yml")
  invisible()
}

#' Has Config
#' 
#' Ensure config file is present.
#' 
#' @keywords internal
has_config <- function(){
  has_config <- file.exists(config_file)
  if(!has_config)
    stop(
      "Missing config file, see `create_config`", call. = FALSE
    )

  invisible()
}

