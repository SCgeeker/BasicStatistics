## Testing of one categorical variable
Groups <- 5    # Number of groups
Total <- 200  # Number of total observations
Exp_p <- rep(1/Groups, Groups) # Probability of expected value
Real_p <- c(.3,.2,.2,.2,.1) # Probability of real data
DF <- Groups -1 # Degree of freedom for this test
alpha <- .95 # criterion
## Making of Sampling Distribution
i = 10000                                        #
chi0 <- NULL                                      #
chi1 <- NULL                                      #
while(i > 0){                                    #
  ## Sampling
  Obs0 <- table(sample(1:Groups,size = Total, prob = Exp_p, replace = TRUE) ) # simulated observations of H0
  Obs1 <- table(sample(1:Groups,size = Total, prob = Real_p, replace = TRUE) ) # simulated observations of H1
  ## the simulated chi-squares 
  chi0 <- c(chi0,                                  #
           sum(                                  #
             (Obs0 - Exp_p*Total)^2/(Exp_p*Total) #
           ))                                    #
  chi1 <- c(chi1,                                  #
            sum(                                  #
              (Obs1 - Exp_p*Total)^2/(Exp_p*Total) #
            ))                                    #
  i = i-1                               #
} #
## Draw the plots of sampling distribution and theoretical distribution
lamda = mean(chi0) - DF # ncp value
hist(chi0,xlab="test statistics", density = TRUE, freq = FALSE, main="Goodness of fit: \n Null Hypothesis and Alternative Hypothesis",xlim=c(0,max(chi1)), ylim=c(0,0.2), col="red")   #
lines(dchisq(seq(min(chi0),max(chi0),by=1/1000),df=DF) ~ seq(min(chi0),max(chi0),by=1/1000), col="yellow" ) #
lines(dchisq(seq(min(chi0),max(chi0),by=1/1000),df=DF,ncp = lamda) ~ seq(min(chi0),max(chi0),by=1/1000), col="grey") #
hist(chi1, col = "blue", density = TRUE, freq = FALSE, add=TRUE)      #
abline(v=qchisq(alpha,df=DF),col="black") #
## Approch the p value of a statistic value
#Title <- paste0("Simulated sampling distribution of goodness of fit \n Number of total observations is ", Total, ", Degree of Freedom is ",DF) #
#test <- 1.75                                 #
#mean(chi > test)                             #
## Estimation of Type 1 Error
paste0("By chisq distribution, if alpha is ", (1-alpha),", Type 1 error is ",mean(chi0 > qchisq(alpha, df=DF)))  #
## Estimation of Type 2 Error
paste0("By chisq distribution, if alpha is ", (1-alpha),", Type 2 error is ",mean(chi1 < qchisq(alpha, df=DF)))  #
## Modified from https://mgimond.github.io/Stats-in-R/ChiSquare_test.html