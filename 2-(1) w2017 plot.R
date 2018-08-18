#install packages & load packages
library(ggplot2)

#set the enviroment
rm(list=ls())

#load the data 
data = read.csv("/table2017.csv")
data = data[,9:length(data)] #8월부터 데이터가 존재하므로 데이터 분할
str(data) # 데이터 프레임의 형태

#make the year vector
#control the NA
v = c() # 벡터를 할당할 빈 벡터 생성
for(i in 1:length(data)){
  v = c(v, c(t(data[i])))
} # 데이터의 모든 열을 전치하여 벡터라이즈함
v = v[!is.na(v)] # 그중 결측값을 제거하여 결측치 없는 벡터를 생성
v

# check the date of vector
length(v) # 벡터의 길이를 확인

#make the date 
# (from 2017-08-01 to 2017-12-31) 
startdate = as.Date(c("2017-08-01")) 
enddate = as.Date(c('2017-12-31'))

date = c()
for (i in startdate:enddate){
  date = c(date, i)
}
date = as.Date(date,origin = "1970-01-01")

# check the length of date
length(date)

# make the dataframe
w2017 = data.frame(date,v)
colnames(w2017) = c('date','degree')
head(w2017)

#plotting - freq
ggplot(w2017, aes(x=date, y=degree,group=1)) + geom_line(linetype="solid", color="black", size=0.5)+ ggtitle("Degree of 2017",subtitle = 'from 2017-08-01 to 2017-12-31')

