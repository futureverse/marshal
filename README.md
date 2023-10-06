<div id="badges"><!-- pkgdown markup -->
<a href="https://github.com/HenrikBengtsson/marshal/actions/workflows/R-CMD-check.yaml"><img src="https://github.com/HenrikBengtsson/marshal/actions/workflows/R-CMD-check.yaml/badge.svg" alt="R-CMD-check"/></a>
<a href="https://henrikbengtsson.r-universe.dev/marshal"><img src="https://henrikbengtsson.r-universe.dev/badges/marshal" alt="port4me status badge"/></a>
</div>

# marshal: Unified API for Marshalling R Objects

## Introduction

Some types of R objects can be used only in the R session they were
created.  If used as-is in another R process, such objects often
result in an immediate error or in obscure and hard-to-troubleshoot
outcomes.  Because of this, they cannot be saved to file and re-used
at a later time.  They may also not be exported to a parallel worker
when doing parallel processing.  These objects are sometimes referred
to as non-exportable or non-serializable objects.  For example, assume
we load an HTML document using the **xml2** package:

```r
file <- system.file("extdata", "r-project.html", package = "xml2")
doc <- xml2::read_html(file)
```

Next, imagine that we would save this document object `doc` to file
and quit R;

```r
saveRDS(doc, "html.rds")
quit()
```

Then, if we try to use this saved **xml2** object in another R
session, we'll find that it will not work;

```r
doc2 <- readRDS("html.rds")
xml2::xml_length(doc2)
#> Error in xml_length.xml_node(doc2) : external pointer is not valid
```

This is because **xml2** objects only work in the R process that
created them.

One solution to this problem is to use "marshalling" to encode the R
object into an exportable representation that then can be used to
re-create a copy of that object in another R process that imitates the
original object.

The **marshal** package provides generic functions `marshal()` and
`unmarshal()` for marshalling and unmarshalling R objects of certain
class.  This makes it possible to save otherwise non-exportable
objects to file and then be used in a future R session, or to transfer
them to another R process to be used there.


## Proposed API

The long-term goal with this package is for it to provide a de-facto
standard and API for marshalling and unmarshalling objects in R.  To
achieve this, this package proposes three generic functions:

 1. `marshallable()` - check whether an R object can be marshalled or
    not
 
 2. `marshal()` - marshal an R object
 
 3. `unmarshal()` - reconstruct a marshalled R object


If we return to our **xml2** object, the **marshal** package
implements an S3 `marhal()` method for different **xml2** classes that
takes care of everything for us.  We can use this when we save the
object;

```r
file <- system.file("extdata", "r-project.html", package = "xml2")
doc <- xml2::read_html(file)

saveRDS(marshal::marshal(doc), "html.rds")

quit()
```

Later, in another R session, we can reconstruct this **xml2** HTML
document by using:

```sh
doc2 <- marshal::unmarshal(readRDS("html.rds"))
xml2::xml_length(doc2)
[1] 2
```
    

## Currently supported packages

In order to test the proposed solution and API, this package will
implement S3 `marshal()` methods for some common R packages and their
non-exportable classes.  Note that the long-term goals is that these
S3 methods should be implemented by these packages themselves, such
that the **marshal** package will only provide a light-weight API.

The [A Future for R: Non-Exportable Objects] vignette has a collection
of packages and classes that cannot be exported out of the box.  This
package has marshalling prototypes for objects from the following
packages:

* **caret**
* **data.table**
* **keras**
* **ncdf4**
* **parsnip**
* **raster**
* **rstan**
* **terra**
* **xgboost**
* **XML**
* **xml2**

It also has implementations that will throw an error for objects from
the following packages, because they cannot be marshalled, at least
not at the moment:

* **DBI**
* **magick**
* **parallel**

The plan is to improve on add support for more R packages and object
classes.


## Installation

The **marshal** package is not, yet, on CRAN.  In the meanwhile, it
can be installed from the R Universe as:

```r
install.packages("marshal", repos = c("https://henrikbengtsson.r-universe.dev", getOption("repos")))
```


### Pre-release version

To install the pre-release version that is available in Git branch
`develop` on GitHub, use:

```r
remotes::install_github("HenrikBengtsson/marshal", ref = "develop")
```

This will install the package from source.

<!-- pkgdown-drop-below -->


[A Future for R: Non-Exportable Objects]: https://cran.r-project.org/package=future/vignettes/future-4-non-exportable-objects.html
