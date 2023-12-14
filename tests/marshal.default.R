library(marshal)

objects <- list(
  1:3,
  rnorm(3),
  as.list(1:3),
  data.frame(a = 1:3, b = letters[1:3])
)

for (x in objects) {
  x_ <- marshal(x)
  x2 <- unmarshal(x_)
  stopifnot(identical(x2, x))
}

