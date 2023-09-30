#' Marshalling of 'sparklyr' objects (not supported)
#'
#' _Warning: Objects of this class are not possible to marshal.
#'  If attempted, an error is produced._
#'
#' @param x "sparklyr" object.
#'
#' @param \dots Not used.
#'
#' @return
#' A `marshalled` object as described in [marshal()].
#'
#' @rdname marshal.sparklyr
#' @aliases marshallable.tbl_spark
#' @export
marshal.tbl_spark <- function(x, ...) {
  stop(MarshalNotSupportedError(object = x))
}


#' @rdname marshal.sparklyr
#' @aliases marshallable.tbl_spark
#' @export
marshallable.tbl_spark <- function(...) {
  FALSE
}
