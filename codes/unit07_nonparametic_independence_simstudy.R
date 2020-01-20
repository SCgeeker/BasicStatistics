## https://www.rdatagen.net/post/a-little-intuition-and-simulation-behind-the-chi-square-test-of-independence-part-2/
library(tidyverse,magrittr)
library(simstudy)

im <- matrix(c(8,28,39,25,23,61,85,31,29,91,116,64),nrow = 4,dimnames = list(c("Glass","Cardboard","Plastic","Metal"),c(1,2,3)))
dm <- matrix(c(51,22,21,6,5,99,40,56,4,59,179,58),nrow = 4,dimnames = list(c("Glass","Cardboard","Plastic","Metal"),c(1,2,3)))
chisq.test(im)
chisq.test(dm)

addmargins(im)

row <- margin.table(im, 1)
col <- margin.table(im, 2)
N <- sum(row)

(expected <- (row/N) %*% t(col/N) * N)

set.seed(2021)

(lambdas <-  as.vector(t(expected)))

condU <- matrix(rpois(n = 10000*length(lambdas), 
                      lambda = lambdas), 
                nrow = length(lambdas))
condU[, 1:2]

condUm <- lapply(seq_len(ncol(condU)), 
                 function(i) matrix(condU[,i], length(row), length(col), byrow = T))

addmargins(condUm[[1]])

sumU <- avgMatrix(condUm, addMarg = T, sLabel = "U")

round(sumU$sampAvg, 0)

estX2 <- function(contMat, expMat) {
  X2 <- sum( (contMat - expMat)^2 / expMat)
  return(X2)
}

X2 <- sapply(condUm, function(x) estX2(x, expected))

head(X2)
hist(X2,freq = FALSE,density = TRUE)
sum(X2 > qchisq(.95,df=6))/10000

trueChisq <- rchisq(10000, 12)

# Comparing means
round(c( mean(X2), mean(trueChisq)), 1)

# Comparing variance
round(c( var(X2), var(trueChisq)), 1)
