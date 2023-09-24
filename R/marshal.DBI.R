#' Marshal and Unmarshal a 'DBI:DBIConnection' object (not supported)
#'
#' _Warning: Objects of this class are not possible to marshal.
#'  If attempted, an error is produced._
#'
#' @param x A [DBI::DBIConnection-class] object.
#'
#' @param \dots Not used.
#'
#' @return
#' A `marshalled` object as described in [marshal()].
#'
#' @rdname marshal.DBI
#' @aliases marshal.DBIConnection
#' @export
marshal.DBIConnection <- function(x, ...) {
  stop(MarshalNotSupportedError(object = x))
}
