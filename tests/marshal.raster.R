library(marshal)

if (requireNamespace("raster", quietly = TRUE)) {
  r <- raster::raster(system.file("external/test.grd", package = "raster"))
  print(r)

  ## Marshal
  r_ <- marshal(r)

  ## Unmarshal
  r2 <- unmarshal(r_)

  slots <- slotNames(r)
  slots <- setdiff(slots, c(
  "data", "file", "srs"))
  for (name in slots) {
    res <- all.equal(methods::slot(r2, name), methods::slot(r, name))
    if (!isTRUE(res)) print(res)
    stopifnot(res)
  }

  ## Another round of marshalling
  r2_ <- marshal(r2)

  ## FIXME: This cannot be guaranteed; if we run this example many
  ## times, there will be situations where one raw "grd" byte differs
  ## by a value of 1L. /HB 2023-09-23
  if (FALSE) {
    stopifnot({
      all.equal(r2_, r_)
      identical(r2_, r_)
    })
  }
}
