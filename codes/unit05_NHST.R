## Simulate the results of biased coins; p = 0.95
set.seed(as.numeric(Sys.time()))
sim_data <- rbinom(10000, 20,0.95)
sim_data_df <- data.frame(Q = density(sim_data)$x, Density = density(sim_data)$y)

## Null hypothesis: simulated distribution; p = 0.5
set.seed(1)
sim_null <- rbinom(10000, 20,0.5)
plot(density(sim_null),xlab="Possible outcomes",main="Null Hypothesis for 20 trials of Lady tasting. \n 10000 simulations")
sim_null_df <- data.frame(Q = density(sim_null)$x, Density = density(sim_null)$y)

## p value of the current data
round(mean(sim_null >= sim_data[1]),5) ## raw frequency way
round(mean(sim_null >= 18),5) ## raw frequency way

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

## Type 1 error of accumulated data
alpha <- dim(subset(sim_null_df, Q > 18))[1]/dim(sim_null_df)[1]
TN <- dim(subset(sim_null_df, Q <= 18))[1]/dim(sim_null_df)[1]
round(data.frame(alpha,TN),2)

## Type 2 error of accumulated data
beta <-  dim(subset(sim_data_df, Q <= 18))[1]/dim(sim_data_df)[1]
Power <-  dim(subset(sim_data_df, Q > 18))[1]/dim(sim_data_df)[1]
round(data.frame(beta,Power),2)
