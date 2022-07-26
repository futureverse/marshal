library(marshal)

con <- url("https://www.r-project.org")
print(con)

## Marshal read-only connection, which records the
## current state, including the current file position.
con_ <- marshal(con)

## Unmarshal connection, which restores the state
## of the original connection
con2 <- unmarshal(con_)
print(con2)

stopifnot(all.equal(summary(con2), summary(con)))

bfr <- readChar(con, nchars = 100L)
print(bfr)
bfr2 <- readChar(con2, nchars = 100L)
print(bfr2)
stopifnot(identical(bfr2, bfr))

## Cleanup
close(con)
close(con2)

