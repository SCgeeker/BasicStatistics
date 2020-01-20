## Case for test of two categorical variable
## Basic settings of "Reminders Through Association"
#miss_p <- 0.7 # expect probability of missed the cue for "no cue"
#miss_n <- 80  # expect frequency of missed the cue for "no cue"
#respond_p <- 0.5 # expect probability of respond the cue for "no cue"
#respond_n <- 220 # expect frequency of missed the cue for "no cue"
Total_n <- 135 
Row_n <- rep(Total_n/3,3) ##2_miss,4_miss,2_respons,4_response 
#Col_n <- c(135)

## Making of Sampling Distribution

i = 10000
chi <- NULL

while(i > 0){
  ## Sampling
  Row_1 <- sample(c(0,1,2), size = Total_n, replace = TRUE, prob = Row_n/Total_n )
  #Row_2 <- sample(c(0,1,2), size = Row_n[2], replace = TRUE, prob = Col_n/Total_n )
  
  ## the simulated chi-squares 
  chi <- c(chi,
           sum(
             (sum(Row_1 == 0) - Row_n[1])^2/(Row_n[1]),
             (sum(Row_1 == 1) - Row_n[2])^2/(Row_n[2]),
             (sum(Row_1 == 2) - Row_n[3])^2/(Row_n[3])
           ))
  i = i-1
}

## Compute the accumulated frequencies of distributions
sampling <- hist(chi, plot = FALSE)

## Plot of sampling distribution
#sampling_density <- sampling$counts/sum(sampling$counts)
plot(sampling$density, type = "h",xlab="test statistics",ylab="density",main="Sampling distribution of Null hypothesis",ylim=c(0,1))
lines(dchisq(sampling$breaks, df=1),col="red")
lines(dchisq(sampling$breaks, df=2),col="blue")

## SS of sampling and probability functions
sum((sampling$density - dchisq(1:length(sampling_density), df=1) )^2)
sum((sampling$density - dchisq(1:length(sampling_density), df=2) )^2)

## Estimation of Type 1 Error
mean(chi > qchisq(.95,1,ncp=TRUE))
mean(chi > qchisq(.95,2,ncp=TRUE))

