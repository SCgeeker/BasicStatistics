## Compare the theoretical t distribution(s) and normal distribution
q <- seq(from = -4, to = 4,by=(4-(-4))/10000)
plot(dt(q,30),col= "red",type="p",main="Theoretical t distributions vs. Normal distribution",ylab="density")
lines(dt(q,25),col = "blue",type="p")
lines(dt(q,15),col = "green",type="p")
lines(dt(q,3),col ="orange",type="p")
lines(dnorm(q),col="black")

part <- 0:3000
plot(dt(q,30)[part],col= "red",type="p",main="Theoretical t distributions vs. Normal distribution",ylab="density",ylim = c(0,0.02))
lines(dt(q,25)[part],col = "blue",type="p")
lines(dt(q,15)[part],col = "green",type="p")
lines(dt(q,3)[part],col ="orange",type="p")
lines(dnorm(q)[part],col="black")


## Compare the simulated t distribution(s) and normal distribution
set.seed(1)
plot(dt30 <- density(rt(10000,30)),col = "red",type="p",main="Simulated t distributions vs. Normal distribution",ylab="density")
lines(dt25 <- density(rt(10000,25)),col = "blue",type="p")
lines(dt15 <- density(rt(10000,15)),col = "green",type="p")
lines(dt3 <- density(rt(10000,3)),col ="orange",type="p")
set.seed(1)
lines(dn <- density(rnorm(10000)),col="grey")

part <- 1:150
plot(dt30$y[part] ~ dt30$x[part],col = "red",type="p",main="Simulated t distributions vs. Normal distribution \n (Left tail zoom in)",ylab="density",ylim = c(0,0.05))
lines(dt25$y[part] ~ dt25$x[part],col = "blue",type="p")
lines(dt15$y[part] ~ dt15$x[part],col = "green",type="p")
lines(dt3$y[part] ~ dt3$x[part],col ="orange",type="p")
lines(dn$y[part] ~ dn$x[part],col="black")

## Compare the means of randomized data and the simulated t distribution
## Making of simulated data
m <- matrix(rep(0,4*10000),nc=4)
N = c(30,25,15,3)
## Generate the random numbers in consideration of standard error
for(j in 1:4) {
  i = 1
  set.seed(1)
  while(i <= 10000){
    m[i,j] <- c(mean(rnorm(N[j],0,sqrt(N[j]))))
    i = i+1
  }
}
## Draw plot
plot(dm30 <- density(m[,1]), col="red",type="p",main="Simulated distributions of means vs. Normal distribution",ylab="density")
lines(dm25 <- density(m[,2]),col="blue",type="p")
lines(dm15 <- density(m[,3]), col="green",type="p")
lines(dm3 <- density(m[,4]),col="orange",type="p")
set.seed(1)
lines(dm <- density(rnorm(10000)),col="black")

part <- 1:150
plot(dm30$y[part] ~ dm30$x[part],col = "red",type="p",main="Simulated t distributions vs. Normal distribution \n (Left tail zoom in)",ylab="density",ylim = c(0,0.02))
lines(dm25$y[part] ~ dm25$x[part],col = "blue",type="p")
lines(dm15$y[part] ~ dm15$x[part],col = "green",type="p")
lines(dm3$y[part] ~ dm3$x[part],col ="orange",type="p")
lines(dm$y[part] ~ dm$x[part],col="black",type="l")
