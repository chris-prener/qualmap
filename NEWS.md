# qualmap 0.2.0

* Add `qm_verify()` as a means for verifying data data previously saved to disk prior to processing them with `qm_summarize()`
* Add second approach to producing counts using `qm_summarize()` that returns counts of participants rather than counts of clusters associated with each feature
* Remove the inclusion of the `COUNT` from what is returned with `qm_create()`
* Ensure compatability with the `dplyr` v1.0 release:
  * `qm_cluster()` no longer adds a custom class
  * instead, `qm_is_cluster()` can be used to check for the appropriate characteristics of objects, but no longer checks the class itself
* Update `pkgdown` site and `README` with details on pre-print

# qualmap 0.1.1

* CRAN release version
* Add CRAN installation instructions to README/pkgdown
* Fix typo in usage section on README/pkgdown site
* Add `.github/` subdir with community files

# qualmap 0.1.0

* Added a `NEWS.md` file to track changes to the package.
* The core functionality of `qualmap` was available for ~ 6 months prior to this initial release
* The release version adds significant additions of error messages and data validation to the core functionality of the package
* Help files, the `pkgdown` site, and a getting started vignette have also been added to the package
