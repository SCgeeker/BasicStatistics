library(tidyverse)

## Simulate regression coefficient

## Population of regression coefficient 
sample_n <- 12 ## Setting of sample size
phi0 <- 0.6    ## Setting of correlation
sigma_x <- 0.5 ## Population sigma of X
sigma_y <- 1.5 ## Population sigma of Y

## making of sampling distribution of pearson's r
i = 10000
betas <- NULL

while (i > 0) {
  ## Step 1
  X <- rnorm(sample_n,sd = sigma_x)
  rawY <- rnorm(sample_n,sd = sigma_y)
  
  ## Step 2
  Y <- X*phi0 + rawY*((1-phi0^2)^0.5)
  
  ## Step 3
  ## by the formula of test statistics, see https://en.wikipedia.org/wiki/Pearson_correlation_coefficient
  betas <- c(betas,
             (sum((X-mean(X))*(Y-mean(Y)))/(sqrt(sum((X-mean(X))^2))*sqrt(sum((Y-mean(Y))^2))) )*(sd(Y)/sd(X))
            )
  
  i = i - 1
}

## The standard regression coefficient equals to the correlation.
paste0("In this sampling distribution of regression coefficient of ",
       phi0*(sigma_y/sigma_x),
       ", the average is ",round(mean(betas),2),
       ", the variance is ", round(var(betas),2),
       " that approaches the estimated variance:",
       (sigma_y^2/sigma_x^2)*(1-phi0^2)/(sample_n-3)
)
## Draw sampling correlations
##betas_samplings <- hist(betas,breaks = 100,plot = FALSE)

betas_d <- density(betas, n = 10000)
plot(betas_d,
     main = paste("Sampling Distribution of Regression Coefficients \n beta0 = ",phi0*(sigma_y/sigma_x),", N = ",sample_n),
     xlab = "Standard regression coefficients",
     ylab = "Density")
lines(x=betas_d$x,y=dnorm(betas_d$x,mean(betas),sd(betas)),col="blue")
