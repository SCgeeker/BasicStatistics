## Sampling distribution of two independent means
group1_mean <- 15.29
group1_n <- 24
group1_sd <- 6.38*sqrt(group1_n-1)/sqrt(group1_n)
group2_mean <- 10.88
group2_n <- 25
group2_sd <- 4.32*sqrt(group2_n-1)/sqrt(group2_n)

## Settings of uniform distributions(populations)
group1_min = group1_mean - 1.65*group1_sd
group1_max = group1_mean + 1.65*group1_sd
group2_min = group2_mean - 1.65*group1_sd
group2_max = group2_mean + 1.65*group1_sd
## Draw populations
plot(x = seq(group1_min,group1_max,1/10000), y = dunif(seq(group1_min,group1_max,1/10000),group1_min,group1_max),
     main = "Population: Raw scores of Group 1 \n Mean +/- 1.65*SD",
     xlab = "Frequencies of Raw scores",
     ylab = "Density")
plot(x = seq(group2_min,group2_max,1/10000), y = dunif(seq(group2_min,group2_max,1/10000),group2_min,group2_max),
     main = "Population: Raw scores of Group 2 \n Mean +/- 1.65*SD",
     xlab = "Frequencies of Raw scores",
     ylab = "Density")

## Making of sampling means
group1_sim_means <- NULL
set.seed(1)
i = 10000
while (i > 0) {
  group1_sim_means <- c(group1_sim_means, 
                   mean(  runif(group1_n,min = group1_min, 
                                max = group1_max) ) 
  )
  i = i - 1
}

#mean(group1_sim_means)
#sqrt(var(group1_sim_means))

group2_sim_means <- NULL
set.seed(1)
i = 10000
while (i > 0) {
  group2_sim_means <- c(group2_sim_means, 
                         mean(  runif(group2_n,min = group2_min, 
                                      max = group2_max) ) 
  )
  i = i - 1
}

#mean(group2_sim_means)
#sqrt(var(group2_sim_means))

D_sim_means <- group1_sim_means - group2_sim_means

## Draw sampling means
Title = paste("Sampling Distribution of Difference Between Group Means \n Difference of Means = ",
              round(mean(D_sim_means),3),"; Variance =", 
              round(mean((D_sim_means)^2) - (mean(D_sim_means))^2, 4)  )
plot(density(D_sim_means), main=Title, xlab = "Means of Difference")

## Check nomrality
qqnorm(D_sim_means,col="red",main="Normal Q-Q plot of Sampling Distribution")
qqline(D_sim_means, col = "blue")

## Distribution of test statistics
sim_stat <- (D_sim_means - 0)/sd(D_sim_means)

plot( density(sim_stat),
      main=paste0("Test Statistics of Sampling means vs. \nt Distribution(df = ",group1_n+group2_n-2," ) vs.\nNormal Distribution"),
      xlab="Test Statistics")
lines(x=seq(-4,4,1/length(density(sim_stat)$x) )+mean(D_sim_means/sd(D_sim_means)),y=dt(seq(-4,4,1/length(density(sim_stat)$x)),df=(group1_n+group2_n-2)),col="blue")
lines(x=seq(-4,4,1/length(density(sim_stat)$x))+mean(D_sim_means/sd(D_sim_means)),y=dnorm(seq(-4,4,1/length(density(sim_stat)$x ))),col="red")

sum(( density(sim_stat)$y - dt(seq(-4,4,1/length( density(sim_stat)$x)), df=(group1_n+group2_n-2)) )^2)
sum(( density(sim_stat)$y - dnorm(seq(-4,4,1/length(density(sim_stat)$x)) ) )^2)


## Estimation of Type 1 Error
mean(sim_stat > (mean(sim_stat) + qt(.95,group1_n+group2_n-2)) )
mean(sim_stat > (mean(sim_stat) + qnorm(.95)) )
