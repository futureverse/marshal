Some types of R objects can be used only in the R session they were created.  If used as-is in another R process, such objects often result in an immediate error or in obscure and hard-to-troubleshoot outcomes.  Because of this, they cannot be saved to file and re-used at a later time.  They can also not be exported to a worker in parallel processing.  These objects are sometimes referred to as non-exportable or non-serializable objects.  One solution to this problem is to use "marshalling" to encode the R object into an exportable representation that then can be used to re-create a copy of that object in another R process.  This package provides a framework for marshalling and unmarshalling R objects such that they can be transferred using functions such as `serialize()` and `unserialize()` of base R.

_WARNING: This package is currently just a skeleton.  Please stay tuned._


## Outcome

When `marshal()` and `unmarshal()` methods have been implemented for some of the "non-exportable" object types, it will be possible to use also these objects in a later or another R session and in parallel R workers.  Here are some example of functions that will be able to take advantage of marshalling:

  - `raw <- serialize(x, connection = NULL)` and `y <- unserialize(raw)` - serialize object `x` to a raw byte sequence, from which then the original object can be reconstructed
  - `save(x, y, file = "xy.RData")` and `load("xy.RData")` - save and reload R objects to a binary file by their names
  - `saveRDS(x, "x.rds")` and `y <- readRDS("x.rds")` - save and reload an R object to a binary file
  - `save.image()`: saves the global environment to an '.RData' file. Next time R is launched, this the global environment is recreated. This function is called by for instance `quit(save = "yes")`
  - `parallel::clusterExport(cl, varlist = c("x", "y"))` - export variables `x` and `y` to a parallel workers
  - `f <- future::future(x * y)` - export variables `x` and `y` to a parallel workers and evaluate the expression



## Roadmap

1. Phase "Getting Started"

   * [ ] Start on a rudimentary "marshalling" protection framework based on the internal **future** functions `assert_no_references()`, `find_references()` and `reference_filters()`
   
   * [ ] Document common cases of packages with non-exportable objects as one or more vignettes.  The [A Future for R: Non-Exportable Objects](https://cran.r-project.org/web/packages/future/vignettes/future-4-non-exportable-objects.html) vignette is a good start.  For each package give at least one example that show the mistake, how to detect it with above protection functions, and when possible give workaround examples.  Illustrate with both sequential use cases (e.g. `saveRDS()` and `readRDS()`) and with parallelization (e.g. `parallel::clusterEvalQ()`, `foreach::foreach() %dopar% { ... }`, and `future::future()`

   * [ ] Invite R community to report on more cases to build up a knowledge base and make the **marshal** documentation a go-to reference for explaining the problem


2. Phase "Detect & Protection"

   * [ ] Detect and report on non-exportable objects via the condition system

      - [ ] objects with external pointers

      - [ ] connection objects

      - [ ] ...

   * [ ] Develop set of acceptance filters to handle false positives, e.g. `data.table::data.table` objects

   * [ ] Develop set of reject filters to handle true positives with specific, more informative error messages, e.g. connection objects


3. Phase "Marshalling"

   * [ ] Add S3 generic `marshal()` to re-deconstruct non-exportable objects of certain classes so that they can be re-constructed using `unmarshal()` afterward, e.g.
   
      - [ ] 'XMLAbstractDocument' of **XML**, cf. `XML::xmlSerializeHook()` and `XML::xmlDeserializeHook()`

      - [ ] base R URL and read-only file connections

      - [ ] Identify packages whose non-exportable objects may be marshalled similarly, e.g. **ShortRead** and **ncdf4**

  * [ ] Implement efficient, recursive `marshal()` for sets such as lists and environments
  
  * [ ] After marshalling an object, or, say, a list of objects, investigate if we can leverage R's serialization framework to automatically unmarshal objects via `base::serialize(..., refhook = unmarshal)`.  We might be able to do this by having `marshal()` appending a "trigger" reference to the marshalled object


