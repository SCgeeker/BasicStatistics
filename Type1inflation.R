## Original: https://gist.github.com/calpolystat/fad8ef712fc6f726640c

library(dplyr)

## functions
## Create simulated response data
simulate.response = function(nsim, sample.sizes, s1=2, s2=2, s3=2, m1=0, m2=0, m3=0){
  ## user inputs number of samples to draw (nsim),
  ## sample size, and standard deviation of each sample (s1,s2,s3)
  ## The function outputs a matrix of nsim samples of size sample.size
  ## drawn from normal distributions with mean 0 and specified SDs.
  ## Each column is a vector of the 3 simulated output.
  set.seed(543)
  
  matrix(rnorm(nsim * sum(sample.sizes), mean=rep(c(m1,m2,m3), sample.sizes), 
               sd=rep(c(s1,s2,s3), sample.sizes)), ncol=nsim)
  
}
## Get F stat
get.f.stat = function(y,x) return(anova(lm(y~x))[[4]][1])
## Labels of independent variable
create.predictor = function(sample.sizes) 
  factor(rep(paste("Group", 1:3),sample.sizes))


## Create simulated variables
## Define sample size of each group
n1 = 30
n2 = 30
n3 = 30
## Define variance of each group
sigma1 = 5
sigma2 = 5
sigma3 = 5
## Define mean of each group
mu1 = 0
mu2 = 0
mu3 = 0

## Define simulation cycles
nsim = 1000

## Independent variable
x = create.predictor(sample.sizes=c(n1, n2, n3))
## Dependent variable
y = simulate.response(
  nsim=nsim, sample.sizes=c(n1, n2, n3), 
  s1=sigma1, s2=sigma2, s3=sigma3,
  m1=mu1, m2=mu2, m3=mu3) 
## Get F statistic
f.stats = apply(y, 2, get.f.stat, x=x)

# Compute critical value and Type 1 error
f.crit = qf(0.95, df1=2, df2=(sum(c(n1, n2, n3))-1))
f.type.I.error = mean(f.stats>=f.crit)

# Draw distribution of F statistic
f.stats %>% hist(xlab="F值",ylab="累積次數",main="1000次單因子獨立樣本變異數分析的F統計數") %>% 
  abline(v=f.crit,col="red", lty=2) 
text(x=f.crit+2, y=300, paste("型一錯誤率 = ",f.type.I.error), col="red")

# Isolate pairs
comparison01 = c("Group 1","Group 2")
comparison02 = c("Group 1","Group 3")
comparison03 = c("Group 2","Group 3")

df1 = data.frame( Y = y[which(x %in% comparison01),], Group = x[which(x %in% comparison01)] )
df2 = data.frame( Y = y[which(x %in% comparison02),], Group = x[which(x %in% comparison02)] )
df3 = data.frame( Y = y[which(x %in% comparison03),], Group = x[which(x %in% comparison03)] )

# Get t statistic
t.stats1 = sapply(df1[,1:nsim] , function(i) t.test(i ~ df1$Group, alternative="two.sided",var.equal=TRUE)$statistic) %>% abs()
t.stats2 = sapply(df2[,1:nsim] , function(i) t.test(i ~ df2$Group, alternative="two.sided",var.equal=TRUE)$statistic) %>% abs()
t.stats3 = sapply(df3[,1:nsim] , function(i) t.test(i ~ df3$Group, alternative="two.sided",var.equal=TRUE)$statistic) %>% abs()

# Get t critical value
crit.t1 <- qt(p = .975, df = ((n1-1)+(n2-1)))
crit.t2 <- qt(p = .975, df = ((n1-1)+(n3-1)))
crit.t3 <- qt(p = .975, df = ((n2-1)+(n3-1)))
# Get t type 1 error
t.Type.I.error = mean(t.stats1>=crit.t1 | t.stats2>=crit.t2 | t.stats3>=crit.t3)

c(t.stats1,t.stats2,t.stats3) %>% hist(xlab="t值",ylab="累積次數",main="1000次三對雙尾t檢定的統計數") %>% 
  abline(v=crit.t1,col="yellow", lty=2) %>%
  abline(v=crit.t2,col="blue", lty=2) %>% 
  abline(v=crit.t3,col="red", lty=2)
text(x=crit.t3+1, y=600, paste("型一錯誤率 = ",t.Type.I.error), col="red")

