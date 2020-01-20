## Testing of two categorical variables, goodness of fit
Rp <- c(0.48,0.27,0.25)  ## Expected probabilities of Row, sum must be 1
Cp <- c(0.09,0.37,0.54)  ## Expected probabilities of Column, sum must be 1
Total <- 1184  # Number of total observations
Real_p <- c(0.06,0.02,0.01,0.17,0.11,0.09,0.25,0.15,0.14)
Exp_p <-  ((Total*Rp %x% t(Total*Cp))/Total)/Total ## Expected probabilities of Outer product
DF <- (length(Rp)-1)*(length(Cp)-1) # Degree of freedom for this test
alpha <- .95 # criterion
## Making of Sampling Distribution
i = 10000                                        #
chi0 <- NULL                                      #
chi1 <- NULL                                      #
while(i > 0){                                    #
  ## Sampling
  Obs0 <- table(sample(1:length(Exp_p),size = Total, prob = Exp_p, replace = TRUE)) # simulated observations
  Obs1 <- table(sample(1:length(Real_p),size = Total, prob = Real_p, replace = TRUE)) # simulated observations
  ## the simulated chi-squares 
  chi0 <- c(chi0,                                  #
           sum(                                  #
             (Obs0 - c(Exp_p*Total))^2/(c(Exp_p*Total)) #
           ))                                    #
  chi1 <- c(chi1,                                  #
            sum(                                  #
              (Obs1 - c(Exp_p*Total))^2/(c(Exp_p*Total)) #
            ))                                    #
  i = i-1                               #
} #
## Draw the plots of sampling distribution and theoretical distribution
lamda = mean(chi0) - DF ## adjust chi-square distribution ref: https://en.wikipedia.org/wiki/Noncentral_chi-squared_distribution
hist(chi0,xlab="test statistics", density = TRUE, freq = FALSE, main="Independence test: \n Null Hypothesis and Alternative Hypothesis",ylim=c(0,max(dchisq(seq(min(chi0),max(chi0),by=1/1000),df=DF))),xlim = c(0,max(chi1)), col="red")   #
lines(dchisq(seq(min(chi0),max(chi0),by=1/1000),df=DF) ~ seq(min(chi0),max(chi0),by=1/1000), col="yellow" ) #
lines(dchisq(seq(min(chi0),max(chi0),by=1/1000),df=DF, ncp = lamda) ~ seq(min(chi0),max(chi0),by=1/1000), col="grey" ) #
hist(chi1, col = "blue", density = TRUE, freq = FALSE, add=TRUE)      #
abline(v=qchisq(alpha,df=DF,ncp = lamda),col="black") #

## Estimation of Type 1 Error
paste0("By ncentric chisq distribution, if alpha is ", (1-alpha),", Type 1 error is ",mean(chi0 > qchisq(alpha, df=DF)))  #
paste0("By non-centric chisq distribution, if alpha is ", (1-alpha),", Type 1 error is ",mean(chi0 > qchisq(alpha, df=DF,ncp = lamda)))  #
## Estimation of Type 2 Error
paste0("By centric chisq distribution, if alpha is ", (1-alpha),", Type 2 error is ",mean(chi1 < qchisq(alpha, df=DF)))  #
paste0("By non-centric chisq distribution, if alpha is ", (1-alpha),", Type 2 error is ",mean(chi1 < qchisq(alpha, df=DF,ncp = lamda)))  #
## Modified from https://mgimond.github.io/Stats-in-R/ChiSquare_test.html
