rm(list=ls())
library(caret)
library(corrplot)
library(viridis)
library(Rsenal)
library(vioplot)
library(lubridate)
library(sptm)

mainpath <- "/home/hanna/Documents/Projects/IDESSA/airT/forPaper/"
datapath <- paste0(mainpath,"/modeldat")
vispath <- paste0(mainpath,"/visualizations")

testdata <- get(load(paste0(datapath,"/testdata.RData")))
model <- get(load(paste0(datapath,"/model_final.RData")))

pred_cv <- model$pred[model$pred$mtry==model$bestTune$mtry,]
pred_ext <- predict(model,testdat)
testdat$pred <- pred_ext
boxplot(abs(pred_cv$pred-pred_cv$obs),abs(pred_ext-testdat$Tair),notch=T)

regressionStats(pred_cv$pred,pred_cv$obs)
regressionStats(pred_ext,testdat$Tair)

###############
testdat$diff <- abs(testdat$Tair-testdat$pred)
testdat$year <- year(testdat$dateYD)
testdat$month <- month(testdat$dateYD)

boxplot(testdat$diff~testdat$month,ylab="absolute error (°C)")
boxplot(testdat$diff~testdat$year,ylab="absolute error (°C)")

regressionStats(testdat$pred[testdat$year==2012],testdat$Tair[testdat$year==2012])
regressionStats(testdat$pred[testdat$year==2013],testdat$Tair[testdat$year==2013])
regressionStats(testdat$pred[testdat$year==2014],testdat$Tair[testdat$year==2014])

