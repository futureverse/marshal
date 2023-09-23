if (requireNamespace("raster", quietly = TRUE)) {
  r <- raster::raster(system.file("external/test.grd", package = "raster"))
  print(r)
  
  ## Marshal
  r_ <- marshal(r)

  ## Unmarshal
  r2 <- unmarshal(r_)
}
