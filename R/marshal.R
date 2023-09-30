#' Marshalling of R objects
#'
#' @param \dots The object to be marshalled, or unmarshalled,
#' followed by additional arguments passed to the specific S3 method.
#'
#' @return
#' `marshal()` returns a `marshalled` object, which is a list with
#' components:
#'   * `marshalled`: marshalled version of the original object
#'   * `unmarshal`: function that takes the `marshalled` object as
#'     input and returns an unmarshalled version of the original object.
#'
#' @export
marshal <- function(...) { UseMethod("marshal") }

#' @return
#' `unmarshal()` returns an unmarshalled version of the original object.
#'
#' @rdname marshal
#' @export
unmarshal <- function(...) {
  UseMethod("unmarshal")
}

#' @export
unmarshal.marshalled <- function(object, ...) {
  stopifnot(is.function(object[["unmarshal"]]))
  object[["unmarshal"]](object, ...)
}
