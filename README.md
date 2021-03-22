![Life cycle: skeleton](man/figures/lifecycle-skeleton-orange.svg)  ![R-CMD-check](https://github.com/HenrikBengtsson/marshal/workflows/R-CMD-check/badge.svg)

# marshal - Framework to Marshal Objects to be Used in Another R Process

Some types of R objects can be used only in the R session they were created.  If used as-is in another R process, such objects often result in an immediate error or in obscure and hard-to-troubleshoot outcomes.  Because of this, they cannot be saved to file and re-used at a later time.  They can also not be exported to a worker in parallel processing.  These objects are sometimes referred to as non-exportable or non-serializable objects.  One solution to this problem is to use "marshalling" to encode the R object into an exportable representation that then can be used to re-create a copy of that object in another R process.  This package provides a framework for marshalling and unmarshalling R objects such that they can be transferred using functions such as `serialize()` and `unserialize()` of base R.


_WARNING: This package is currently just a skeleton.  Please stay tuned._


## Google Summer of Code (GSoC) 2021

If you are a student and interested in working on this project, please consider applying to work on it via GSoC 2021.  Google Summer of Code is an initiative to support students to learn about and contribute to open-source software projects, while getting payed.  The R community has been mentoring many GSoC projects over the years.  For more details, please see the GSoC 2021 proposal ['marshal: Saving and Loading Objects that Otherwise Cannot be Saved or Exported to Parallel Workers'](https://github.com/rstats-gsoc/gsoc2021/wiki/marshal).  **The deadline for student applications is on [April 13, 2021](https://github.com/rstats-gsoc/gsoc2021/wiki) with a soft deadline the week before.**



## Roadmap

1. Add low-level reference hook functions for serializing and unserializing reference objects created by base R

2. Higher-level reference hook functions to orchestrate multiple low-level hook functions, e.g. scan until one of matches

3. API for users and package's to register low-level reference hook functions


## Contributions

We abide to the [Code of Conduct](https://www.contributor-covenant.org/version/2/0/code_of_conduct/) of Contributor Covenant.
