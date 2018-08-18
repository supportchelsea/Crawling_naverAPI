# init.
rm(list=ls()); gc(reset=T)

# install & read library
if(!require(dplyr)){install.package('dplyr');library(dplyr)}
if(!require(httr)) {install.package("httr");library(httr) }
if(!require(scales)){install.package('scales');library(scales)}

library(ggplot2)

# private values
client_id = 'So9KjDOqZjCH63mZzJvW'
client_secret = 'chGOUuMjbq'

# header setting
header = httr::add_headers(
  'X-Naver-Client-Id' = client_id,
  'X-Naver-Client-Secret' = client_secret,
  'Content-Type' = 'application/json')

# body data setting
sdate = "2017-08-01"  # 시작 날짜는 naver에서 정해놓음
edate = Sys.Date()-1  # 현재 오늘은 안되므로 어제까지
tunit = "date"        # month, week, date 중에서 선택
category = "50002518"
categories = list(list(name="디지털/가전", param=list("50002518"))) # cat_id : 50002518 >> 휴대용 선풍기
age=c(10,20,30,40,50,60)

# data mapping
body_data = list(startDate=sdate, endDate=edate, timeUnit=tunit, category=category,age=age[i])
  
# data to Json
body = jsonlite::toJSON(body_data, auto_unbox = T)
  
# get result from api server
url = 'https://openapi.naver.com/v1/datalab/shopping/category/age'
result = httr::POST(url = url,
                      config = header,
                      body = body,
                      encode = "json")
  
  
# result to text & get data from result
res_text = content(result, as = "text")
res_json = jsonlite::fromJSON(res_text)
total = res_json$results$data

#check the structure
str(total)

# reshape the data
data.group = total[[1]]
data.group$group= as.factor(data.group$group)
data.group$period=as.Date(data.group$period,origin = "1970-01-01")
head(data.group)
str(data.group)
detach(data.group)
sum(is.na(data.group)) #결측치 없음

# sort by group 
data.group=data.group[order(data.group$group),]
str(data.group)
summary(data.group)

# save the data
write.csv2(data.group, 'data_age.csv')) 

# plotting the search ratio - freq
ggplot(data.group, aes(x=period,y = ratio, colour = group))  + geom_freqpoly(stat = 'identity') + ggtitle("Search ratio by age",subtitle = 'from 2017-08-01 to 2018-07-24')

# plotting the ratio by age- pie
p = ggplot(data.group, aes(x='', y=ratio, fill=group)) + geom_bar(stat = "identity")    +ggtitle("Pie Chart of Search Ratio by age")
p + coord_polar("y")
