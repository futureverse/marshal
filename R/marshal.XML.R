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
  res <- XML::xmlSerializeHook(xml)
  class(res) <- marshal_class(xml)
  res
}

unmarshal_XML <- function(xml, ...) {
  res <- XML::xmlDeserializeHook(xml)
  stopifnot(identical(class(res), marshal_unclass(xml)))
  res
}
