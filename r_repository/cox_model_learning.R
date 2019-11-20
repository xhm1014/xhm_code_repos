##http://www.sthda.com/english/wiki/cox-proportional-hazards-model

library("survival")
library("survminer")

data("lung")
head(lung)
# coxph(formula,data,method): formula: survival objects, data: dataframe
# univariate cox regression
res.cox<-coxph(Surv(time,status)~sex,data=lung)
summary(res.cox)

# to apply the univariate coxph function to multiple covariates at onece
covariates<-c("age","sex","ph.karno","ph.ecog","wt.loss")
univ_formulas<-sapply(covariates,function(x) as.formula(paste('Surv(time,status)~',x)))
univ_models<-lapply(univ_formulas,function(x){coxph(x,data=lung)})
#Extract data
univ_results<-lapply(univ_models,
                     function(x){
                       x<-summary(x)
                       p.value<-signif(x$wald["pvalue"],digits=2)
                       wald.test<-signif(x$wald["test"],digits=2)
                       beta<-signif(x$coef[1], digits=2);#coeficient beta
                       HR <-signif(x$coef[2], digits=2);#exp(beta)
                       HR.confint.lower <- signif(x$conf.int[,"lower .95"], 2)
                       HR.confint.upper <- signif(x$conf.int[,"upper .95"],2)
                       HR <- paste0(HR, " (", 
                                    HR.confint.lower, "-", HR.confint.upper, ")")
                       res<-c(beta, HR, wald.test, p.value)
                       names(res)<-c("beta", "HR (95% CI for HR)", "wald.test", 
                                     "p.value")
                       return(res)
                     })

res<-t(as.data.frame(univ_results,check.names=FALSE))
as.data.frame(res)

# multivariate cox regression analysis - 3 factors: sex, age, and ph.ecog
res.cox<-coxph(Surv(time,status)~age+sex+ph.ecog,data=lung)
summary(res.cox)

# visualizing the estimated distribution of survival times
# plot the baseline survival function
#ggsurvplot(survfit(res.cox), color = "#2E9FDF",
#           ggtheme = theme_minimal())

sex_df <- with(lung,
               data.frame(sex = c(1, 2), 
                          age = rep(mean(age, na.rm = TRUE), 2),
                          ph.ecog = c(1, 1)
               )
)
sex_df

# Survival curves
fit <- survfit(res.cox, newdata = sex_df)
ggsurvplot(fit, conf.int = TRUE, legend.labs=c("Sex=1", "Sex=2"),
           ggtheme = theme_minimal())