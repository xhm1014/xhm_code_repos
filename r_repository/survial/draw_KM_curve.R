library(survival)

library(dplyr)
library(survminer)


sfit <- survfit(Surv(time,status)~sex,data=lung)

ggsurvplot(sfit, conf.int=TRUE, pval=TRUE, risk.table=TRUE, 
            legend.labs=c("Male", "Female"), legend.title="Sex",  
            palette=c("dodgerblue2", "orchid2"), 
            title="Kaplan-Meier Curve for Lung Cancer Survival", 
            risk.table.height=.15)






