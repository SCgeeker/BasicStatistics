# Source data for bootstrap sampling
EXP_G <- c(14,4,23,22,16,10,16,18,23,10,13,23,4,23,10,18,11,11,25,9,18,11,11,24)        # from Source data
CON_G <- c(4,12,11,16,9,12,3,11,10,8,12,6,11,16,11,8,15,10,15,14,9,11,13,3,22)     # from Source data
EXP_N <- length(EXP_G)   # Original sample size was 24
CON_N <- length(CON_G)   # Original sample size was 25
DF <- EXP_N + CON_N -1   # Degree of freedom
alpha <- .975            # Criterion for two-tail
## Making of sampling means by bootstrap
i = 10000                #
D_sim_means_H1 <- NULL   #
D_sim_means_H0 <- NULL   #
while (i > 0) {          #
  D_sim_means_H1 <- c(D_sim_means_H1, mean(sample(EXP_C, EXP_N, replace = TRUE)) - mean(sample(CON_C, CON_N, replace = TRUE)) )       #
  D_sim_means_H0 <- c(D_sim_means_H0, mean(sample(CON_C, CON_N, replace = TRUE)) - mean(sample(CON_C, CON_N, replace = TRUE)) )       #
  i = i - 1              #
}                        #
## Draw sampling means
Title = paste("Sampling Distribution of H1(Blue) and H0(Red) \n Vertical lines refer to criterions \n Total sample size = ", DF )   #
plot(density(D_sim_means_H0), main=Title, xlab = "Difference of Means",col="red",xlim=c(-1,6))                                          #
lines(density(D_sim_means_H1), col="blue")                                                                                              # 
abline(v=mean(D_sim_means_H0)+qt(alpha,DF),col="black")                                                                                 #
abline(v=mean(D_sim_means_H0)+qnorm(alpha),col="grey")                                                                                  #
## Estimate errors by normal distribution
paste0("By normal distribution, Type 1 error is ", 100*mean(D_sim_means_H0 >mean(D_sim_means_H0)+qnorm(alpha)), "%")   #
paste0("By normal distribution, Type 2 error is ", 100*mean(D_sim_means_H1 <mean(D_sim_means_H0)+qnorm(alpha)), "%")   #
## Estimate errors by t distribution
paste0("By t distribution, Type 1 error is ", 100*mean(D_sim_means_H0 >mean(D_sim_means_H0)+qt(alpha,DF)), "%")        #
paste0("By t distribution, Type 2 error is ", 100*mean(D_sim_means_H1 <mean(D_sim_means_H0)+qt(alpha,DF)), "%")        #