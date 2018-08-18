#install packages & load packages
library(ggplot2)

#set the enviroment
rm(list=ls())

#load the data 
data = read.csv("/Users/baejiwon/SNU/기말과제/weather2018.csv",sep = ';')
data = data[,-1] #day를 제거
head(data)
str(data)

#control the NA
v = c()
for(i in 1:length(data)){
  v = c(v, c(t(data[i])))
}
v = v[!is.na(v)]
v

# check the date of years
length(v)

#make the date (from 2017-08-01 to 2017-12-31) 
startdate = as.Date(c("2018-01-01"))
enddate = Sys.Date()-1

date = c()
for (i in startdate:enddate){
  date = c(date, i)
}
date = as.Date(date,origin = "1970-01-01")

# check the length of date
length(date)

# make the dataframe
w2018 = data.frame(date,v)
colnames(w2018) = c('date','degree')
w2018$degree = as.numeric(w2018$degree)
head(w2018)
str(w2018)

#plotting
ggplot(w2018, aes(x=date, y=degree,group=1)) + geom_line(linetype="solid", color="black", size=0.5)+ ggtitle("Degree of 2018",subtitle = 'from 2017-08-01 to 2018-07-24')

