# Unreleased

## New features

* Enable filtering by the achievment level of the qi([#89](https://github.com/SKDE-Felles/qmongr/pull/89))

# qmongr 0.4.0

* Add qi overview ([#84](https://github.com/SKDE-Felles/qmongr/pull/84))
  - Possible to filter on medical field
* Nav tab ([#88](https://github.com/SKDE-Felles/qmongr/pull/88)). Re-defining structure and looks
* Use at least `qmongrdata` [version 0.2.3](https://skde-felles.github.io/qmongrdata/news/index.html#qmongrdata-0-2-3) 
* Test updates

# qmongr 0.3.1

- Use `stringr::str_sort(locale = "no")` instead of `sort()`, e.g. to sort *Arendal* before *Ålesund*.

# qmongr 0.3.0

* Total rewrite of the app [#73](https://github.com/SKDE-Felles/qmongr/pull/73)
  - Drop down menu with hierarchy
  - Show several hospitals at once, including HF and RHF
  - Working with `qmongrdata` [version 0.1.0](https://skde-felles.github.io/qmongrdata/news/index.html#qmongrdata-0-1-0)  

<img width="1150" alt="Screenshot 2020-03-06 at 23 47 22" src="https://user-images.githubusercontent.com/136346/76128539-e6690780-6004-11ea-9388-f58fe83cc46d.png">

# qmongr 0.2.0

* Refined docker deployment (@areedv)
* Englishify package ([#43](https://github.com/SKDE-Felles/qmongr/pull/43))
* Testing refinement, including shiny module testing (@arnfinn)
* Include config file for text in app ([#55](https://github.com/SKDE-Felles/qmongr/pull/55))

# qmongr 0.1.0

First working version of app (mainly [#15](https://github.com/SKDE-Felles/qmongr/pull/15) by @yte0 and [#16](https://github.com/SKDE-Felles/qmongr/pull/16) by @lenaringstado)

![qmongr 0.1.0](https://user-images.githubusercontent.com/136346/74818563-2b035c00-52ff-11ea-999a-a3a0630eeb5f.png)
