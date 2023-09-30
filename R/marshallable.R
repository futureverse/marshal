#' Check if R object can be marshalled
#'
#' @param \dots The object to be checked,
#' followed by additional arguments passed to the specific S3 method.
#'
#' @return
#' `TRUE` if the object can be marshalled,
#' `FALSE` if it cannot be marshalled, and
#' `NA` if it is not known whether the object can be marshalled.
#'
#' @export
marshallable <- function(...) { UseMethod("marshallable") }

#' @export
marshallable.default <- function(...) {
  NA
}

#' @export
marshallable.marshalled <- function(...) {
  TRUE
}
