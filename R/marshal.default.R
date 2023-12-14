#' Marshalling of an R objects
#'
#' @param x
#' An R object.
#'
#' @param \dots Not used.
#'
#' @return
#' A `marshalled` object as described in [marshal()].
#'
#' @details
#' This is the default, fallback method for marshalling of an
#' \R object.  It assumes that the object do not need specific
#' marshalling, but can be serialized as-is.  All this default
#' method does is wrapping the original object up in a 
#' `marshalled` object, so that the original object can be
#' recovered via `unmarshalled()`.
#'
#' @example incl/marshal.default.R
#'
#' @rdname marshal.default
#' @aliases marshal.default
#' @export
marshal.default <- function(x, ...) {
  res <- list(
    marshalled = x
  )
  class(res) <- marshal_class(x)
  
  res[["unmarshal"]] <- unmarshal_default
  
  res
}


unmarshal_default <- function(x, ...) {
  res <- x[["marshalled"]]
  stopifnot(all.equal(class(res), marshal_unclass(x), check.attributes = FALSE))
  res
}
