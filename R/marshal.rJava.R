#' Marshalling of 'rJava' objects (not supported)
#'
#' _Warning: Objects of this class are not possible to marshal.
#'  If attempted, an error is produced._
#'
#' @param x "rJava" object.
#'
#' @param \dots Not used.
#'
#' @return
#' A `marshalled` object as described in [marshal()].
#'
#' @rdname marshal.rJava
#' @aliases marshal.jclassName
#' @export
marshal.jclassName <- function(x, ...) {
  stop(MarshalNotSupportedError(object = x))
}


#' @rdname marshal.rJava
#' @aliases marshallable.jobjRef
#' @export
marshal.jobjRef <- function(x, ...) {
  stop(MarshalNotSupportedError(object = x))
}



#' @rdname marshal.rJava
#' @aliases marshallable.jclassName
#' @export
marshallable.jclassName <- function(...) {
  FALSE
}


#' @rdname marshal.rJava
#' @aliases marshallable.jclassName
#' @export
marshallable.jobjRef <- function(...) {
  FALSE
}
