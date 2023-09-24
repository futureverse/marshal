#' Marshal and Unmarshal a 'rstan' object
#'
#' @param x
#' A `rstan:stanfit` object.
#'
#' @param \dots Not used.
#'
#' @return
#' A `marshalled` object as described in [marshal()].
#'
#' @rdname marshal.stanfit
#' @aliases marshal.stanfit
#' @export
marshal.stanfit <- function(x, ...) {
  raw <- serialize(x, connection = NULL, xdr = FALSE)
  
  res <- list(
    marshalled = raw
  )
  class(res) <- marshal_class(x)
  
  ## IMPORTANT: We don't want any of the input arguments
  ## to be part of the unmarshal() environment
  rm(list = c("x", names(list(...))))
  
  res[["unmarshal"]] <- unmarshal_stanfit
  assert_no_references(res)
  res
}

unmarshal_stanfit <- function(x, ...) {
  object <- x[["marshalled"]]
  res <- unserialize(object)
  stopifnot(all.equal(class(res), marshal_unclass(x), check.attributes = FALSE))
  res
}
