#' Marshalling of 'XML' objects
#'
#' @param xml
#' An \link[XML:XMLAbstractNode-class]{XML::XMLAbstractNode} or
#' \link[XML:XMLAbstractDocument-class]{XML::XMLAbstractDocument}.
#'
#' @param \dots Not used.
#'
#' @return
#' A `marshalled` object as described in [marshal()].
#'
#' @details
#' [XML::xmlSerializeHook()] is used to produce a marshalled version
#' of the original object.
#' [XML::xmlDeserializeHook()] is used to reconstruct a version of the
#' original object from the marshalled object.
#'
#' @example incl/marshal.XML.R
#'
#' @rdname marshal.XML
#' @aliases marshal.XML
#' @export
marshal.XMLAbstractNode <- function(xml, ...) {
  marshal_XML(xml, ...)
}

#' @rdname marshal.XML
#' @export
marshal.XMLAbstractDocument <- function(xml, ...) {
  marshal_XML(xml, ...)
}

marshal_XML <- function(xml, ...) {
  res <- list(
    marshalled = XML::xmlSerializeHook(xml)
  )
  class(res) <- marshal_class(xml)

  ## IMPORTANT: We don't want any of the input arguments
  ## to be part of the unmarshal() environment
  rm(list = c("xml", names(list(...))))
  
  res[["unmarshal"]] <- unmarshal_XML
  
  assert_no_references(res)
  res
}

unmarshal_XML <- function(xml, ...) {
  object <- xml[["marshalled"]]
  res <- XML::xmlDeserializeHook(object)
  stopifnot(identical(class(res), marshal_unclass(xml)))
  res
}
