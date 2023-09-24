#' Marshalling of 'parsnip' objects
#'
#' @param x
#' A `parnsip:model_fit` object.
#'
#' @param \dots Not used.
#'
#' @return
#' A `marshalled` object as described in [marshal()].
#'
#' @details
#' The `fit` element of the `model_fit` object is marshalled.
#'
#' @example incl/marshal.parsnip.R
#'
#' @rdname marshal.parsnip
#' @aliases marshal.model_fit
#' @export
marshal.model_fit <- function(x, ...) {
  x[["fit"]] <- marshal(x[["fit"]])
  res <- list(
    marshalled = x
  )
  class(res) <- marshal_class(x)
  
  ## IMPORTANT: We don't want any of the input arguments
  ## to be part of the unmarshal() environment
  rm(list = c("x", names(list(...))))
  
  res[["unmarshal"]] <- unmarshal_model_fit
  assert_no_references(res)
  res
}

unmarshal_model_fit <- function(x, ...) {
  object <- x[["marshalled"]]
  object[["fit"]] <- unmarshal(object[["fit"]])
  res <- object
  stopifnot(all.equal(class(res), marshal_unclass(x), check.attributes = FALSE))
  res
}
