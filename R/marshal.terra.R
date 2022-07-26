#' Marshal and Unmarshal a 'terra' object
#'
#' @param terra
#' An \link[terra:SpatVector-class]{terra::SpatVector}.
#'
#' @param \dots Not used.
#'
#' @return
#' A `marshalled` object as described in [marshal()].
#'
#' @details
#' [terra::wrap()] is used to produce a marshalled version
#' of the original object.
#' [terra::vect()] is used to reconstruct a version of the
#' original object from the marshalled object.
#'
#' @example incl/marshal.terra.R
#'
#' @rdname marshal.terra
#' @aliases marshal.terra
#' @export
marshal.SpatVector <- function(terra, ...) {
  res <- list(
    marshalled = terra::wrap(terra)
  )
  class(res) <- marshal_class(terra)
  
  ## IMPORTANT: We don't want any of the input arguments
  ## to be part of the unmarshal() environment
  rm(list = c("terra", names(list(...))))
  
  res[["unmarshal"]] <- unmarshal_SpatVector
  assert_no_references(res)
  res
}

unmarshal_SpatVector <- function(terra, ...) {
  object <- terra[["marshalled"]]
  res <- terra::vect(object, ...)
  stopifnot(all.equal(class(res), marshal_unclass(terra), check.attributes = FALSE))
  res
}
