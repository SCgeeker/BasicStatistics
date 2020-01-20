## Sampling distribution of i repeated measures
mu <- sample(0:10,1) ## pick up one random number as mu
i <- 3 ## number of repeated measures
j <- 10 ## number of participants in each group
range_a <- 0 ## set up of group difference range
mean_s <- 3 ## set up of participants' effect
mean_res <- 0 ## set up the mean of residuals

Q_sim <- NULL

## Accumulating simulated quntities
for(k in 1:10000){
## Setting of pseudo effects and residuals
a <- rep(range_a, i) ## group differences to grand mean
s <- rnorm(j,mean_s,1)## participant's difference 
res <- rnorm(i*j,mean_res,1) ## rest of the residuals

## Making of pseudo data
data <- data.frame(y = mu + rep(a,j) + rep(s,i) + res, S = rep(seq(1:j),each=i), x = rep(seq(1:i),j))

group_means <- with(data, tapply(y,x,mean)) 
participant_means <- with(data, tapply(y, S, mean))
grand_mean <- mean(data$y)

## Compute the test statistics
SS_Group <- j*sum((group_means - grand_mean)^2)
MS_Group <- SS_Group/(i-1)

SS_Res <- sum((data$y - rep(group_means,each=j) - rep(participant_means, i) + grand_mean)^2)
MS_Res <- SS_Res/((j-1)*(i-1))

Q_sim <- c(Q_sim,MS_Group/MS_Res)

k = k+1
}

## Draw the sampling distribution of MSG/MSR
hist(Q_sim,freq = FALSE,xlim=c(0,5), ylim=c(0,5) )
## Compute the accumulated frequencies of distributions
sampling <- hist(Q_sim, plot = FALSE)
## Draw the theoretical probability distributions
lines(df(sampling$breaks, df1=(i-1),df2=((i-1)*(j-1))),col="red")
lines(df(sampling$breaks, df1=i,df2=i*j),col="blue")

## SS of sampling and probability functions(F distributions)
sum((sampling_density - df(sampling$breaks, df1=(i-1),df2=(i*(j-1)))[-1] )^2)
sum((sampling_density - df(sampling$breaks, df1=i,df2=i*j)[-1])^2)


## Estimation of Type 1 Error
sum(Q_sim > qf(.95,df1=(i-1),df2=(i-1)*(j-1)))
