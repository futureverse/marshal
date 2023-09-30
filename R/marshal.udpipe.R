#' Marshalling of 'udpipe' objects (not supported)
#'
#' _Warning: Objects of this class are not possible to marshal.
#'  If attempted, an error is produced._
#'
#' @param x "udpipe" object.
#'
#' @param \dots Not used.
#'
#' @return
#' A `marshalled` object as described in [marshal()].
#'
#' @rdname marshal.udpipe
#' @aliases marshallable.udpipe_model
#' @export
marshal.udpipe_model <- function(x, ...) {
  stop(MarshalNotSupportedError(object = x))
}


#' @rdname marshal.udpipe
#' @aliases marshallable.udpipe_model
#' @export
marshallable.udpipe_model <- function(...) {
  FALSE
}
