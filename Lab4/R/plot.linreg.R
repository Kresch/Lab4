####ggplot2
#install.packages("gridExtra")
library(ggplot2)
library(gridExtra)
plot.linreg <- function(X){
        resid <- as.vector(X$resid)
        fitted <- as.vector(X$fitted.values)
        rstud<-as.vector(X$rstudent)
        sqrt_sq_resid<-sqrt(abs(rstud))
        
        #finds outliers
        n<-X$df.residual
#         Q1<-quantile(resid,0.25)
#         Q3<-quantile(resid,0.75)
        #outl_q<-c(Q1-1.3*(Q3-Q1),Q3+1.3*(Q3-Q1))
        outl<-c(rep(0,times=length(resid)))
        outl[c(which(abs(resid)>1))]<-
                c(rep(1,times=length(which((abs(resid)>1)))))
        #use a better def. of outlier
        
        #indexes the outliers to use in plot
        index<-c(rep(NA,times=length(resid)))
        index[c(which(outl==1))]<-c(which(outl==1))
#         index.na <- NA
#         for(i in 1:length(index)){
#                 if(!is.na(index[i])){
#                         index.na <- 0
#                 }
#         }
        data<-data.frame(resid,fitted,outl,index,sqrt_sq_resid)
        
        res_plot<-ggplot(data,aes(fitted,resid)) + 
                geom_point(aes(color=abs(resid),shape=factor(outl)),size=4)+
#                 if (!is.na(index.na)){
#                        geom_text(aes(label=index),hjust=-0.4,size=4)
#                 } 
                geom_text(aes(label=index),hjust=-0.4,size=4) +
                scale_colour_gradientn(colours=c("blue","white","red"))+
                scale_shape(solid=TRUE) +
                theme_minimal() +
                stat_smooth(method="loess",se=FALSE) +
                labs(title = "Residuals Vs. Fitted values",x="Fitted values",y="Residuals")
                
        

        
        stud_plot<-ggplot(data,aes(fitted,sqrt_sq_resid)) + 
                geom_point(aes(color=abs(sqrt_sq_resid),shape=factor(outl)),size=4)+
                geom_text(aes(label=index),hjust=-0.4,size=4) +
                scale_colour_gradientn(colours=c("blue","white","red"))+
                scale_shape(solid=TRUE) +
                theme_minimal() +
                stat_smooth(method="loess",se=FALSE) +
                labs(title = "Scale-Location",x="Fitted values",y="sqrt of Standardized Residuals")
        
        p3<-arrangeGrob(
                res_plot,stud_plot,nrow=2
        )
        
}
