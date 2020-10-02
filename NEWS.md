# Unreleased

# qmongr 0.16.1

Fix header and update medical fields ([#182](https://github.com/mong/qmongr/pull/182))

# qmongr 0.16.0

## Major rewrite of code ([#179](https://github.com/mong/qmongr/pull/179))

Almost all `R` code has been replaced by `react.js`.

# qmongr 0.15.1

Fix app so it will work with imongr >= 0.12 ([#176](https://github.com/mong/qmongr/pull/176)). The functions `get_indicator`, `get_registry` and `get_agg_data` replaced by `get_table` function.

# qmongr 0.15.0

## Pre-filter data on server side before sending to browser ([#175](https://github.com/mong/qmongr/pull/175))

- Only data with `include = 1`
- Filter out treatment units with no data four last year

## Minor

- Info pop-up closer to top

# qmongr 0.14.2

Updated `fagomr`  according to database update:
- Split `tarmkreft` into `tarmkreft_colon` and `tarmkreft_rectum`.
- Renamed `rygg` to `nkr_rygg` (to be consistent with `nkr_nakke`).

# qmongr 0.14.1

- "Alle" -> "Alle indikatorer" in left side menu ([165](https://github.com/mong/qmongr/pull/165))

# qmongr 0.14.0

## Hamburger menu next to figures ([#164](https://github.com/mong/qmongr/pull/164))

- Zoom out and in
- Show target levels in graph
- Close figure

Javascript reactivated (deactivated in [qmongr 0.13.0](#qmongr-0130))

# qmongr 0.13.2

## Minor

- Fixed start up error ([#161](https://github.com/mong/qmongr/pull/161)).
- Reintroduced 2019 data ([#162](https://github.com/mong/qmongr/pull/162)).

# qmongr 0.13.1

## No longer using qmongrdata ([#159](https://github.com/mong/qmongr/pull/159))

# qmongr 0.13.0

## Use imongr database ([#156](https://github.com/mong/qmongr/pull/156))

## Internal

- Removed hard-coded `intensiv2` indicator code (if-statements).

# qmongr 0.12.0

## Fixed top navbar, sidebar, legend and table header when scrolling ([#149](https://github.com/mong/qmongr/pull/149))

## Internal

- Docker dev. env. ([#146](https://github.com/mong/qmongr/pull/146) and [2321028](https://github.com/mong/qmongr/commit/2321028)). Added a docker compose file. 
- `js` in a bundle ([#139](https://github.com/mong/qmongr/pull/139)). `js` code and development moved to https://github.com/mong/qmongjs
- Function for reading data from database ([#148](https://github.com/mong/qmongr/pull/148))

# qmongr 0.11.0

## Show national numbers as default ([#142](https://github.com/mong/qmongr/pull/142))

## Minor

- Show every other year in figure if the tot nr of years are more than 8 ([#135](https://github.com/mong/qmongr/pull/135)).

## Internal

- Use the cran version of shiny ([#144](https://github.com/mong/qmongr/pull/144)).
- Removed load_data func. and all its children func. ([#141](https://github.com/mong/qmongr/pull/141)).

# qmongr 0.10.0

## New table layout

- The table lagends look like ordinary buttons and moved to the center of the table
- Register names removed from indicator rows and then moved to the left in the register rows
- Table interaction changed in the line chart
- Axis labels changed to percentages

## Include data from Hoftebrudd register ([#133](https://github.com/mong/qmongr/pull/133))

## Internal

- Test `html` output against `html` text files ([#134](https://github.com/mong/qmongr/pull/134)).
- Skip testing of `app_data()` (part of [#133](https://github.com/mong/qmongr/pull/133)). No longer used by app. Will be moved to `imongr`.
- Do not show `intensiv2` indicator (part of [#133](https://github.com/mong/qmongr/pull/133)). Only indicator that was not percentage.

# qmongr 0.9.0

## Real numbers in left column ([#130](https://github.com/mong/qmongr/pull/130))

Number of indicators per medical field.

## Internal

- Use the latest released version of `qmongrdata`. At the moment, the tests in the current version of `qmongr` will fail with the latest (unreleased) version of `qmongrdata`.
- Updated `version_info`. Previous version will fail for less than two packages ([#128](https://github.com/mong/qmongr/pull/128))

# qmongr 0.8.0

- Limit the max nr of selected treatment units ([#119](https://github.com/mong/qmongr/pull/119))
- Add indecator description text below the figures in the table ([#120](https://github.com/mong/qmongr/pull/120))
- Equal column width ([#126](https://github.com/mong/qmongr/pull/126))

# qmongr 0.7.3

Fix barchart button bug ([#117](https://github.com/mong/qmongr/pull/117))

# qmongr 0.7.2

Smoother transitions ([#115](https://github.com/mong/qmongr/pull/115))

- zoom in to line chart
- added delayed transitions in the bar charts and linecharts

# qmongr 0.7.1

- Figure legend with interaction ([#114](https://github.com/mong/qmongr/pull/114))

  Added interaction to the chart lagend and fixed the layout of the legend

- Use internal data ([#113](https://github.com/mong/qmongr/pull/113))

  Aggregating data from qmongrdata takes forever,
  and slows down the starting of the app (see issue #112).
  In this commit, the data aggr_data is created by running
  the function app_data() beforehand, and is used directly by the app.

# qmongr 0.7.0

## Clickable elements in indicator table ([#105](https://github.com/mong/qmongr/pull/105)).

Click on indicator in table will reveal barchart plot. A clickable button can change the plot to a line plot, showing a time series.

## Internal

Check `output$qi_table[["html"]]` instead of `output$qi_table` in tests.

# qmongr 0.6.5

Added dependency: development version of `shiny` from `rstudio/shiny` on github. `moduleServer`, introduced in version `0.6.4`, is not part of `shiny` on cran

# qmongr 0.6.4

## Replaced callModule with moduleServer ([#104](https://github.com/mong/qmongr/pull/104)).

`testModule` is no longer a part of `shiny`, so we had to use `testServer` to test our modules. `callModule` way of running modules and regular functions way of making modules can not be tested by `testServer`. Thus, we had to use `moduleServer` to make modules (and run the modules as regular functions). This is also the recommended way according to `?shiny::callModule`:

> Starting in Shiny 1.5.0, we recommend using moduleServer instead of callModule, because the syntax is a little easier to understand, and modules created with moduleServer can be tested with testServer().

In practice we replaced all
```R
mymodule <- function(input, output, session, arg1, arg2) {
```
with
```R
mymodule <- function(id, arg1, arg2) {
   shiny::moduleServer(id, function(input, output, session) {
```
in the module part, and replaced all
```R
shiny::callModule(mymodule, "myID", arg1 = "blablabla", arg2 = "blablabla2")
```
with
```R
mymodule("myID", arg1 = "blablabla", arg2 = "blablabla2")
```
where we call modules.

## Fix tag deployment ([#102](https://github.com/mong/qmongr/pull/102)).
- Deploy script (`docker_push`) will be launched for all branches
- Script will check if commit should be pushed to Docker hub or not.
- Will push to `hnskde/qmongr:test` if `$TRAVIS_BRANCH` is `master`
- Will push to `hnskde/qmongr:latest` if `$TRAVIS_TAG` is on the format `vX.Y.Z`.
- The script `docker_hub` is moved to https://github.com/mong/scripts for easy reuse. I use the same setup for `tmongr` and `helseatlas` and was tired of updating three places all the time.


# qmongr 0.6.3

- Tag and push docker image with `test` if not a release ([#101](https://github.com/mong/qmongr/pull/101)).
- Moved repository to mong ([#100](https://github.com/mong/qmongr/pull/100))
    * renamed all SKDE-Felles with mong
    * github shiny only needed for testing, not for running app. Thus, only depend on cran version of shiny in DESCRIPTION.
    * appveyor and travis: install shiny from github

# qmongr 0.6.2

* Test of qmongr site response added during ci/cd ([#98](https://github.com/mong/qmongr/pull/98))

# qmongr 0.6.1

## Internal

* Split the shiny module `quality_overview` into several modules  ([#97](https://github.com/mong/qmongr/pull/97))

# qmongr 0.6.0

## New feature

* Added information widget ([#90](https://github.com/mong/qmongr/pull/90))

## Internal

* Restructured `mod_quality_overview_server` tests.

# qmongr 0.5.0

## New feature

* Enable filtering by the achievment level of the qi([#89](https://github.com/mong/qmongr/pull/89))

# qmongr 0.4.0

* Add qi overview ([#84](https://github.com/mong/qmongr/pull/84))
  - Possible to filter on medical field
* Nav tab ([#88](https://github.com/mong/qmongr/pull/88)). Re-defining structure and looks
* Use at least `qmongrdata` [version 0.2.3](https://mong.github.io/qmongrdata/news/index.html#qmongrdata-0-2-3) 
* Test updates

# qmongr 0.3.1

- Use `stringr::str_sort(locale = "no")` instead of `sort()`, e.g. to sort *Arendal* before *Ålesund*.

# qmongr 0.3.0

* Total rewrite of the app [#73](https://github.com/mong/qmongr/pull/73)
  - Drop down menu with hierarchy
  - Show several hospitals at once, including HF and RHF
  - Working with `qmongrdata` [version 0.1.0](https://mong.github.io/qmongrdata/news/index.html#qmongrdata-0-1-0)  

<img width="1150" alt="Screenshot 2020-03-06 at 23 47 22" src="https://user-images.githubusercontent.com/136346/76128539-e6690780-6004-11ea-9388-f58fe83cc46d.png">

# qmongr 0.2.0

* Refined docker deployment (@areedv)
* Englishify package ([#43](https://github.com/mong/qmongr/pull/43))
* Testing refinement, including shiny module testing (@arnfinn)
* Include config file for text in app ([#55](https://github.com/mong/qmongr/pull/55))

# qmongr 0.1.0

First working version of app (mainly [#15](https://github.com/mong/qmongr/pull/15) by @yte0 and [#16](https://github.com/mong/qmongr/pull/16) by @lenaringstado)

![qmongr 0.1.0](https://user-images.githubusercontent.com/136346/74818563-2b035c00-52ff-11ea-999a-a3a0630eeb5f.png)
