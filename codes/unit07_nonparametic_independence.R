## Case for test of two categorical variable
## Basic settings of "Reminders Through Association"
miss_p <- 0.7 # expect probability of missed the cue for "no cue"
miss_n <- 80  # expect frequency of missed the cue for "no cue"
respond_p <- 0.5 # expect probability of respond the cue for "no cue"
respond_n <- 220 # expect frequency of missed the cue for "no cue"

## Making of Sampling Distribution

i = 10000
chi <- NULL

while(i > 0){
  ## Sampling
  miss_o <- sample(c(0,1), size = miss_n, replace = TRUE, prob = c(miss_p,1-miss_p))
  respond_o <- sample(c(0,1), size = respond_n, replace = TRUE, prob = c(respond_p,1-respond_p))
  
  ## the simulated chi-squares 
  chi <- c(chi,
           sum(
             (sum(miss_o == 1) - miss_n*miss_p)^2/miss_n*miss_p,
             (sum(miss_o == 0) - miss_n*(1 - miss_p))^2)/miss_n*(1 - miss_p),
             (sum(respond_o == 1) - respond_n*respond_p)^2/respond_n*respond_p,
             (sum(respond_o == 0) - respond_n*(1 - respond_p))^2/respond_n*(1 - respond_p)
           )
           i = i-1
}

## Compute the accumulated frequencies of distributions
sampling <- hist(chi, plot = FALSE)
#chisq_df1 <- hist(rchisq(10000,df=1))
#chisq_df2 <- hist(rchisq(10000,df=2))

## Plot of sampling distribution
sampling_density <- sampling$counts/sum(sampling$counts)
plot(sampling_density,type = "h",xlab="test statistics",ylab="density",ylim=c(0,1))
lines(dchisq(sampling$breaks, df=1),col="red")
lines(dchisq(sampling$breaks, df=2),col="blue")

## SS of sampling and probability functions
sum((sampling_density - dchisq(1:length(sampling_density), df=1) )[-1]^2)
sum((sampling_density - dchisq(1:length(sampling_density), df=2) )[-1]^2)


