#' Marshal and Unmarshal a 'keras' object
#'
#' @param model
#' A \link[keras:keras_model]{keras:keras.engine.base_layer.Layer} object.
#'
#' @param \dots Not used.
#'
#' @return
#' A `marshalled` object as described in [marshal()].
#'
#' @details
#' [keras::serialize_model()] is used to produce a marshalled version
#' of the original object.
#' [keras::unserialize_model()] is used to reconstruct a version of the
#' original object from the marshalled object.
#'
#' @example incl/marshal.keras.R
#'
#' @rdname marshal.keras.engine.base_layer.Layer
#' @aliases marshal.keras.engine.base_layer.Layer
#' @export
marshal.keras.engine.base_layer.Layer <- function(model, ...) {
  res <- list(
    marshalled = keras::serialize_model(model)
  )
  class(res) <- marshal_class(model)
  
  ## IMPORTANT: We don't want any of the input arguments
  ## to be part of the unmarshal() environment
  rm(list = c("model", names(list(...))))
  
  res[["unmarshal"]] <- unmarshal_keras.engine.base_layer.Layer
  assert_no_references(res)
  res
}

unmarshal_keras.engine.base_layer.Layer <- function(model, ...) {
  object <- model[["marshalled"]]
  res <- keras::unserialize_model(object)
  stopifnot(all.equal(class(res), marshal_unclass(model), check.attributes = FALSE))
  res
}
