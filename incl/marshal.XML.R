xml <- XML::xmlParseString("<a><b>c</b></a>")
print(xml)

## Marshal XMLAbstractNode object
xml_ <- marshal(xml)
## Unmarshal XMLAbstractNode object
xml2 <- unmarshal(xml_)
print(xml2)

stopifnot(all.equal(xml2, xml))
