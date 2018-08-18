# install & read library
if(!require(dplyr)){install.package('dplyr');library(dplyr)}
if(!require(rvest)){install.package('rvest');library(rvest)}
if(!require(httr)) {install.package("httr");library(httr) }
if(!require(stringr)){install.packages("stringr");library(stringr)}
if(!require(KoNLP)){install.package("KoNLP");library(KoNLP)}
if(!require(wordcloud2)){install.packages("wordcloud2");library(wordcloud2)}
library(rJava)
Sys.setlocale(locale="ko_KR.UTF-8")

url2017 = "http://www.weather.go.kr/weather/climate/past_table.jsp?stn=108&yy=2017&x=20&y=5&obs=07"
url2018 = "http://www.weather.go.kr/weather/climate/past_table.jsp?stn=108&yy=2018&obs=07&x=28&y=6"

html_2017 <- read_html(url2017,encoding = "EUC-KR")
table2017 =html_2017 %>% html_nodes('#wrap_content #content_weather .table_develop') %>% html_table() %>% data.frame()
for (i in 1:length(table2017)){
  table2017[,i] = gsub("[^0-9.]"," ",table2017[,i])
  }
names(table2017) = c('day',1:12) #열 이름 붙이기
table2017 = table2017[1:31,] #평균 제외
table2017 #NA 값이 많이 존재 -> 각 월마다 일수가 다르기 때문
head(table2017)

html_2018 <- read_html(url2018,encoding = "EUC-KR")
table2018 =html_2018 %>% html_nodes('#wrap_content #content_weather .table_develop') %>% html_table() %>% data.frame()
for (i in 1:length(table2018)){
  table2018[,i] = gsub("[^0-9.]"," ",table2018[,i])
}
names(table2018) = c('day',1:12) #열 이름 붙이기
table2018 = table2018[1:31,] #평균 제외
head(table2018) #NA 값이 많이 존재 -> 각 월마다 일수가 다르기 때문

# save the data as csv
write.csv2(table2017, 'table2017.csv')
write.csv2(table2018, 'table2018.csv')
