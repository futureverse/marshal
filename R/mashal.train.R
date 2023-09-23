#' Marshal and Unmarshal a 'train' object
#'
#' @param train
#' A [caret::train] object.
#'
#' @param \dots Not used.
#'
#' @return
#' A `marshalled` object as described in [marshal()].
#'
#' @details
#' [bundle::bundle()] is used to produce a marshalled version
#' of the original object.
#' [bundle::unbundle()] is used to reconstruct a version of the
#' original object from the marshalled trainect.
#'
# @example incl/marshal.train.R
#'
#' @rdname marshal.train
#' @aliases marshal.train
#' @export
marshal.train <- function(train, ...) {
  res <- list(
    marshalled = bundle::bundle(train)
  )
  class(res) <- marshal_class(train)
  
  ## IMPORTANT: We don't want any of the input arguments
  ## to be part of the unmarshal() environment
  rm(list = c("train", names(list(...))))
  
  res[["unmarshal"]] <- unmarshal_train
  assert_no_references(res)
  res
  
}

unmarshal_train <- function(train, ...) {
  object <- train[["marshalled"]]
  res <- bundle::unbundle(object, ...)
  stopifnot(all.equal(class(res), marshal_unclass(train), check.attributes = FALSE))
  res
}
