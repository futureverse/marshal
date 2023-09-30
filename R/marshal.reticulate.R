#' Marshalling of 'reticulate' objects (not supported)
#'
#' _Warning: Objects of this class are not possible to marshal.
#'  If attempted, an error is produced._
#'
#' @param x "reticulate" object.
#'
#' @param \dots Not used.
#'
#' @return
#' A `marshalled` object as described in [marshal()].
#'
#' @rdname marshal.reticulate
#' @aliases marshal.python.builtin.object
#' @export
marshal.python.builtin.object <- function(x, ...) {
  stop(MarshalNotSupportedError(object = x))
}


#' @rdname marshal.reticulate
#' @aliases marshallable.python.builtin.object
#' @export
marshallable.python.builtin.object <- function(...) {
  FALSE
}
