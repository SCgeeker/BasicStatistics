## Sampling distribution of i independent means withoud difference
mu <- sample(1:7,1) ## pick up one random number as mu
i <- 5 ## number of groups
j <- 30 ## number of participants in each group
range_a <- 0 ## there is no difference among groups
mean_res <- 5 ## set up the mean of residuals

Q_sim <- NULL

## Accumulating simulated quntities of F test
for(k in 1:10000){
## Setting of pseudo effects and residuals
a <- rep(range_a, i) ## group differences to grand mean
res <- rnorm(i*j, mean_res, 1) ## participant's residual 

## Making of pseudo data
data <- data.frame(y = mu + a + res, x = rep(seq(1:i),j))

group_means <- with(data, tapply(y,x,mean)) 
grand_mean <- mean(data$y)

## Compute the test statistics
SS_Group <- j*sum((group_means - grand_mean)^2)
MS_Group <- SS_Group/(i-1)

SS_Res <- sum((data$y - rep(group_means,j))^2)
MS_Res <- SS_Res/(i*(j-1))

Q_sim <- c(Q_sim,MS_Group/MS_Res)

k = k+1
}

## Draw the sampling distribution of MSG/MSR
plot(density(Q_sim),xlab="test statistics",ylab="density",ylim=c(0,1))
## Compare the sampling distribution(black) and theoretical distributions (red, blue)
lines(density(Q_sim)$x, df(density(Q_sim)$x, df1=(i-1),df2=(i*(j-1))),col="red")
lines(density(Q_sim)$x, df(density(Q_sim)$x, df1=i,df2=i*j),col="blue")

## SS of sampling and probability functions(F distributions)
sum((density(Q_sim)$y - df(density(Q_sim)$x, df1=(i-1),df2=(i*(j-1))))^2 )
sum((density(Q_sim)$y - df(density(Q_sim)$x, df1=i,df2=i*j))^2 )

## Draw the sampling distribution of MSG/MSR
#hist(Q_sim, freq=FALSE)
## Compute the accumulated frequencies of distributions
#sampling <- hist(Q_sim, plot = FALSE)
## Plot of sampling distribution
#sampling_density <- sampling$counts/sum(sampling$counts)
#plot(sampling_density,type = "h",xlab="test statistics",ylab="density",ylim=c(0,1))
#lines(df(sampling$breaks, df1=(i-1),df2=(i*(j-1))),col="red")
#lines(df(sampling$breaks, df1=i,df2=i*j),col="blue")

#sum((sampling_density - df(sampling$breaks, df1=(i-1),df2=(i*(j-1))) )[-1]^2)
#sum((sampling_density - df(sampling$breaks, df1=i,df2=i*j)[-1]^2))

## Estimation of Type 1 Error: ANOVA
paste("Estimated Type 1 error by exact degree freedom:",sum(Q_sim > qf(.95,df1=(i-1),df2=i*(j-1)))/length(Q_sim))
paste("Estimated Type 1 error by alternative degree freedom:",sum(Q_sim > qf(.95,df1=i,df2=i*j))/length(Q_sim))


## Estimation of Type 1 Error: t test

T_sim <- NULL
## Accumulating simulated quntities of t test
for(k in 1:10000){
  ## Setting of pseudo effects and residuals
  a <- rep(range_a, i) ## group differences to grand mean
  res <- rnorm(i*j, mean_res, 1) ## participant's residual 
  
  ## Making of pseudo data
  data <- data.frame(y = mu + a + res, x = rep(seq(1:i),j))
  
  tmp <- NULL
  for(c in 1:dim(gtools::combinations(i,2))[1]) {
    p <- gtools::combinations(i,2)[c,]
    tmp <- c(tmp, unlist(with(data=data[data$x %in% p,],t.test(y~x)))["p.value"] < .05)
  }
  
  T_sim <- c(T_sim, sum(tmp))
  
  k = k+1
}

mean(T_sim)


#unlist(with(data=data[data$x %in% c(1,2),],t.test(y~x)))["p.value"] < .05,
#unlist(with(data=data[data$x %in% c(1,3),],t.test(y~x)))["p.value"] < .05,
#unlist(with(data=data[data$x %in% c(1,4),],t.test(y~x)))["p.value"] < .05,
#unlist(with(data=data[data$x %in% c(1,5),],t.test(y~x)))["p.value"] < .05,
#unlist(with(data=data[data$x %in% c(2,3),],t.test(y~x)))["p.value"] < .05,
#unlist(with(data=data[data$x %in% c(2,4),],t.test(y~x)))["p.value"] < .05,
#unlist(with(data=data[data$x %in% c(2,5),],t.test(y~x)))["p.value"] < .05,
#unlist(with(data=data[data$x %in% c(3,4),],t.test(y~x)))["p.value"] < .05,
#unlist(with(data=data[data$x %in% c(3,5),],t.test(y~x)))["p.value"] < .05,
#unlist(with(data=data[data$x %in% c(4,5),],t.test(y~x)))["p.value"] < .05
