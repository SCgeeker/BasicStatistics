# Source data for bootstrap sampling
EXP_C <- c(3.33,3.67,2.67,3.33,3.33,3.67,4.67,2.67,6,4.33,3.33,0.67,1.33,0.33,2)        # from Source data
CON_C <- c(0.27,0.59,0.32,0.19,1.26,0.11,0.3,0.4,1.59,0.6,0.65,0.69,1.26,0.23,0.38)     # from Source data
N <- length(CON_C) # Original sample size was 15
DF <- N -1           # Degree of freedom
alpha <- .975            # Criterion for two-tail
## Making of sampling means by bootstrap
i = 10000                #
D_sim_means_H1 <- NULL   #
D_sim_means_H0 <- NULL   #
while (i > 0) {          #
  D_sim_means_H1 <- c(D_sim_means_H1, mean(sample(EXP_C, N, replace = TRUE) - sample(CON_C, N, replace = TRUE)) )       #
  D_sim_means_H0 <- c(D_sim_means_H0, mean(sample(CON_C, N, replace = TRUE) - sample(CON_C, N, replace = TRUE)) )       #
  i = i - 1              #
}                        #
## Draw sampling means
Title = paste("Sampling Distribution of H1(Blue) and H0(Red) \n Vertical lines refer to criterions \n Total sample size = ", N)   #
plot(density(D_sim_means_H0), main=Title, xlab = "Means of Difference",col="red",xlim=c(-1,6))                                          #
lines(density(D_sim_means_H1), col="blue")                                                                                              # 
abline(v=mean(D_sim_means_H0)+qt(alpha,DF),col="black")                                                                                 #
abline(v=mean(D_sim_means_H0)+qnorm(alpha),col="grey")                                                                                  #


sim_stat <- (D_sim_means_H1 - mean(D_sim_means_H1))/sd(D_sim_means_H1)
mean(sim_stat)
sd(sim_stat)
sim_stat_density <- density(sim_stat)
plot(sim_stat_density)
lines(x=sort(sim_stat), y=dnorm(sort(sim_stat),mean=mean(sim_stat),sd=sd(sim_stat)),col="green")
lines(x=sort(sim_stat), y=dt(sort(sim_stat),df=DF),col="red")

sum((sim_stat_density$y - dnorm(sim_stat_density$x,mean = mean(sim_stat), sd = sd(sim_stat)))^2, na.rm = TRUE)
sum((sim_stat_density$y - dt(sim_stat_density$x, df = DF))^2, na.rm = TRUE)

mean(sim_stat > qnorm(.975))
#mean(sim_stat > qt(.975,df=DF+1))
mean(sim_stat > qt(alpha,df=DF))
#mean(sim_stat > qt(.975,df=DF-1))


## Estimate errors by normal distribution
paste0("By normal distribution, Type 1 error is ", 100*mean(D_sim_means_H0 >mean(D_sim_means_H0)+qnorm(alpha)), "%")   #
paste0("By normal distribution, Type 2 error is ", 100*mean(D_sim_means_H1 <mean(D_sim_means_H0)+qnorm(alpha)), "%")   #
## Estimate errors by t distribution
paste0("By t distribution, Type 1 error is ", 100*mean(D_sim_means_H0 >mean(D_sim_means_H0)+qt(alpha,DF)), "%")        #
paste0("By t distribution, Type 2 error is ", 100*mean(D_sim_means_H1 <mean(D_sim_means_H0)+qt(alpha,DF)), "%")        #