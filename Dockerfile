FROM hnskde/qmongr-base-r

LABEL maintainer "Are Edvardsen <are.edvardsen@helse-nord.no>"
LABEL no.mongr.cd.enable="true"

# install imongr and its dependencies
RUN R -e "remotes::install_github('mong/imongr@*release')"

## add package tarball
COPY *.tar.gz .

## install package
RUN R CMD INSTALL --clean *.tar.gz

## clean up
RUN rm *.tar.gz

EXPOSE 3838

CMD ["R", "-e", "options(shiny.port=3838,shiny.host='0.0.0.0'); qmongr::run_app()"]
