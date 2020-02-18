FROM rocker/r-base

LABEL maintainer "Are Edvardsen <are.edvardsen@helse-nord.no>"
LABEL com.centurylinklabs.watchtower.enable="true"

# system libraries of general use
RUN apt-get update && apt-get install -y \
    sudo \
    pandoc \
    pandoc-citeproc \
    libcurl4-gnutls-dev \
    libcairo2-dev \
    libxt-dev \
    libxml2-dev \
    libssl-dev

# basic R functionality
RUN R -e "install.packages(c('remotes'), repos='https://cloud.r-project.org/')"

# install qmongr app
RUN R -e "remotes::install_github('SKDE-Felles/qmongr')"

EXPOSE 3838

CMD ["R", "-e", "options(shiny.port=3838,shiny.host='0.0.0.0'); qmongr::run_app()"]
