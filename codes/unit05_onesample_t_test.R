# parameters of sampling TT
p0 <- 0.5 # probability of correctness per participant (H0)
p1 <- 0.8 # probability of correctness per participant (H1)
n <- 10  # number of trials per participant
N <- 15  # number of participants
alpha <- .975 # alpha criterion
DF = N-1  # Degree of freedom
# Sampling distribution of simulated outcomes
sim_TT0 <- NULL #
sim_TT0_sd <- NULL #
sim_TT1 <- NULL #
i = 10000 #
# Looping simulations
while (i > 0) {  #
  j=N   #
  tmp_resp0 <- NULL  #
  tmp_resp1 <- NULL  #
  while(j > 0){  #
    tmp_resp0 <- c(tmp_resp0, sum(sample(c(0,1),size=n,replace = TRUE,prob=c(p0, 1-p0) )) )  #
    tmp_resp1 <- c(tmp_resp1, sum(sample(c(0,1),size=n,replace = TRUE,prob=c(1-p1, p1) )) )  #
    j = j - 1  #
  }  #
  sim_TT0 <- c(sim_TT0,mean(tmp_resp0))  #
  sim_TT0_sd <- c(sim_TT0_sd, sd(tmp_resp0)) #
  sim_TT1 <- c(sim_TT1,mean(tmp_resp1))  #
  i = i - 1  #
}  #
# Visulization of Null Hypothesis
Title = paste0("Mean of H0 is ",round(mean(sim_TT0),2),"; Mean of H1 is ", round(mean(sim_TT1),2),"\n variance of H0 is ",round(var(sim_TT0),3),"; variance of H1 is ", round(var(sim_TT1),2), "\n Grey line refers to the criterion" ) #
hist(sim_TT0, density = TRUE, freq = FALSE, main=Title,xlim=c(0,10),col="red")  #
lines(dnorm(seq(from=range(sim_TT0)[1],to=range(sim_TT0)[2],by=1/10000),mean(sim_TT0), sd(sim_TT0)) ~  seq(from=range(sim_TT0)[1],to=range(sim_TT0)[2],by=1/10000), col="red") #
# Visulization of Alternative Hypothesis
#Title = paste0("Sampling mean is ",round(mean(sim_TT1),2),"; Sampling variance is ", round(var(sim_TT1),3),"\n Blue line refers to normal distribution. \n Grey line refers to the criterion" ) #
hist(sim_TT1, density = TRUE, freq = FALSE, xlim = c(0,10), col="blue",add=T)  #
lines(dnorm(seq(from=range(sim_TT1)[1],to=range(sim_TT1)[2],by=1/10000),mean(sim_TT1), sd(sim_TT1)) ~  seq(from=range(sim_TT1)[1],to=range(sim_TT1)[2],by=1/10000), col="blue") #
abline(v=qnorm(alpha,mean(sim_TT0),sd=sd(sim_TT0)),col="grey") #
abline(v=(mean(sim_TT0)+qt(alpha, df=DF)),col="black") #
#abline(v=(mean(sim_TT0)+qt(alpha, df=DF)),col="grey") #
## Estimation of Type 1 errors
## by normal distribution
paste0("Estimate Type 1 error by normal distribution: ",mean( abs((sim_TT0-mean(sim_TT0))/sd(sim_TT0)) > qnorm(alpha) )) #
paste0("Estimate Type 2 error by normal distribution: ", mean(sim_TT1 < (mean( sim_TT0 )+ qnorm(alpha))) ) #
## by t distribution
paste0("Estimate Type 1 error by t distribution: ",mean( abs((sim_TT0-mean(sim_TT0))/sd(sim_TT0)) > qt(alpha, df=DF) )) #
paste0("Estimate Type 2 error by t distribution: ",mean(sim_TT1 < (mean( sim_TT0 )+ qt(alpha,df=DF))) ) #
## Confindence interval
t_cv <- qt(alpha,df=DF)   ## Decide the critical value
lci <- sim_TT0 - t_cv* sim_TT0_sd/sqrt(N)  ## compute the lower ci
uci <- sim_TT0 + t_cv* sim_TT0_sd/sqrt(N)  ## compute the upper ci
paste0("In 10000 simulations, there are ",100*mean(lci<mean(sim_TT0) & uci > mean(sim_TT0))," C.I. in compatible with the expect value of H0")