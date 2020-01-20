## Case for test of two categorical variable
## Basic settings of "Reminders Through Association"
#miss_p <- 0.7 # expect probability of missed the cue for "no cue"
#miss_n <- 80  # expect frequency of missed the cue for "no cue"
#respond_p <- 0.5 # expect probability of respond the cue for "no cue"
#respond_n <- 220 # expect frequency of missed the cue for "no cue"
Total_n <- 555 
Row_n <- c(183,372) ##2_miss,4_miss,2_respons,4_response 
Col_n <- c(153,152,150,100)

## Making of Sampling Distribution

i = 10000
chi <- NULL

while(i > 0){
  ## Sampling
  Row_1 <- sample(c(0,1,2,3), size = Row_n[1], replace = TRUE, prob = Col_n/Total_n )
  Row_2 <- sample(c(0,1,2,3), size = Row_n[2], replace = TRUE, prob = Col_n/Total_n )
  
  ## the simulated chi-squares 
  chi <- c(chi,
           sum(
             (sum(Row_1 == 0) - Row_n[1]*Col_n[1]/Total_n)^2/(Row_n[1]*Col_n[1]/Total_n),
             (sum(Row_1 == 1) - Row_n[1]*Col_n[2]/Total_n)^2/(Row_n[1]*Col_n[2]/Total_n),
             (sum(Row_1 == 2) - Row_n[1]*Col_n[3]/Total_n)^2/(Row_n[1]*Col_n[3]/Total_n),
             (sum(Row_1 == 3) - Row_n[1]*Col_n[4]/Total_n)^2/(Row_n[1]*Col_n[4]/Total_n),
             (sum(Row_2 == 0) - Row_n[2]*Col_n[1]/Total_n)^2/(Row_n[2]*Col_n[1]/Total_n),
             (sum(Row_2 == 1) - Row_n[2]*Col_n[2]/Total_n)^2/(Row_n[2]*Col_n[2]/Total_n),
             (sum(Row_2 == 2) - Row_n[2]*Col_n[3]/Total_n)^2/(Row_n[2]*Col_n[3]/Total_n),
             (sum(Row_2 == 3) - Row_n[2]*Col_n[4]/Total_n)^2/(Row_n[2]*Col_n[4]/Total_n)
           ))
           i = i-1
}

## Compute the accumulated frequencies of distributions
plot(density(chi),ylim=c(0,1))
lines(density(chi)$x, dchisq(density(chi)$x, df=1),col="red")
lines(density(chi)$x, dchisq(density(chi)$x, df=2),col="blue")
lines(density(chi)$x, dchisq(density(chi)$x, df=3),col="green")
## SS of sampling and probability functions
sum((density(chi)$y - dchisq(density(chi)$x, df=1) )^2)
sum((density(chi)$y - dchisq(density(chi)$x, df=2) )^2)
sum((density(chi)$y - dchisq(density(chi)$x, df=3) )^2)
sum((density(chi)$y - dchisq(density(chi)$x, df=4) )^2)

## Estimation of Type 1 Error
mean(chi > qchisq(.95,1,ncp=FALSE))
mean(chi > qchisq(.95,2,ncp=FALSE))
mean(chi > qchisq(.95,3,ncp=FALSE))
mean(chi > qchisq(.95,4,ncp=FALSE))

#sampling <- hist(chi, plot = FALSE)

## Plot of sampling distribution
#sampling_density <- sampling$counts/sum(sampling$counts)
plot(sampling$density, type = "h",xlab="test statistics",ylab="density",main="Sampling distribution of Null hypothesis",ylim=c(0,1))
lines(dchisq(sampling$breaks, df=2),col="blue")
lines(dchisq(sampling$breaks, df=3),col="green")

## SS of sampling and probability functions
sum((sampling$density - dchisq(1:length(sampling$density), df=1) )^2)
sum((sampling$density - dchisq(1:length(sampling$density), df=2) )^2)
sum((sampling$density - dchisq(1:length(sampling$density), df=3) )^2)

## Estimation of Type 1 Error
mean(chi > qchisq(.95,1,ncp=TRUE))
mean(chi > qchisq(.95,2,ncp=TRUE))
