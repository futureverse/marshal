

<div id="badges"><!-- pkgdown markup -->
 <a href="https://github.com/HenrikBengtsson/marshal/actions?query=workflow%3AR-CMD-check"><img border="0" src="https://github.com/HenrikBengtsson/marshal/workflows/R-CMD-check/badge.svg?branch=develop" alt="Build status"/></a>    <a href="https://lifecycle.r-lib.org/articles/stages.html"><img border="0" src="man/figures/lifecycle-skeleton-orange.svg" alt="Life cycle: skeleton"/></a>
</div>

# marshal: Framework to Marshal Objects to be Used in Another R Process 

Some types of R objects can be used only in the R session they were created.  If used as-is in another R process, such objects often result in an immediate error or in obscure and hard-to-troubleshoot outcomes.  Because of this, they cannot be saved to file and re-used at a later time.  They can also not be exported to a worker in parallel processing.  These objects are sometimes referred to as non-exportable or non-serializable objects.  One solution to this problem is to use "marshalling" to encode the R object into an exportable representation that then can be used to re-create a copy of that object in another R process.  This package provides a framework for marshalling and unmarshalling R objects such that they can be transferred using functions such as `serialize()` and `unserialize()` of base R.


_WARNING: This package is currently just a skeleton.  Please stay tuned._


## Roadmap

1. Add `marshal()` and `unmarshal()` S3 methods for objects created by base R such that they can be serialized

2. Investigate `marshal()` and `unmarshal()` S3 methods for non-exportable objects from popular CRAN packages, cf. <https://cran.r-project.org/web/packages/future/vignettes/future-4-non-exportable-objects.html>

## Installation
R package marshal is only available via [GitHub](https://github.com/HenrikBengtsson/marshal) and can be installed in R as:
```r
remotes::install_github("HenrikBengtsson/marshal", ref="master")
```


### Pre-release version

To install the pre-release version that is available in Git branch `develop` on GitHub, use:
```r
remotes::install_github("HenrikBengtsson/marshal", ref="develop")
```
This will install the package from source.  

<!-- pkgdown-drop-below -->

