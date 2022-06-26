library(terra)

file <- system.file("ex/lux.shp", package = "terra")
v <- vect(file)

## Marshal SpatVector object
v_ <- marshal(v)

## Unmarshal SpatVector object
v2 <- unmarshal(v_)

stopifnot(all.equal(v2, v, check.attributes = FALSE))

