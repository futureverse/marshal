#' Marshal and Unmarshal a 'parallel' cluster object (not supported)
#'
#' _Warning: Objects of this class are not possible to marshal.
#'  If attempted, an error is produced._
#'
#' @param x A \link[magick:magick]{magick:magick-image} object.
#'
#' @param \dots Not used.
#'
#' @return
#' A `marshalled` object as described in [marshal()].
#'
#' @rdname marshal.parallel
#' @aliases marshal.SOCKcluster
#' @aliases marshal.SOCKnode
#' @aliases marshal.SOCK0node
#' @export
marshal.SOCKcluster <- function(x, ...) {
  stop(MarshalNotSupportedError(object = x))
}


#' @export
marshal.SOCKnode <- function(x, ...) {
  stop(MarshalNotSupportedError(object = x))
}


#' @export
marshal.SOCK0node <- function(x, ...) {
  stop(MarshalNotSupportedError(object = x))
}
