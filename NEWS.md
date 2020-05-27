# qmongr 0.7.0

## New feature

TEXT HERE!

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
