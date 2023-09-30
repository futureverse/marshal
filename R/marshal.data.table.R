#' Marshalling of 'data.table' objects
#'
#' @param x
#' A [data.table::data.table] object.
#'
#' @param \dots Not used.
#'
#' @return
#' A `marshalled` object as described in [marshal()].
#'
#' @example incl/marshal.data.table.R
#'
#' @rdname marshal.data.table
#' @aliases marshal.data.table
#' @export
marshal.data.table <- function(x, ...) {
  ## Remove optional external pointer
  attr(x, ".internal.selfref") <- NULL
  
  res <- list(
    marshalled = x
  )
  class(res) <- marshal_class(x)
  
  ## IMPORTANT: We don't want any of the input arguments
  ## to be part of the unmarshal() environment
  rm(list = c("x", names(list(...))))
  
  res[["unmarshal"]] <- unmarshal_data.table
  assert_no_references(res)
  res
}

unmarshal_data.table <- function(x, ...) {
  object <- x[["marshalled"]]
  res <- data.table::as.data.table(object)
  stopifnot(all.equal(class(res), marshal_unclass(x), check.attributes = FALSE))
  res
}


#' @rdname marshal.data.table
#' @aliases marshallable.data.table
#' @export
marshallable.data.table <- function(...) {
  TRUE
}
