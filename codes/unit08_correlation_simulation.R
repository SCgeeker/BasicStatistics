## Population of Pearson's r 
sample_n <- 100 ## Setting of sample size
phi0 <- 0.6    ## Setting of correlation

## Step 1
X <- rnorm(sample_n)
rawY <- rnorm(sample_n)

## Step 2
Y <- X*phi0 + rawY*((1-phi0^2)^0.5)

plot(Y~X, main=paste("r =",phi0))
