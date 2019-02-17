# Computations
X <- 0:6
Y <- round( choose(6,x)*choose((49-6),(6-x))/choose(49,6), 2)

## Probability function
plot(x = X, y = Y,type = "h")

## 沒有特別號的總中獎率
P0 <- sum((choose(6,3:6)*choose((49-6),(6-3:6))/choose(49,6) ) )

## 有特別號的總中獎率
## 無特別號
P1 <- sum( choose(6,3:6)*choose(1,0)*choose((49-6-1),(6-3:6))/choose(49,6) )
## 有特別號
P2 <- sum( choose(6,3:(6-1))*choose(1,1)*choose((49-6-1),((6-1)-3:(6-1)))/choose(49,6)  )

P1+P2

## 比較兩種總中獎率
P0 == (P1+P2)

# Simulations
set.seed(111)
numbers <- sample(1:49, 6)

#set.seed(112)

S = 10
count <- NULL
set.seed(as.numeric(Sys.time()))
while(S > 0) {
## N = 當期的下注總數
## 改變N，觀察符合號碼的數目
N <- 10000  ## 要有多少N，才會出現首獎
matches <- 1:N
## 比對中獎號碼
for(i in 1:N){
  ## 某一注的號碼
  bet <- sample(1:49, 6)
  ## 比對中獎號碼
  matches[i] <- sum(bet %in% numbers)
}
## 投注的中獎號碼數目之機率密度函數
P <- round(table(matches)/sum(matches),6)
## 列出可領獎金的各獎模擬機率
count <- c(count, length( print(P[!(names(P) %in% c("0","1","2"))])  ))
S = S - 1
}