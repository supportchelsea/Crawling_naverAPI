install.packages("ROCR")
library(ROCR)


# find the insight by regression model

# make the merged data (total weather and search ratio)
se=data.all[,-1]
merged=cbind(weather,se)
merged$degree = as.numeric(merged$degree)
str(merged)

# linear regression
fit = lm(se~degree,data = merged)
summary(fit)
anova(fit)

# check the residual
plot(fit)

# divid the data to train and test
train = merged[1:50,]
test = merged[51:358,]


library(ROCR)
p <- predict(fit, newdata=merged, type="response")
pr <- prediction(p, test$admit)
prf <- performance(pr, measure = "tpr", x.measure = "fpr")
plot(prf)

# logistic regression
fit2 = glm(se/100 ~ degree, family = "binomial", data = merged)
