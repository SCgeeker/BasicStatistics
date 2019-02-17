# Population of outcomes
plot(x=0:1, y = dbinom(0:1,size = 1, prob = 0.5),type="h")

# Sampling distribution of outcomes
sim_TT <- NULL

i = 10000

while (i > 0) {
  n <- 150
  p <- 0.5
  sim_TT <- c(sim_TT, mean(rbinom(n,size = 1,prob=p)))
  i = i - 1
}

plot(density(sim_TT))

## Exact test
## p values, by sampling distribution of outcomes
1 - sum(sim_TT < (70/150) )/length(sim_TT)  ## p value of correct
1 - sum(sim_TT < (80/150) )/length(sim_TT)  ## p value of incorrect

