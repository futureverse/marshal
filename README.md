

<div id="badges"><!-- pkgdown markup -->
 <a href="https://github.com/HenrikBengtsson/marshal/actions?query=workflow%3AR-CMD-check"><img border="0" src="https://github.com/HenrikBengtsson/marshal/workflows/R-CMD-check/badge.svg?branch=develop" alt="Build status"/></a>    <a href="https://lifecycle.r-lib.org/articles/stages.html"><img border="0" src="man/figures/lifecycle-skeleton-orange.svg" alt="Life cycle: skeleton"/></a>
</div>

# marshal: Framework to Marshal Objects to be Used in Another R Process 

Some types of R objects can be used only in the R session they were created.  If used as-is in another R process, such objects often result in an immediate error or in obscure and hard-to-troubleshoot outcomes.  Because of this, they cannot be saved to file and re-used at a later time.  They can also not be exported to a worker in parallel processing.  These objects are sometimes referred to as non-exportable or non-serializable objects.  One solution to this problem is to use "marshalling" to encode the R object into an exportable representation that then can be used to re-create a copy of that object in another R process.  This package provides a framework for marshalling and unmarshalling R objects such that they can be transferred using functions such as `serialize()` and `unserialize()` of base R.


_WARNING: This package is currently just a skeleton.  Please stay tuned._


## Roadmap

1. Phase "Getting Started"

   * [ ] Start on a rudimentary "marshalling" protection framework based on the internal **future** functions `assert_no_references()`, `find_references()` and `reference_filters()`
   
   * [ ] Document common cases of packages with non-exportable objects as one or more vignettes.  For each package give at least one example that show the mistake, how to detect it with above protection functions, and when possible give workaround examples.  Illustrate with both sequential use cases (e.g. `saveRDS()` and `readRDS()`) and with parallelization (e.g. `parallel::clusterEvalQ()`, `foreach::foreach() %dopar% { ... }`, and `future::future()`

   * [ ] Invite R community to report on more cases to build up a knowledge base and make the **marshal** documentation a go-to reference for explaining the problem


2. Phase "Detect & Protection"

   * [ ] Detect and report on non-exportable objects via the condition system

      - [ ] objects with external pointers

      - [ ] connection objects

      - [ ] ...

   * [ ] Develop set of acceptance filters to handle false positives, e.g. `data.table::data.table` objects

   * [ ] Develop set of reject filters to handle true positives with specific, more informative error messages, e.g. connection objects


3. Phase "Marshalling"

   * Add S3 generic `marshal()` to re-deconstruct non-exportable objects of certain classes so that they can be re-constructed using `unmarshal()` afterward, e.g.
   
      - [ ] 'XMLAbstractDocument' of **XML**, cf. `XML::xmlSerializeHook()` and `XML::xmlDeserializeHook()`

      - [ ] base R URL and read-only file connections

      - [ ] Identify packages whose non-exportable objects could be marshalled similarly

  * Implement efficient, recursive `marshal()` for sets such as lists and environments
  
  * After marshalling an object, or, say, a list of objects, investigate if we can leverage R's serialization framework to automatically unmarshal objects via `base::serialize(..., refhook = unmarshal)`.  We might be able to do this by having `marshal()` appending a "trigger" reference to the marshalled object
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
