#' @param terra
#' An \link[terra:SpatVector-class]{terra::SpatVector}.
#'
#' @example incl/marshal.terra.R
#'
#' @rdname marshal
#' @export
marshal.SpatVector <- function(terra, ...) {
  res <- list(
    marshalled = terra::wrap(terra, ...)
  )
  class(res) <- marshal_class(terra)
  
  ## IMPORTANT: We don't any of the input arguments to be part
  ## of the unmarshal() environment
  rm(list = c("terra", names(list(...))))
  
  res[["unmarshal"]] <- function(x) {
    object <- x[["marshalled"]]
    res <- terra::vect(object)
    stopifnot(all.equal(class(res), marshal_unclass(x), check.attributes = FALSE))
    res
  }
  assert_no_references(res)
  res
}

#' @export
unmarshal.SpatVector_marshalled <- function(terra, ...) {
  object <- terra[["marshalled"]]
  res <- terra::vect(object, ...)
  stopifnot(all.equal(class(res), marshal_unclass(terra), check.attributes = FALSE))
  res
}
