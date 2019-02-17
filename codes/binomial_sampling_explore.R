i = 10000
sim_TT <- NULL
while (i > 0) {
  n <- 150
  p <- 0.5
  sim_TT <- c(sim_TT, mean(rbinom(n,size = 1,prob=p)))
  i = i - 1
}


Title = paste("Sampling Distribution of binary outcomes \n Mean = ",round(mean(sim_TT),2),"; Variance =", round(mean((sim_TT)^2) - (mean(sim_TT))^2, 4)  )
plot(density(sim_TT), main=Title, xlab = "Proportion")
sim_density <- data.frame(qx <- density(sim_TT)$x, dx <- density(sim_TT)$y)
with( data = subset(sim_density, qx > 70/150),lines(qx ~ dx, type="l"))

qqnorm(sim_TT,col="red", main="Normal Q-Q plot of Sampling Distribution")
qqline(sim_TT, col = "blue")
