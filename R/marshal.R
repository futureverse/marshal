#' Marshal and Unmarshal R Objects
#'
#' @param \dots The objects to be marshalled, or unmarshalled,
#' followed by additional arguments passed to the S3 method.
#'
#' @return
#' A marshaled version of the original object.
#'
#' @export
marshal <- function(...) { UseMethod("marshal") }

#' @return
#' An unmarshaled version of the original object.
#'
#' @rdname marshal
#' @export
unmarshal <- function(...) {
  UseMethod("unmarshal")
}
