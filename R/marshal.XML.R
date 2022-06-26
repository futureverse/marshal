#' @param xml
#' An \link[XML:XMLAbstractNode-class]{XML::XMLAbstractNode} or
#' \link[XML:XMLAbstractDocument-class]{XML::XMLAbstractDocument}.
#'
#' @example incl/marshal.XML.R
#'
#' @rdname marshal
#' @export
marshal.XMLAbstractNode <- function(xml, ...) {
  marshal_XML(xml, ...)
}

#' @export
unmarshal.XMLAbstractNode_marshalled <- function(xml, ...) {
  unmarshal_XML(xml, ...)
}


#' @export
marshal.XMLAbstractDocument <- function(xml, ...) {
  marshal_XML(xml, ...)
}

#' @export
unmarshal.XMLAbstractDocument_marshalled <- function(xml, ...) {
  unmarshal_XML(xml, ...)
}


marshal_XML <- function(xml, ...) {
  res <- list(
    marshalled = XML::xmlSerializeHook(xml)
  )
  class(res) <- marshal_class(xml)

  ## IMPORTANT: We don't any of the input arguments to be part
  ## of the unmarshal() environment
  rm(list = c("xml", names(list(...))))
  
  res[["unmarshal"]] <- function(x) {
    object <- xml[["marshalled"]]
    res <- XML::xmlDeserializeHook(object)
    stopifnot(identical(class(res), marshal_unclass(object)))
    res
  }
  
  assert_no_references(res)
  res
}

unmarshal_XML <- function(xml, ...) {
  object <- xml[["marshalled"]]
  res <- XML::xmlDeserializeHook(object)
  stopifnot(identical(class(res), marshal_unclass(xml)))
  res
}
