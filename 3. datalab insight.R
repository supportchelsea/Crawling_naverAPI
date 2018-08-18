# init.
rm(list=ls()); gc(reset=T)

# install & read library
if(!require(dplyr)){install.package('dplyr');library(dplyr)}
if(!require(httr)) {install.package("httr");library(httr) }
if(!require(ggplot2)) {install.package("ggplot2");library(ggplot2) }

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
categories = list(list(name="디지털/가전", param=list("50002518"))) # cat_id : 50002518 >> 휴대용 선풍기

# data mapping
body_data = list(startDate=sdate, endDate=edate, timeUnit=tunit, category=categories)

# data to Json
body = jsonlite::toJSON(body_data, auto_unbox = T)

# get result from api server
url = 'https://openapi.naver.com/v1/datalab/shopping/categories'
result = httr::POST(url = url,
                    config = header,
                    body = body,
                    encode = "json"
                    )
# result to text & get data from result
res_text = content(result, as = "text")
res_json = jsonlite::fromJSON(res_text)
total = res_json$results$data
class(total)

#make the data set
data.all = total[[1]]

# reshape the data
data.all$period=as.Date(data.all$period,origin = "1970-01-01")
str(data.all)

# plotting
ggplot(data.all, aes(x=period,y = ratio))  + geom_freqpoly(stat = 'identity') + ggtitle("Search ratio",subtitle = 'from 2017-08-01 to 2018-07-24')

write.csv2(total, 'data_all.csv')
