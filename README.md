
# qmongr

<!-- badges: start -->
[![Version](https://img.shields.io/github/v/release/mong/qmongr?sort=semver)](https://github.com/mong/qmongr/releases)
[![R build status](https://github.com/mong/qmongr/workflows/R-CMD-check/badge.svg)](https://github.com/mong/qmongr/actions)
[![Codecov test coverage](https://codecov.io/gh/mong/qmongr/branch/master/graph/badge.svg)](https://codecov.io/gh/mong/qmongr?branch=master)
[![GitHub open issues](https://img.shields.io/github/issues/mong/qmongr.svg)](https://github.com/mong/qmongr/issues)
[![License: GPL v3](https://img.shields.io/badge/License-GPLv3-blue.svg)](https://www.gnu.org/licenses/gpl-3.0)
[![Doc](https://img.shields.io/badge/Doc--grey.svg)](https://mong.github.io/qmongr/)
<!-- badges: end -->

The goal of qmongr is to ...

## Installation

You can install the latest released version of qmongr from [github](https://github.com) with:

``` r
remotes::install_github("mong/qmongr@*release")
```

## Usage

_qmongr_ purpose is to provide a web application. From an _R_ command promt do:

``` r
library(qmongr)
run_app()
```

## Docker

This R package can be added to a docker image together with all _R_ and system dependencies needed to run the the _qmongr_ web application from any docker host.

### Build

Since the _qmongr_ _R_ package is to be installed into the image please make sure to build the source tarball first. From a system command terminal navigate into the _qmongr_-directory and run:
```
R CMD build .
```

Then, build the docker image:
```
docker build -t qmongr .
```

### Run

To run the docker container from a system command terminal do:
```
docker run -p 3838:3838 qmongr
```

Then, open a web browser window and navigate to [your localhost at port 3838](http://127.0.0.1:3838) to use the _qmongr_ web application.

To stop the docker container hit ```Ctrl + c``` in the system comman terminal.

### Develop

Each time the source of the _qmongr_ _R_ package is updated and you want to see the result by running the docker container please make sure also to repeat the _Build_ step above before runnig the container.

You may also use the docker development environment provided:
```
docker-compose up
```
This contains three containers: a database server, [an admin interface](http://localhost:8888) to the database and the [R-Studio IDE](http://localhost:8787). Assuming that a database dump (_e.g._ imongr_db_dump.sql.gz) exists in the root of this project the database will also be populated by relevant data as the containers are started.

## Ethics
Please note that the 'qmongr' project is released with a
  [Contributor Code of Conduct](CODE_OF_CONDUCT.md).
  By contributing to this project, you agree to abide by its terms.
