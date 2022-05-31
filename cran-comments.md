## Release summary
This version of `qualmap` is a maintenance release, largely to update the contact information for the maintainer and make small changes to documentation. The only other change is that R v3.5 is now the minimum version.

## Test environments
* local macOS install: R 4.1.2
* Linux ubuntu distribution (via GitHub Actions): R-devel, R-release, past four R-oldrel (4.1.3, 4.0.5, 3.6.3, 3.5.3)
* macOS (via GitHub Actions): R-release
* windows (via GitHub Actions): R-release
* winbuilder: R-release, R-oldrel, R-devel

## R CMD check results
There were no ERRORs, WARNINGs, or NOTEs with local or CI checks. There is one NOTE on winbuilder:

```r
* checking CRAN incoming feasibility ... NOTE
Maintainer: 'Christopher Prener <chris.prener@gmail.com>'

New maintainer:
  Christopher Prener <chris.prener@gmail.com>
Old maintainer(s):
  Christopher Prener <chris.prener@slu.edu>
```

I am still the maintainer - I have just changed my contact information due to new employment!

## Reverse dependencies
Not applicable.
