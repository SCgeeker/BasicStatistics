## Revised Daniel Laken's code
## https://daniellakens.blogspot.tw/2016/03/the-difference-between-confidence.html

n=12 #根據研究背景設定樣本數
nSims<-100000 #設定虛擬再現實驗次數

x<-rnorm(n = n, mean = 874.167, sd = 535.562) # 製造第一次實驗虛擬資料

#95%CI
CIU<-mean(x)+qt(0.975, df = n-1)*sd(x)*sqrt(1/n) # 計算第一次實驗信賴間上邊界
CIL<-mean(x)-qt(0.975, df = n-1)*sd(x)*sqrt(1/n) # 計算第一次實驗信賴間下邊界 
## CIU <- 1214.446   ## Original: 
## CIL <- 533.887    ## Original: 

#製造虛擬再現實驗資料
CIU_sim<-numeric(nSims) 
CIL_sim<-numeric(nSims)
mean_sim<-numeric(nSims)

for(i in 1:nSims){ 
  x<-rnorm(n = 12, mean = 874.167, sd = 535.562) 
  CIU_sim[i]<-mean(x)+qt(0.975, df = n-1)*sd(x)*sqrt(1/n)
  CIL_sim[i]<-mean(x)-qt(0.975, df = n-1)*sd(x)*sqrt(1/n)
  mean_sim[i]<-mean(x) 
}


CIU_sim<-CIU_sim[CIU_sim<874.167]
CIL_sim<-CIL_sim[CIL_sim>874.167]

cat ( "根據第一次實驗資訊，再現的",nSims,"次新研究結果，其中有",(100*(1-(length(CIU_sim)/nSims+length(CIL_sim)/nSims))),"%的信賴區間包括樣本估計的平均數。")

mean_sim<-mean_sim[mean_sim>CIL&mean_sim<CIU]
cat("但是有",100*length(mean_sim)/nSims,"%的新研究平均數，落在第一次實驗的信賴區間",CIL,"與",CIU,"之間。")
