#' Marshal and Unmarshal a 'raster' object
#'
#' @param x
#' A \link[raster:raster]{raster:RasterLayer} object.
#'
#' @param \dots Not used.
#'
#' @return
#' A `marshalled` object as described in [marshal()].
#'
#' @details
#' [raster::writeRaster()] is used to produce a marshalled version
#' of the original object.
#' [raster::raster()] is used to reconstruct a version of the
#' original object from the marshalled object.
#'
#' @section WARNING: Numerical identical results cannot be guaranteed:
#' Marshalling of `RasterLayer` objects is _leaky_.  More precisely,
#' the method _cannot_ guarantee that multiple rounds of marshalling
#' and unmarshalling produce numerically identical objects.
#'
#' @example incl/marshal.raster.R
#'
#' @rdname marshal.RasterLayer
#' @aliases marshal.RasterLayer
#' @export
marshal.RasterLayer <- function(x, ...) {
  tf <- paste(tempfile(), c("grd", "gri"), sep = ".")
  names(tf) <- c("grd", "gri")
  on.exit(file.remove(tf))
  
  raster::writeRaster(x, filename = tf[["grd"]],
                     format = "raster", datatype = "INT4S")
  raw <- lapply(tf, FUN = function(file) {
    readBin(file, what = raw(), n = file.size(file), endian = "little")
  })

  res <- list(
    marshalled = raw
  )
  class(res) <- marshal_class(x)
  
  ## IMPORTANT: We don't want any of the input arguments
  ## to be part of the unmarshal() environment
  rm(list = c("x", names(list(...))))
  
  res[["unmarshal"]] <- unmarshal_RasterLayer
  assert_no_references(res)
  res
}

unmarshal_RasterLayer <- function(x, ...) {
  object <- x[["marshalled"]]
  
  tf <- paste(tempfile(), c("grd", "gri"), sep = ".")
  names(tf) <- c("grd", "gri")

  for (name in names(object)) {
    raw <- object[[name]]
    file <- tf[[name]]
    writeBin(raw, con = file, endian = "little")
  }
  
  res <- raster::raster(tf[["grd"]])
  stopifnot(all.equal(class(res), marshal_unclass(x), check.attributes = FALSE))
  res
}
