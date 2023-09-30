#' Marshalling of 'h2o' objects
#'
#' @param x
#' An "h2o" object.
#'
#' @param \dots Not used.
#'
#' @return
#' A `marshalled` object as described in [marshal()].
#'
#' @details
#' [h2o::h2o.save_mojo()] and [h2o::h2o.saveModel()] are used to produce
#' a marshalled version of the original object.
#' [h2o::h2o.import_mojo()] and [h2o::h2o.loadModel()] are used to
#' reconstruct a version of the original object from the marshalled object.
#'
#' @rdname marshal.h2o
#' @aliases marshal.H2OAutoML
#' @export
marshal.H2OAutoML <- function(x, ...) {
  marshal_h2o(x, ...)
}

#' @rdname marshal.h2o
#' @aliases marshal.H2OMultinomialModel
#' @export
marshal.H2OMultinomialModel <- function(x, ...) {
  marshal_h2o(x, ...)
}

#' @rdname marshal.h2o
#' @aliases marshal.H2OBinomialModel
#' @export
marshal.H2OBinomialModel <- function(x, ...) {
  marshal_h2o(x, ...)
}

#' @rdname marshal.h2o
#' @aliases marshal.H2ORegressionModel
#' @export
marshal.H2ORegressionModel <- function(x, ...) {
  marshal_h2o(x, ...)
}


marshal_h2o <- function(x, ...) {
  td <- tempdir()

  have_mojo <- x@have_mojo
  if (have_mojo) {
    tf <- h2o::h2o.save_mojo(x, path = td)
  } else {
    tf <- h2o::h2o.saveModel(x, path = td)
  }
  on.exit(file.remove(tf))
  raw <- readBin(tf, what = raw(), n = file.size(tf), endian = "little")
  
  res <- list(
    marshalled = raw,
    have_mojo = have_mojo
  )
  class(res) <- marshal_class(x)
  
  ## IMPORTANT: We don't want any of the input arguments
  ## to be part of the unmarshal() environment
  rm(list = c("x", names(list(...))))
  
  res[["unmarshal"]] <- unmarshal_h2o
  assert_no_references(res)
  res
}


unmarshal_h2o <- function(x, ...) {
  object <- x[["marshalled"]]
  
  tf <- tempdir()
  on.exit(file.remove(tf))
  writeBin(object, con = tf, endian = "little")
  
  if (x[["have_mojo"]]) {
    res <- h2o::h2o.import_mojo(tf)
  } else {
    res <- h2o::h2o.loadModel(tf)
  }
  
  stopifnot(all.equal(class(res), marshal_unclass(x), check.attributes = FALSE))
  res
}


#' @rdname marshal.h2o
#' @aliases marshallable.H2OAutoML
#' @export
marshallable.H2OAutoML <- function(...) {
  TRUE
}

#' @rdname marshal.h2o
#' @aliases marshallable.H2OMultinomialModel
#' @export
marshallable.H2OMultinomialModel <- function(...) {
  TRUE
}

#' @rdname marshal.h2o
#' @aliases marshallable.H2OBinomialModel
#' @export
marshallable.H2OBinomialModel <- function(...) {
  TRUE
}

#' @rdname marshal.h2o
#' @aliases marshallable.H2ORegressionModel
#' @export
marshallable.H2ORegressionModel <- function(...) {
  TRUE
}
