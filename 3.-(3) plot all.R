data.all=total[[1]]
data.all$period=as.Date(data.all$period,origin = "1970-01-01")
head(data.all)
str(data.all)
attach(data.all)
sum(is.na(data.all))

sum(data.all$period=="2018-07-24") #24일까지

gplot(data.all, aes(x= period, y = ratio))  + geom_freqpoly(stat = 'identity') + ggtitle("Search ratio",subtitle = 'from 2017-08-01 to 2018-07-24')

#plotting by merged data 
p = ggplot(merged, aes(x= period, y = ratio)) + geom_freqpoly(stat = 'identity',show.legend = TRUE)+ geom_line(aes(y=degree),colour='red')

p = ggplot(df, aes(x=date, y=degree,col='degree')) + 
  geom_line() + xlab('Date') + ylab("degree OR search ratio")+ ggtitle("Compare the plot", subtitle= 'between degree and Search ratio')
p +  geom_line(aes(x=date,y=se,col='search ratio')) 
