## Sampling distribution of paired means
Moon_mean <- 3.02
Moon_sd <- 1.499
Other_mean <- 0.59
Other_sd <- 0.445
n <- 15

## Settings of uniform distributions(populations)
Moon_min = Moon_mean - 3*Moon_sd
Moon_max = Moon_mean + 3*Moon_sd
Other_min = Other_mean - 3*Other_sd
Other_max = Other_mean + 3*Other_sd
## Draw populations
#plot(x = seq(Moon_min,Moon_max,1/10000), y = dunif(seq(Moon_min,Moon_max,1/10000),Moon_min,Moon_max),
#     main = "Population: Disruptive Behaviors in Moon\n Mean +/- 1.68*SD",
#     xlab = "Frequencies of disruptive behviors",
#     ylab = "Density")
#plot(x = seq(Other_min,Other_max,1/10000), y = dunif(seq(Other_min,Other_max,1/10000),Other_min,Other_max),
#     main = "Population: Disruptive Behaviors in Others\n Mean +/- 1.68*SD",
#     xlab = "Frequencies of disruptive behviors",
#     ylab = "Density")


## Making of sampling means
i = 10000
D_sim_means <- NULL
while (i > 0) {
  D_sim_means <- c(D_sim_means, 
                   mean(  sample(size = n,x = seq(Moon_min,Moon_max,1/10000) ) ) - 
                     mean( sample(size = n,x = seq(Other_min,Other_max,1/10000) ) ) )
  i = i - 1
}

## Draw sampling means
Title = paste("Sampling Distribution of Paired Difference Means \n Mean = ",round(mean(D_sim_means),2),"; Variance =", round(mean((D_sim_means)^2) - (mean(D_sim_means))^2, 4)  )
plot(density(D_sim_means), main=Title, xlab = "Means of Difference")

qqnorm(D_sim_means,col="red",main="Normal Q-Q plot of Sampling Distribution")
qqline(D_sim_means, col = "blue")

#plot( density( (D_sim_means - mean(D_sim_means))/sd(D_sim_means)), 
      #main="Test Statistics of Sampling Means vs. \nStandard Normal Distribution",
#      xlab="Test Statistics")

sim_stat <- (D_sim_means - mean(D_sim_means))/sd(D_sim_means)
plot( density( sim_stat), 
      main="Test Statistics of Sampling Means vs. \nt Distribution(df = 14) vs.\nStandard Normal Distribution",
      xlab="Test Statistics")
lines(x=seq(-4,4,1/length(density(sim_stat)$x) ),y=dt(seq(-4,4,1/length(density(sim_stat)$x)),14),col="blue")
lines(x=seq(-4,4,1/length(density(sim_stat)$x)),y=dnorm(seq(-4,4,1/length(density(sim_stat)$x))),col="red")

## SS of sampling and probability functions
round( sum((density(sim_stat)$y - dt(seq(-4,4,1/length(density(sim_stat)$x)), 14) )^2) )
round( sum((density(sim_stat)$y - dnorm(seq(-4,4,1/length(density(sim_stat)$x))) )^2) )

## Estimation of Type 1 Error
mean(sim_stat > qnorm(.95))
mean(sim_stat > qt(.95,14))
