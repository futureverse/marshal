library(marshal)

if (requireNamespace("raster", quietly = TRUE)) {
  r <- raster::raster(system.file("external/test.grd", package = "raster"))
  print(r)
  
  ## Marshal
  r_ <- marshal(r)

  ## Unmarshal
  r2 <- unmarshal(r_)

  slots <- slotNames(r)
  slots <- setdiff(slots, c("data", "file", "srs"))
  for (name in slots) {
    stopifnot(all.equal(methods::slot(r2, name), methods::slot(r, name)))
  }

  ## Another round of marshalling
  r2_ <- marshal(r2)
  stopifnot({
    all.equal(r2_, r_)
    identical(r2_, r_)
  })
}
