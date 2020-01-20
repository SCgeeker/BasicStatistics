binomial_n <- 10   # 二項分佈試驗次數
binomial_p <- .3   # 二項分佈試驗機率
sample_size <- 30  # 原始樣本數量
binomial_source <- rbinom(n = sample_size, size = binomial_n, prob = binomial_p)  # 製造原始樣本
print(matrix(binomial_source,nc=10))
## 製造模擬樣本
resample_N <- 20        #
binomial_sample_means <- NULL # 
i = 10000                #
while (i > 0) {          #
  binomial_sample_means <- c(binomial_sample_means, mean(sample(binomial_source, resample_N, replace = TRUE)) )       #
  i = i - 1              #
}                        #
## Draw sampling means
hist(binomial_sample_means,main = paste0("Mean = ",mean(binomial_sample_means),", SD = ",sd(binomial_sample_means)),xlab="Sampling Means")
