library(marshal)

tf <- tempfile()
cat(file = tf, letters, sep = "")

## Read-only connection
con <- file(tf, open = "rb")

bfr <- readChar(con, nchars = 4L)
print(bfr)  ## "abcd"

## Marshal read-only connection, which records the
## current state, including the current file position.
con_ <- marshal(con)

## Unmarshal connection, which restores the state
## of the original connection
con2 <- unmarshal(con_)
stopifnot(
  all.equal(summary(con2), summary(con)),
  identical(seek(con2), seek(con))
)

bfr <- readChar(con, nchars = 4L)
print(bfr)
bfr2 <- readChar(con2, nchars = 4L)
print(bfr2)
stopifnot(identical(bfr2, bfr))

## Cleanup
close(con)
close(con2)
file.remove(tf)
