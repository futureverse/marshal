library(marshal)

if (requireNamespace("xml2", quietly = TRUE)) {
  doc <- xml2::read_xml("<body></body>")

  ## Marshal 'xml_document' object
  doc_ <- marshal(doc)

  ## Unmarshal 'xml_document' object
  doc2 <- unmarshal(doc_)

  stopifnot(all.equal(doc2, doc))
}
