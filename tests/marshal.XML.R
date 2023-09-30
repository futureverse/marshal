library(marshal)

if (requireNamespace("XML", quietly = TRUE)) {
  node <- XML::xmlParseString("<a><b>c</b></a>")
  print(node)

  ## Assert marshallability
  stopifnot(marshallable(node))

  ## Marshal XMLAbstractNode object
  node_ <- marshal(node)
  ## Unmarshal XMLAbstractNode object
  node2 <- unmarshal(node_)
  print(node2)
  
  stopifnot(all.equal(node2, node))
  
  
  doc <- XML::xmlParse(system.file("exampleData", "tides.xml", package = "XML"))

  ## Assert marshallability
  stopifnot(marshallable(doc))

  ## Marshal XMLAbstractDocument object
  doc_ <- marshal(doc)
  ## Unmarshal XMLAbstractDocument object
  doc2 <- unmarshal(doc_)
  
  stopifnot(all.equal(doc2, doc))
}
