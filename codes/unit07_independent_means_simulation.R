## Sampling distribution of paired means
counter_mean <- .713
counter_n <- 54
counter_sd <- .473*sqrt(counter_n-1)/sqrt(counter_n)
clock_mean <- .641
clock_n <- 48
clock_sd <- .496*sqrt(clock_n-1)/sqrt(clock_n)

## Settings of uniform distributions(populations)
counter_min = counter_mean - 1.75*counter_sd
counter_max = counter_mean + 1.75*counter_sd
clock_min = clock_mean - 1.85*counter_sd
clock_max = clock_mean + 1.85*counter_sd
## Draw populations
plot(x = seq(counter_min,counter_max,1/10000), y = dunif(seq(counter_min,counter_max,1/10000),counter_min,counter_max),
     main = "Population: Disruptive Behaviors in Moon\n Mean +/- 13.2*SD",
     xlab = "Frequencies of disruptive behviors",
     ylab = "Density")
plot(x = seq(clock_min,clock_max,1/10000), y = dunif(seq(clock_min,clock_max,1/10000),clock_min,clock_max),
     main = "Population: Disruptive Behaviors in Others\n Mean +/- 13.2*SD",
     xlab = "Frequencies of disruptive behviors",
     ylab = "Density")

## Making of sampling means
counter_sim_means <- NULL
set.seed(1)
i = 10000
while (i > 0) {
  counter_sim_means <- c(counter_sim_means, 
                   mean(  runif(counter_n,min = counter_min, 
                                max = counter_max) ) 
  )
  i = i - 1
}

#mean(counter_sim_means)
#sqrt(var(counter_sim_means))

clock_sim_means <- NULL
set.seed(1)
i = 10000
while (i > 0) {
  clock_sim_means <- c(clock_sim_means, 
                         mean(  runif(clock_n,min = clock_min, 
                                      max = clock_max) ) 
  )
  i = i - 1
}

#mean(clock_sim_means)
#sqrt(var(clock_sim_means))

D_sim_means <- counter_sim_means - clock_sim_means

## Draw sampling means
Title = paste("Sampling Distribution of Paired Difference Means \n Difference of Means = ",
              round(mean(D_sim_means),3),"; Variance =", 
              round(mean((D_sim_means)^2) - (mean(D_sim_means))^2, 4)  )
plot(density(D_sim_means), main=Title, xlab = "Means of Difference")

## Check nomrality
qqnorm(D_sim_means,col="red",main="Normal Q-Q plot of Sampling Distribution")
qqline(D_sim_means, col = "blue")

## Distribution of test statistics
sim_stat <- density((D_sim_means - 0)/sd(D_sim_means))

plot( sim_stat,
      main=paste0("Test Statistics of Sampling means vs. \nt Distribution(df = ",counter_n+clock_n-2," ) vs.\nNormal Distribution"),
      xlab="Test Statistics")
lines(x=seq(-4,4,1/length(sim_stat$x) )+mean(D_sim_means/sd(D_sim_means)),y=dt(seq(-4,4,1/length(sim_stat$x)),df=(counter_n+clock_n-2)),col="blue")
lines(x=seq(-4,4,1/length(sim_stat$x))+mean(D_sim_means/sd(D_sim_means)),y=dnorm(seq(-4,4,1/length(sim_stat$x))),col="red")

sum((sim_stat$y - dt(seq(-4,4,1/length(sim_stat$x)), df=(counter_n+clock_n-2)) )^2)
sum((sim_stat$y - dnorm(seq(-4,4,1/length(sim_stat$x)) ) )^2)


var_p <- (counter_n - 1)*counter_sd^2/(counter_n + clock_n - 2) + (clock_n - 1)*clock_sd^2/(counter_n + clock_n - 2)
sqrt(var_p)
sqrt(var_p*(1/counter_n + 1/clock_n))
