# init.
rm(list=ls()); gc(reset=T)

# install & read library
if(!require(dplyr)){install.package('dplyr');library(dplyr)}
if(!require(rvest)){install.package('rvest');library(rvest)}
if(!require(httr)) {install.package("httr");library(httr) }
if(!require(stringr)){install.packages("stringr");library(stringr)}
Sys.setlocale(locale="ko_KR.UTF-8")
if(!require(KoNLP)){install.package("KoNLP");library(KoNLP)}
if(!require(wordcloud2)){install.packages("wordcloud2");library(wordcloud2)}

# my keywords
keyword = c('에어컨', '선풍기')

# build dictionary
useSejongDic()
word = data.frame(unlist(keyword))
buildDictionary(ext_dic = c('sejong', 'woorimalsam'), user_dic=word, replace_usr_dic = T)


# private values
client_id = 'VRfZmc5pBfiQkGsokqLk'
client_secret = 's7tps5QXgE'

# header setting
header = httr::add_headers(
  'X-Naver-Client-Id' = client_id,
  'X-Naver-Client-Secret' = client_secret)

# parameter setting
end_num = 1000
display_num = 100
start_point = seq(1, end_num, display_num)

# variable init.
result = c()
# do web scraping
for( i in 1:length(keyword)) {
  query = iconv(keyword[i], to='UTF-8', toRaw = T)
  query = paste0('%', paste(unlist(query), collapse = '%'))
  query = toupper(query)
  
  cat("Scraping ...")
  for(j in 1:length(start_point)) {
    
    url = paste0('https://openapi.naver.com/v1/search/blog.xml?query=',query,'&display=',display_num,'&start=',start_point[j],'&sort=sim')
    
    url_body = read_xml(GET(url, header))
    text = url_body %>% xml_nodes('item description') %>% xml_text()
    
    # pre-processing
    text = gsub(keyword[1], " ", text)
    text = gsub(keyword[2], " ", text)
    text = gsub("\\[(.*?)\\]", " ", text)
    text = gsub("[^가-힣]", " ", text)
    text = str_trim(text)
    result= c(result, text)
    
    cat(paste0((j / length(start_point)) * 100, "% ... "))
  }
  cat("Done!", "\n")
}
rm(list = c('i', 'j', 'url_body', 'text', 'start_point'))

nouns=c()
for(i in 1:length(result)) {
  nouns = c(nouns, sapply(result[i], extractNoun, USE.NAMES = F))
}

print(nouns)

nouns = Filter(function(x){nchar(x) >= 2},nouns)
wordcount = sort(table(nouns), decreasing = T)
wordcount

mostcommon = wordcount[wordcount>=100]
mostcommon

wordcloud2(data = wordcount, minSize = 5)