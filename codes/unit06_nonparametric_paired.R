library(dplyr)

## Case for test of two categorical variable
## Basic settings
Target_N <- 30
Switch_P <- 0.5

## 

i = 10000
chi <- NULL

set.seed(100)        
while(i > 0){
  ## Sampling
  ## the simulated chi-squares 
  chi <- c(chi,
           (sample(c("Switch_1","Switch_2"), size = Target_N, replace = TRUE, prob = c(Switch_P,1-Switch_P)) %>%
              table() %>% 
              as.vector() %>% 
              diff())^2/Target_N
  )
  i = i-1
}

sampling <- hist(chi)


## Plot of sampling distribution
plot(sampling$counts/10000,type = "h",main = "",
     xlab="test statistics",ylab="probability",ylim=c(0,1))
lines(dchisq(sampling$breaks, df=1),col="red")
lines(dchisq(sampling$breaks, df=2),col="blue")


## SS of sampling and probability functions
sum(( (sampling$counts/10000) - dchisq(sampling$breaks, df=1))[-1]^2)
sum(( (sampling$counts/10000) - dchisq(sampling$breaks, df=2))[-1]^2)


