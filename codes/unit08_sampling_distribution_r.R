library(tidyverse)

## Pearson’s r Correlation Simulator
## https://rlanders.net/correlation-simulator/
## Info about sampling distribution of pearson r: http://davidmlane.com/hyperstat/A98696.html

## Population of Pearson's r 
sample_n <- 12 ## Setting of sample size
phi0 <- 0.6    ## Setting of correlation

## making of sampling distribution of pearson's r
i = 10000
cors <- NULL

while (i > 0) {
  ## Step 1
  X <- rnorm(sample_n)
  rawY <- rnorm(sample_n)
  
  ## Step 2
  Y <- X*phi0 + rawY*((1-phi0^2)^0.5)
  
  ## Step 3
  ## by the formula of test statistics, see https://en.wikipedia.org/wiki/Pearson_correlation_coefficient
  cors <- c(cors,
            (sum((X-mean(X))*(Y-mean(Y)))/(sqrt(sum((X-mean(X))^2))*sqrt(sum((Y-mean(Y))^2))) )  
          )

  i = i - 1
}

## Fihser transformation
F_cors <- (1/2)*log((1+cors)/(1-cors))

paste0("Before Fisher transformation, in this sampling distribution of Pearson's r, ",
       phi0,
       ", the average is ",round(mean(cors),2),
       ", the variance is ", round(var(cors),3),
       "."
)

paste0("After Fisher transformation, in this sampling distribution of Pearson's r, ",
       phi0,
       ", the average is ",round(mean(F_cors),2),
       ", the variance is ", round(var(F_cors),3),
       " that approaches the estimated variance: ",
       round(1/(sample_n-3),3)
)


## Biased sampling: correlation < 0
#if(phi0 >=0){
#  prop = sum(cors < 0)/length(cors)
#} else{
#  prop = sum(cors > 0)/length(cors)
#}
#paste0("There are ", prop," sampled correlations on the other direction.")

## Draw sampling correlations by raw scores 
cors_d <- density(cors, n = 10000)
## Draw sampling correlations by Fisher transformation 
F_cors_d <- density(F_cors, n = 10000)
plot(cors_d,
     main = paste("Sampling Distribution of Pearson's r \n phi0 = ",phi0,", N = ",sample_n),
     xlab = "Pearson's r",
     ylab = "Density",
     xlim = c(-0.5,2))
lines(x=cors_d$x,y=dnorm(cors_d$x,mean(cors),sd(cors)),col="green")
lines(F_cors_d,col="red")
lines(x=F_cors_d$x,y=dnorm(F_cors_d$x,mean(F_cors),sd(F_cors)),col="blue")

sum((F_cors_d$y - dnorm(F_cors_d$x,mean(F_cors),sd(F_cors)))^2)

## Critical t at alpha = .05 and sample size
## Source: https://en.wikipedia.org/wiki/Pearson_correlation_coefficient#Testing_using_Student's_t-distribution
N <- 1:250
rs <- qt(.975,N)/sqrt(N - 2 + qt(.975,N)^2)
plot(rs ~ N, type="l")



## Source: https://stats.stackexchange.com/questions/191937/what-is-the-distribution-of-sample-correlation-coefficients-between-two-uncorrel
## 



m <- sapply(X = 1:100, FUN = function(x) rnorm(12))

cors <- cor(m, method = "pearson") 
cors <- cors[upper.tri(cors)] ## Get upper correlations

density(cors) %>% plot()
lines(x=density(cors)$x,y=dnorm(density(cors)$x), col="red")


df <- data.frame(id = 1:length(cors),cors)

p <- ggplot(df, aes(x=cors)) +
  geom_density()
p


cor.data <- cors[upper.tri(cors, diag = FALSE)] %>%  # we're only interested in one of the off-diagonals, otherwise there'd be duplicates
  as.data.frame()  # that's how ggplot likes it
summary(cor.data)
colnames(cor.data) <- "pearson"
pearson.p <- function(r, n) {
  pofr <- ((1-r^2)^((n-4)/2))/beta(a = 1/2, b = (n-2)/2)
  return(pofr)
}
#g <- NULL
g <- ggplot(data = cor.data, mapping = aes(x = pearson)) + 
  xlim(-1,1) +  # actual limits of pearsons r
  geom_histogram(mapping = aes(y = ..density..)) +
  stat_function(fun = pearson.p, colour = "red", args = list(n = nrow(m)))
g


## Check: https://stats.stackexchange.com/questions/195496/expected-correlation-of-sample-correlations
## Expected correlation of sample correlations

library(MASS)

pxz =  0.10   # population correlation of X and Z
pyz =  0.05   # population correlation of Y and Z
pxy = -0.50   # population correlation of X and Y
N = 100000    # population size
n = 100       # sample size
m = 1000      # number of samples to draw

# generate population data
data = mvrnorm(N, mu=c(0, 0, 0), Sigma=matrix(c(1, pxy, pxz, pxy, 1, pyz, pxz, pyz, 1), 3));
X = data[, 1]
Y = data[, 2]
Z = data[, 3]

# verify the sampling distribution of rxz and ryz
r = t(sapply(1:m, function(., i=sample(N, n)) c(cor(X[i], Z[i]), cor(Y[i], Z[i]))))
tanh(apply(atanh(r), 2, mean)) # ~= c(pxz, pyz)
apply(atanh(r), 2, sd) # ~= 1/sqrt(n-3) * sqrt(N-n)/sqrt(N-1)

# calculate the correlation of m sample correlations 100 times
vals = replicate(100,cor(t(sapply(1:m, function(., i=sample(N, n)) c(cor(X[i], Z[i]), cor(Y[i], Z[i])))))[2])
mean(vals) # ~= pxy
