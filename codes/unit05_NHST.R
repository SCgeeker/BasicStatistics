n <- 20 # Number of trials
p_bias <- 0.95 # proability of true skill
p_null <- 0.5 # proability of null skill 
  
## Simulate the results of biased coins; p = 0.95
set.seed(as.numeric(Sys.time()))
sim_data <- rbinom(10000, n, p_bias)
plot(table(sim_data),xlim=c(0,n),xlab="Possible outcomes",ylab="Accumulated frequencies",main="Alternative Hypothesis for 20 trials of Lady tasting. \n 10000 simulations")
#sim_data_df <- data.frame(Q = density(sim_data)$x, Density = density(sim_data)$y)

## Null hypothesis: simulated distribution; p = 0.5
set.seed(1)
sim_null <- rbinom(10000, n, p_null)
plot(table(sim_null),xlab="Possible outcomes",ylab="Accumulated frequencies",main="Null Hypothesis for 20 trials of Lady tasting. \n 10000 simulations")
#sim_null_df <- data.frame(Q = density(sim_null)$x, Density = density(sim_null)$y)


## Type 1 error of accumulated data
alpha <- mean(sim_null >= qbinom(.95,n,p_null))
##dim(subset(sim_null_df, Q >= n*p_bias))[1]/dim(sim_null_df)[1]
TN <- mean(sim_null < qbinom(.95,n,p_null))
##dim(subset(sim_null_df, Q < n*p_bias))[1]/dim(sim_null_df)[1]
round(data.frame(alpha,TN),2)


## Type 2 error of accumulated data
beta <- mean(sim_data >= qbinom(.95,n,p_bias))
##dim(subset(sim_data_df, Q < n*p_bias))[1]/dim(sim_data_df)[1]
Power <-  mean(sim_data < qbinom(.95,n,p_bias))
##dim(subset(sim_data_df, Q >= n*p_bias))[1]/dim(sim_data_df)[1]
round(data.frame(beta,Power),2)

## Distribution of p values
p_values <- NULL
for(i in 1:length(sim_data) ){
  p_values <- c(p_values,mean(sim_null >= sim_data[i]))
}
plot(density(p_values),xlab = "p values", main = "Distribution of p values \n 10000 simulations", ylab ="Accumulated Frequency", xlim=c(0, 0.1))

table(p_values)

## Cound how many p values > .05
sum(p_values > .05)
## Cound how many p values > .01
sum(p_values > .01)
