## Case for test of two categorical variable
## Basic settings
Switch_P0 <- 0.5  # P for Null Hypothesis
Switch_P1 <- 0.9  # P for Alternative Hypothesis
Target_N <- 30    # Sample size for this data
DF <- 1           # Degree of Freedom
alpha <- .95      # Criterion
## 
i = 10000         #
chi0 <- NULL      #
chi1 <- NULL      #
while(i > 0){     #
  chi0 <- c(chi0, #
           diff(table(sample(c("Switch_1","Switch_2"), size = Target_N, replace = TRUE, prob = c(Switch_P0,1-Switch_P0))))^2/Target_N   #
  ) #
  chi1 <- c(chi1, #
            diff(table(sample(c("Switch_1","Switch_2"), size = Target_N, replace = TRUE, prob = c(Switch_P1,1-Switch_P1))))^2/Target_N  #
  ) #
  i = i-1 #
} #
## Plot of sampling distribution
hist(chi0,xlab="test statistics", main="McNamer Test: \n Null Hypothesis and Alternative Hypothesis",xlim=c(0,max(chi1)), col="red")   #
hist(chi1, col = "blue", add=TRUE)      #
abline(v=qchisq(.95,DF))
## Estimation of Type 1 Error
paste0("By chisq distribution, Type 1 error is ", round(100*mean(chi0 > qchisq(alpha,DF,ncp=FALSE)),2),"%") #
## Estimation of Type 2 Error
paste0("By chisq distribution, Type 2 error is ", round(100*mean(chi1 < qchisq(alpha,DF,ncp=FALSE)),2),"%") #

### End of jamovi demonstration

sampling <- hist(chi, plot = FALSE)
## Plot of sampling distribution
plot(sampling$density,type = "h",main = "",
     xlab="test statistics",ylab="density",ylim=c(0,1))
lines(dchisq(sampling$breaks, df=1),col="red")
lines(dchisq(sampling$breaks, df=2),col="blue")

## SS of sampling and probability functions
sum(( (sampling$counts/10000) - dchisq(sampling$breaks, df=1))[-1]^2)
sum(( (sampling$counts/10000) - dchisq(sampling$breaks, df=2))[-1]^2)