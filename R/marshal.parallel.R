#' Marshalling of 'parallel' objects (not supported)
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
#' @export
marshal.SOCKcluster <- function(x, ...) {
  stop(MarshalNotSupportedError(object = x))
}


#' @rdname marshal.parallel
#' @aliases marshal.SOCKnode
#' @export
marshal.SOCKnode <- function(x, ...) {
  stop(MarshalNotSupportedError(object = x))
}


#' @rdname marshal.parallel
#' @aliases marshal.SOCK0node
#' @export
marshal.SOCK0node <- function(x, ...) {
  stop(MarshalNotSupportedError(object = x))
}



#' @rdname marshal.parallel
#' @aliases marshallable.SOCKcluster
#' @export
marshallable.SOCKcluster <- function(...) {
  FALSE
}


#' @rdname marshal.parallel
#' @aliases marshallable.SOCKnode
#' @export
marshallable.SOCKnode <- function(...) {
  FALSE
}


#' @rdname marshal.parallel
#' @aliases marshallable.SOCK0node
#' @export
marshallable.SOCK0node <- function(...) {
  FALSE
}
