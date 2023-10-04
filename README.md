<div id="badges"><!-- pkgdown markup -->
 <a href="https://github.com/HenrikBengtsson/marshal/actions?query=workflow%3AR-CMD-check"><img border="0" src="https://github.com/HenrikBengtsson/marshal/actions/workflows/R-CMD-check.yaml/badge.svg?branch=develop" alt="R CMD check status"/></a>      
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
we open a read-only file connection and read a few character:

```r
pathname <- system.file(package = "base", "CITATION")
con <- file(pathname, open = "r")
bfr <- readChar(con, nchars = 9)
print(bfr)
#> [1] "bibentry("
```

Next, imagine that we would save the connection object `con` to file
and quit R;

```r
saveRDS(con, "con.rds")
quit()
```

Then, if we try to use this saved connection in another R session,
we'll find that it will not work;

```r
con2 <- readRDS("con.rds")
print(con2)
#> A connection, specifically, 'file', but invalid.
```

This is because R connections are unique to the R process that created
them.  As we will see below, it is only in rare cases, they maybe used
in another R process.

One solution to this problem is to use "marshalling" to encode the R
object into an exportable representation that then can be used to
re-create a copy of that object in another R process that imitates the
original object.

This package provides generic functions `marshal()` and `unmarshal()`
for marshalling and unmarshalling R objects of certain class.  This
makes it possible to save otherwise non-exportable objects to file and
then be used in a future R session, or to transfer them to another R
process to be used there.


## Proposed API

The long-term goal with this package is for it to provide a de-facto
standard and API for marshalling and unmarshalling objects in R.  To
achieve this, this package proposes three generic functions:

 1. `marshallable()` - check whether an R object can be marshalled or
    not
 
 2. `marshal()` - marshal an R object
 
 3. `unmarshal()` - reconstruct a marshalled R object


If we return to our file connection, we can marshal the object by
recording the original filename and the current file position when we
save it to file.  This works as long as the connection is read-only
and that the file does not change in-between.  The **marshal** package
implements an S3 `marhal()` method for the `connection` class that
does this for us.  For example,

```r
pathname <- system.file(package = "base", "CITATION")
con <- file(pathname, open = "rb")
print(seek(con))
#> [1] 0

bfr <- readChar(con, nchars = 9)
print(bfr)
#> [1] "bibentry("

print(seek(con))
#> [1] 9

saveRDS(marshal::marshal(con), "con.rds")

quit()
```


Later, in another R session, we can reconstruct this read-only file
connection to the same file at the same file position as when it was
saved to disk by using:

```sh
con2 <- marshal::unmarshal(readRDS("con.rds"))
print(con2)
#> A connection with
#> description "/path/to/R/lib/R/library/base/CITATION"
#> class       "file"
#> mode        "r"
#> text        "text"
#> opened      "opened"
#> can read    "yes"
#> can write   "no"

print(seek(con2))
#> [1] 9

bfr2 <- readChar(con2, nchars = 10)
print(bfr2)
#> [1] "\"Manual\",\n"
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

The **marshal** package is only available via
[GitHub](https://github.com/HenrikBengtsson/marshal) and can be
installed in R as:

```r
remotes::install_github("HenrikBengtsson/marshal", ref = "main")
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
