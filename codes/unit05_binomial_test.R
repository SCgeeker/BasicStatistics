## Settings of sampling distribution
TT_outcomes_N <- 150       ## Number of collected responses
TT_outcomes_correct <- 70  ## Number of correct responses
TT_acc0 <- 0.5             ## H0: Accuracy of TTs who have no the skill
TT_acc1 <- 0.9             ## H0: Accuracy of TTs who have the skill
TN <- .95                  ## True Negative Rate

# Population of outcomes
plot(x=0:1, y = dbinom(0:1,size = 1, prob = 0.5),type="h",
     main="Population of binary outcomes",
     xlab="Proportion",
     ylab="Density")

# Sampling distribution of outcomes
i = 10000
sim_TT <- NULL
while (i > 0) {
  n <- TT_outcomes_N
  sim_TT <- rbind(sim_TT, c(mean(rbinom(n,size = 1,prob=TT_acc0)), mean(rbinom(n,size = 1,prob=TT_acc1))) )
  i = i - 1
}

colnames(sim_TT) <- c("H0","H1")

sim_density <- data.frame(qx <- density(sim_TT[,"H0"])$x, dx <- density(sim_TT[,"H0"])$y)

## Plotting Exact test
N_correct <- TT_outcomes_correct
N_incorrect <- TT_outcomes_N - TT_outcomes_correct
N <- N_correct + N_incorrect

## Summarize the expect values of H0 and H1
paste0("Expect value of H0 is ",(TT_outcomes_N*TT_acc0)/TT_outcomes_N,"; Expect value of H1 is ",(TT_outcomes_N*TT_acc1)/TT_outcomes_N )

Title = paste("Sampling Distribution of binary outcomes \n Mean = ",round(mean(sim_TT[,"H0"]),2),"; Variance =", round(mean((sim_TT[,"H0"])^2) - (mean(sim_TT[,"H0"]))^2, 4), "\n Black line refers to the criterion" )
plot(sim_density, main=Title, xlab = "Proportion", type="l", ylab="Sampling Density")
lines(x = sim_density$qx[sim_density$qx > TT_outcomes_correct/TT_outcomes_N], y =sim_density$dx[sim_density$qx > TT_outcomes_correct/TT_outcomes_N], type="h", col="red")
abline(v=qnorm(TN,mean=mean(sim_TT[,"H0"]),sd=sd(sim_TT[,"H0"])))

## Estimated type 1 error
paste("When the outcomes are beyond the expect value of H0 at ",round(qnorm(TN),2)," standard deviation. ",
      "Probable type 1 error is",100*mean(sim_TT[,"H0"] > qnorm(TN,mean=mean(sim_TT[,"H0"]),sd=sd(sim_TT[,"H0"])) ),"%" )
## Estimated type 2 error
paste("When the outcomes are below the expect value of H1 at ",round(qnorm(TN),2)," standard deviation. ",
      "Probable type 2 error is",100*mean(sim_TT[,"H1"] < qnorm(TN,mean=mean(sim_TT[,"H0"]),sd=sd(sim_TT[,"H0"])) ) ,"%" )

## p values, by sampling distribution of outcomes
paste("p value of correct responses is",1 - sum(sim_TT[,"H0"] < (N_correct/N) )/length(sim_TT[,"H0"]))  ## p value of correct

#######

plot(sim_density, main=Title, xlab = "Proportion", type="l", ylab="Sampling Density")
lines(x = sim_density$qx[sim_density$qx > (TT_outcomes_N - TT_outcomes_correct)/TT_outcomes_N], y =sim_density$dx[sim_density$qx > (TT_outcomes_N - TT_outcomes_correct)/TT_outcomes_N], type="h", col="red")
abline(v=qnorm(TN,mean=mean(sim_TT[,"H0"]),sd=sd(sim_TT[,"H0"])))


## p values, by sampling distribution of outcomes
paste("p value of incorrect responses is",1 - sum(sim_TT[,"H0"] < (N_incorrect/N) )/length(sim_TT[,"H0"]))  ## p value of incorrect

