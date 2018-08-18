# make the new dataframe to draw a plot
weather = rbind(w2017,w2018)
head(weather)
str(weather)

#plotting
ggplot(weather, aes(x=date, y=degree,group=1)) + geom_line(linetype="solid", color="black", size=0.5)+ ggtitle("Degree",subtitle = 'from 2017-08-01 to 2018-07-24')

write.csv2(weather, file='weather.csv')

