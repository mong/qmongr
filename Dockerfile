FROM hnskde/qmongr-base-r

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

# install package dependency from github
RUN R -e "remotes::install_github('SKDE-Felles/qmongrdata', upgrade = 'never')"

# add package tarball
COPY *.tar.gz .

# install package
RUN R CMD INSTALL --clean *.tar.gz

# clean up
RUN rm *.tar.gz

EXPOSE 3838

CMD ["R", "-e", "options(shiny.port=3838,shiny.host='0.0.0.0'); qmongr::run_app()"]
