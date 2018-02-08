#if(!require(shiny)){install.packages('shiny')}
library(shiny)
#if(!require(shinythemes)){devtools::install_github('rstudio/shinythemes')}
#do.call(library, list(package = shinythemes, character.only = TRUE))
#library(shinythemes)


ui <- fluidPage( #theme=shinytheme("flatly"),
  titlePanel("圖解獨立組雙尾t檢定的樣本數目、效果量、p值、與考驗力的換算關係"),
  verticalLayout(
    mainPanel(
      plotOutput("plot_d", width = "600px", height = "400px"),
      splitLayout(style = "border: 1px solid silver:", cellWidths = c(300,300),cellHeights = c(600,600), 
               plotOutput("pdf"),
               plotOutput("cdf")
      ),
      splitLayout(style = "border: 1px solid silver:", cellWidths = c(300,300), 
               plotOutput("power_plot"),
               plotOutput("power_plot_d")
      )
    ),
    sidebarPanel(numericInput("N", "各組樣本數:", 50, min = 1, max = 1000),
                 sliderInput("d", label = HTML("Cohen's d (&delta;)效果量"), min = 0, max = 2, value = 0.5, step= 0.01),
                 sliderInput("p_upper", "顯著水準, 預先註冊最大p值:", min = 0, max = 1, value = 0.05, step= 0.005),
                 uiOutput("p_low"),
                 h4(textOutput("pow0")),br(),
                 h4(textOutput("pow1")),br(),
                 h4(textOutput("pow2")),br(),
                 h4("其他三張曲線圖呈現：顯著水準與考驗力(右上)、樣本數目與考驗力(左下)、效果量與考驗力(右下)。如果不確定真正的效果量有多少，右下圖只會呈現一個點。所有圖解顯示考驗力會隨設計(樣本數)與分析的策略(顯著水準)變化，而非固定的數值。"),
                 br(),
                 h4("原始程式碼來源：", a("Daniel Laken的Github", href="https://github.com/Lakens/p-curves"))
    )
  )
)
server <- function(input, output) {
  #surpress warnings
  options(warn = -1)
  
  output$pdf <- renderPlot({
    N<-input$N
    d<-input$d
    p<-0.05
    p_upper<-input$p_upper+0.00000000000001
    p_lower<-input$p_lower+0.00000000000001
#    if(p_lower==0){p_lower<-0.0000000000001}
    ymax<-25 #Maximum value y-scale (only for p-curve)
    
    #Calculations
    se<-sqrt(2/N) #standard error
    ncp<-(d*sqrt(N/2)) #Calculate non-centrality parameter d
    
    #p-value function
    pdf2_t <- function(p) 0.5 * dt(qt(p/2,2*N-2,0),2*N-2,ncp)/dt(qt(p/2,2*N-2,0),2*N-2,0) + dt(qt(1-p/2,2*N-2,0),2*N-2,ncp)/dt(qt(1-p/2,2*N-2,0),2*N-2,0)
    par(bg = "aliceblue")
    plot(-10,xlab="P值", ylab="機率密度", axes=FALSE,
         main=substitute(paste("效果量為", delta == d,"與樣本數為",N,"的p值分佈曲線")), xlim=c(0,1),  ylim=c(0, ymax))
    abline(v = seq(0,1,0.1), h = seq(0,ymax,5), col = "lightgray", lty = 1)
    axis(side=1, at=seq(0,1, 0.1), labels=seq(0,1,0.1))
    axis(side=2)
    cord.x <- c(p_lower,seq(p_lower,p_upper,0.001),p_upper) 
    cord.y <- c(0,pdf2_t(seq(p_lower, p_upper, 0.001)),0)
    polygon(cord.x,cord.y,col=rgb(1, 0, 0,0.5))
    curve(pdf2_t, 0, 1, n=1000, col="black", lwd=2, add=TRUE)
})
  output$cdf <- renderPlot({
    N<-input$N
    d<-input$d
    p_upper<-input$p_upper
    p_lower<-input$p_lower
    ymax<-25 #Maximum value y-scale (only for p-curve)
    
    #Calculations
    se<-sqrt(2/N) #standard error
    ncp<-(input$d*sqrt(N/2)) #Calculate non-centrality parameter d
    
    cdf2_t<-function(p) 1 + pt(qt(p/2,2*N-2,0),2*N-2,ncp) - pt(qt(1-p/2,2*N-2,0),2*N-2,ncp)
  
    par(bg = "aliceblue")
    plot(-10,xlab="顯著水準/預先註冊最大p值", ylab="考驗力", axes=FALSE,
         main=substitute(paste("效果量為", delta == d,"與樣本數為",N,"的考驗力分佈曲線")), xlim=c(0,1),  ylim=c(0, 1))
    abline(v = seq(0,1,0.1), h = seq(0,1,0.1), col = "lightgray", lty = 1)
    axis(side=1, at=seq(0,1, 0.1), labels=seq(0,1,0.1))
    axis(side=2)
#    cord.x <- c(p_lower,seq(p_lower,p_upper,0.001),p_upper) 
#    cord.y <- c(0,cdf2_t(seq(p_lower, p_upper, 0.001)),0)
#    polygon(cord.x,cord.y,col=rgb(1, 0, 0,0.5))
    curve(cdf2_t, 0, 1, n=1000, col="black", lwd=2, add=TRUE)
    points(x=p_upper, y=(1 + pt(qt(input$p_upper/2,2*N-2,0),2*N-2,ncp) - pt(qt(1-input$p_upper/2,2*N-2,0),2*N-2,ncp)), cex=2, pch=19, col=rgb(1, 0, 0,0.5))
  })
  output$power_plot <- renderPlot({
    N<-input$N
    d<-input$d
    p_upper<-input$p_upper
    ncp<-(input$d*sqrt(N/2)) #Calculate non-centrality parameter d
    plot_power <- (function(d, N, p_upper){
      ncp <- d*(N*N/(N+N))^0.5 #formula to calculate t from d from Dunlap, Cortina, Vaslow, & Burke, 1996, Appendix B
      t <- qt(1-(p_upper/2),df=(N*2)-2)
      1-(pt(t,df=N*2-2,ncp=ncp)-pt(-t,df=N*2-2,ncp=ncp))
    }
    )
    par(bg = "aliceblue")
    plot(-10,xlab="各組樣本數", ylab="考驗力", axes=FALSE,
         main=substitute(paste("效果量為", delta == d,"的p值分佈曲線")), xlim=c(0,N*2),  ylim=c(0, 1))
    abline(v = seq(0,N*2, (2*N)/10), h = seq(0,1,0.1), col = "lightgray", lty = 1)
    axis(side=1, at=seq(0,2*N, (2*N)/10), labels=seq(0,2*N,(2*N)/10))
    axis(side=2, at=seq(0,1, 0.2), labels=seq(0,1,0.2))
    curve(plot_power(d=d, N=x, p_upper=p_upper), 3, 2*N, type="l", lty=1, lwd=2, ylim=c(0,1), xlim=c(0,N), add=TRUE)
    points(x=N, y=(1 + pt(qt(input$p_upper/2,2*N-2,0),2*N-2,ncp) - pt(qt(1-input$p_upper/2,2*N-2,0),2*N-2,ncp)), cex=2, pch=19, col=rgb(1, 0, 0,0.5))
  })  
  output$power_plot_d <- renderPlot({
    N<-input$N
    d<-input$d
    p_upper<-input$p_upper
    ncp<-(input$d*sqrt(N/2)) #Calculate non-centrality parameter d
    plot_power_d <- (function(d, N, p_upper)
    {
      ncp <- d*(N*N/(N+N))^0.5 #formula to calculate t from d from Dunlap, Cortina, Vaslow, & Burke, 1996, Appendix B
      t <- qt(1-(p_upper/2),df=(N*2)-2)
      1-(pt(t,df=N*2-2,ncp=ncp)-pt(-t,df=N*2-2,ncp=ncp))
    }
    )
    par(bg = "aliceblue")
    plot(-10,xlab=substitute(paste("效果量 Cohen's", delta == d)), ylab="考驗力", axes=FALSE,
         main=substitute(paste("樣本數為",N,"的p值分佈曲線")), xlim=c(0,2),  ylim=c(0, 1))
    abline(v = seq(0,2, 0.2), h = seq(0,1,0.1), col = "lightgray", lty = 1)
    axis(side=1, at=seq(0,2, 0.2), labels=seq(0,2,0.2))
    axis(side=2, at=seq(0,1, 0.2), labels=seq(0,1,0.2))
    curve(plot_power_d(d=x, N=N, p_upper=p_upper), 0, 2, type="l", lty=1, lwd=2, ylim=c(0,1), xlim=c(0,2), add=TRUE)
    points(x=d, y=(1 + pt(qt(input$p_upper/2,2*N-2,0),2*N-2,ncp) - pt(qt(1-input$p_upper/2,2*N-2,0),2*N-2,ncp)), cex=2, pch=19, col=rgb(1, 0, 0,0.5))
  }) 
  # make dynamic slider 
  output$p_low <- renderUI({
    sliderInput("p_lower", "最小p值:", min = 0, max = input$p_upper, value = 0, step= 0.005)
  })
  output$pow0 <- renderText({
    p_upper<-input$p_upper
    N<-input$N
    d<-input$d
    crit_d<-abs(qt(p_upper/2, (N*2)-2))/sqrt(N/2)
    paste("最上面的圖裡，效果量是",d,"的抽樣分配以粗黑線呈現。一個有兩個獨立組且各有",N,"個樣本的研究，研究結果的效果量必須至少大於",round(crit_d,2),"，才能判定是統計顯著的結果。效果量是0的抽樣分配以灰色線呈現。紅色曲域面積呈現這份研究的型一錯誤率，藍色曲域面積呈現這份研究的型二錯誤率")
  })
  output$pow1 <- renderText({
    N<-input$N
    d<-input$d
    paste("下面的左上圖是設定這項兩組樣本數各為",N,"，真實效果量是",d,"的雙尾t檢定p值機率密度函數。")
  })
  output$pow2 <- renderText({
    N<-input$N
    d<-input$d
    p_upper<-input$p_upper
    p_lower<-input$p_lower
    ncp<-(input$d*sqrt(N/2)) #Calculate non-centrality parameter d
    p_u<-1 + pt(qt(p_upper/2,2*N-2,0),2*N-2,ncp) - pt(qt(1-p_upper/2,2*N-2,0),2*N-2,ncp) #two-tailed
    p_l<-1 + pt(qt(p_lower/2,2*N-2,0),2*N-2,ncp) - pt(qt(1-p_lower/2,2*N-2,0),2*N-2,ncp) #two-tailed
    paste("這張圖顯示顯著水準設定為",p_upper,"且真實效果量是",d,"，這項研究結果的考驗力是",100*round((1 + pt(qt(input$p_upper/2,2*N-2,0),2*N-2,ncp) - pt(qt(1-input$p_upper/2,2*N-2,0),2*N-2,ncp)),digits=4),"%。以同樣的條件再次進行這項研究，之後的研究結果大約有",100*round(p_u-p_l, 4),"%的p值會在",p_lower,"與",p_upper,"之間。")
  })
  output$plot_d <- renderPlot({
    N<-input$N
    d<-input$d
    p_upper<-input$p_upper
    ncp<-(input$d*sqrt(N/2)) #Calculate non-centrality parameter d
    low_x<--2
    high_x<-3
    #calc d-distribution
    x=seq(low_x,high_x,length=10000) #create x values
    d_dist<-dt(x*sqrt(N/2),df=(N*2)-2, ncp = ncp)*sqrt(N/2) #calculate distribution of d based on t-distribution
    #Set max Y for graph
    y_max<-max(d_dist)+1
    #create plot
    par(bg = "aliceblue")
    d = round(d,2)
    plot(-10,xlim=c(low_x,high_x), ylim=c(0,y_max), xlab="效果量Cohen's d", ylab="機率密度",main=substitute(paste("效果量是", delta == d,", 樣本數是",N,"抽樣分配")))
    #abline(v = seq(low_x,high_x,0.1), h = seq(0,0.5,0.1), col = "lightgray", lty = 1)
    lines(x,d_dist,col='black',type='l', lwd=2)
    #add d = 0 line
    d_dist<-dt(x*sqrt(N/2),df=(N*2)-2, ncp = 0)*sqrt(N/2)
    lines(x,d_dist,col='grey',type='l', lwd=1)
    #Add Type 1 error rate right
    crit_d<-abs(qt(0.05/2, (N*2)-2))/sqrt(N/2)
    y=seq(crit_d,10,length=10000) 
    z<-(dt(y*sqrt(N/2),df=(N*2)-2)*sqrt(N/2)) #determine upperbounds polygon
    polygon(c(crit_d,y,10),c(0,z,0),col=rgb(1, 0, 0,0.5))
    #Add Type 1 error rate left
    crit_d<--abs(qt(0.05/2, (N*2)-2))/sqrt(N/2)
    y=seq(-10, crit_d, length=10000) 
    z<-(dt(y*sqrt(N/2),df=(N*2)-2)*sqrt(N/2)) #determine upperbounds polygon
    polygon(c(y,crit_d,crit_d),c(0,z,0),col=rgb(1, 0, 0,0.5))
    #Add Type 2 error rate
    crit_d<-abs(qt(0.05/2, (N*2)-2))/sqrt(N/2)
    y=seq(-10,crit_d,length=10000) 
    z<-(dt(y*sqrt(N/2),df=(N*2)-2, ncp=ncp)*sqrt(N/2)) #determine upperbounds polygon
    polygon(c(y,crit_d,crit_d),c(0,z,0),col=rgb(0, 0, 1,0.5))
    segments(crit_d, 0, crit_d, y_max-0.8, col= 'black', lwd=2)
    text(crit_d, y_max-0.5, paste("效果量大於",round(crit_d,2),"的研究結果可判定為統計顯著"), cex = 1)
  }) 
  
}
shinyApp(ui = ui, server = server)