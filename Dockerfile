# first intermediate stage
FROM hnskde/qmongr-base-r AS intermediate

## in case we need an access token for upgrading during ci
ARG GITHUB_PAT

## upgrade qmongrdata from github
RUN R -e "remotes::install_github('SKDE-Felles/qmongrdata', dependencies = FALSE, upgrade = 'never')"


# second stage
FROM hnskde/qmongr-base-r

## copy updated from intermediate stage
COPY --from=intermediate --chown=root:staff /usr/local/lib/R/site-library/qmongrdata /usr/local/lib/R/site-library/qmongrdata/

LABEL maintainer "Are Edvardsen <are.edvardsen@helse-nord.no>"
LABEL com.centurylinklabs.watchtower.enable="true"

## add package tarball
COPY *.tar.gz .

## add package DESCRIPTION file
COPY DESCRIPTION .

## install dependencies
RUN R -e "remotes::install_deps()"

## install package
RUN R CMD INSTALL --clean *.tar.gz

## clean up
RUN rm *.tar.gz

EXPOSE 3838

CMD ["R", "-e", "options(shiny.port=3838,shiny.host='0.0.0.0'); qmongr::run_app()"]
