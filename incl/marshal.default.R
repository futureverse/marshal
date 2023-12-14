x <- data.frame(a = 1:3, b = letters[1:3])
x_ <- marshal(x)
x2 <- unmarshal(x_)
stopifnot(identical(x2, x))


