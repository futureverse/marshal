#' Marshal and Unmarshal an 'ncdf4' object
#'
#' @param x
#' A \link[ncdf4:nc_create]{ncdf4:ncdf4} object.
#'
#' @param \dots Not used.
#'
#' @return
#' A `marshalled` object as described in [marshal()].
#'
#' @details
#' [base::readBin()] is used to produce a marshalled version
#' of the original object.
#' [base::writeBin()] and [ncdf4::nc_open()] are used to
#' reconstruct a version of the original object from the
#' marshalled object.
#'
#' @example incl/marshal.ncdf4.R
#'
#' @rdname marshal.ncdf4
#' @aliases marshal.ncdf4
#' @export
marshal.ncdf4 <- function(x, ...) {
  file <- x[["filename"]]
  raw <- readBin(file, what = raw(), n = file.size(file), endian = "little")
  
  res <- list(
    marshalled = raw
  )
  class(res) <- marshal_class(x)
  
  ## IMPORTANT: We don't want any of the input arguments
  ## to be part of the unmarshal() environment
  rm(list = c("x", names(list(...))))
  
  res[["unmarshal"]] <- unmarshal_ncdf4
  assert_no_references(res)
  res
}

unmarshal_ncdf4 <- function(x, ...) {
  object <- x[["marshalled"]]
  
  tf <- tempfile(fileext = ".nc")
  writeBin(object, con = tf, endian = "little")
  
  res <- ncdf4::nc_open(tf)
  stopifnot(all.equal(class(res), marshal_unclass(x), check.attributes = FALSE))
  res
}
