#' Marshalling of 'magick' objects (not supported)
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
#' @rdname marshal.magick
#' @aliases marshal.magick-image
#' @export
`marshal.magick-image` <- function(x, ...) {
  stop(MarshalNotSupportedError(object = x))
}


#' @rdname marshal.magick
#' @aliases marshallable.magick-image
#' @export
`marshallable.magick-image` <- function(...) {
  FALSE
}
