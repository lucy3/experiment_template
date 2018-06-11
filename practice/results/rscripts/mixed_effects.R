# Mixed effects logistic regression
# created by jdegen on May 25, 2017
# modified by jdegen on May 23, 2018

library(tidyverse)
library(lme4)
library(languageR)

summary(longShortData)
names(longShortData)

# What's the distribution of true/false responses?
table(longShortData$response)
prop.table(table(longShortData$response))

# Recall that R by default interprets factor levels in alphanumeric order, so the model will predict the log odds of the recipient being realized as a PP (prepositional object) over an NP
longShortData$response <- factor(longShortData$response)
is.factor(longShortData$response)
contrasts(longShortData$response)

# We start with a simple logistic regression model (no random effects). The syntax is the same as in the linear model, but we use the function glm(). The only difference is that the assumed noise distribution is binomial.
m.norandom = glm(response ~ 1, data=longShortData, family="binomial")
summary(m.norandom) 

# 1. What is the interpretation of the intercept coefficient?
# Intercept capturing what's overall difference in log odds between one prediction versus another. 
# long is assigned to 0 and short is assigned to 1
# A positive intercept of 0.20892 = log(p(short)/(1-p(short))) means there is a slight bias towards short 

# What if we want to convert this back into probability space? First we define the function that takes a log odds ratio and turns it into a probability.
logit2prop <- function(l){
  exp(l)/(1+exp(l))
}

# 2. Use the logit2prop function to find out the probability of a PP realization
logit2prop(0.20892)
qlogis(logit2prop(0.20892))
# If you map the log odds to the logistic regression plot you basically retrieve the proportions.

# Let's add a random effect 
table(longShortData$longWord,longShortData$response)

# Note the use of glmer() instead of glm() for mixed effects. We again specify the binomial noise distribution.
m.word = glmer(response ~ 1 + (1|longWord), data=longShortData, family="binomial")
summary(m.word)

# 3. How does the overall intercept change? 
# Intercept estimate is now 
# Our intercept estimate is now 0.2593, so our bias against longs has increased slightly
# p value of 0.163 which is nonsignificant? 
# Once you take into account each individual word, you can no 
# longer conclude that overall there's a preference for short words
plogis(0.2593) # has increased 

# Let's add a predictor. 
table(longShortData[,c("context","response")])
prop.table(table(longShortData[,c("context","response")]),mar=c(1))

m2 = glmer(response ~ context + (1|longWord), data=longShortData, family="binomial")
summary(m2)

anova(m.word, m2)
# m2 is significantly better than m

# 4. What is the interpretation of the coefficients?
# Fixed effects:
#  Estimate Std. Error z value Pr(>|z|)   
# (Intercept)   0.1281     0.1925   0.665  0.50592   
# contextsupp   0.2653     0.1028   2.581  0.00985 **
# There is a positive effect of supportive context (0.2653) on being realized as a short
# Our intercept term is now slightly less (0.1281) than before. 
table(longShortData$context)

# If we want to get the intercept for the grand mean, we need to center first:
longShortData$order = factor(longShortData$order)
longShortData$context = factor(longShortData$context)
longShortData$response = factor(longShortData$response)
source("helpers.R")
clongShortData = longShortData %>% 
  mutate(responseNum = 2 - as.integer(response)) %>%
  as.data.frame()
centered = cbind(clongShortData,myCenter(clongShortData[,c("context","order")]))
head(centered) 
summary(centered)

m.c = glmer(response ~ ccontext + corder + (1|longWord) + (1|workerid), data=centered, family="binomial")
summary(m.c)
# Random effects:
#  Groups   Name        Variance Std.Dev.
# workerid (Intercept) 0.8686   0.932   
# longWord (Intercept) 1.7578   1.326   
# Number of obs: 1960, groups:  workerid, 49; longWord, 40
# Fixed effects:
#  Estimate Std. Error z value Pr(>|z|)    
# (Intercept)   0.3118     0.2549   1.223 0.221263    
# ccontext      0.3953     0.1127   3.506 0.000455 ***
# corder        0.3606     0.1122   3.213 0.001313 ** 

# NO context
m.nocontext = glmer(response ~ + corder + (1|longWord) + (1|workerid), data=centered, family="binomial")
summary(m.nocontext)

# There was a significant effect of order such that having the short first results in a preference towards short
# There is a significant effect of context such that having a supportive context also has a preference towards short

m.test = glmer(response ~ context + order + syllableDiff + lengthDiff + (1|longWord), data=temp, family="binomial")
summary(m.test)

# To get model predictions
dative$PredictedRealization = predict(m)
head(dative)
summary(dative) 
# overall mean is -1.3877 which means overall mean is at probability of 0.26, 
# some go pretty close to zero since min is so far.

# Let's turn the predictions into probabilities
# Turn log odds to probabilities
dative$PredictedProbRealization = logit2prop(dative$PredictedRealization)
head(dative)

# Now let's turn them into actual categorical predictions
# turn probabilities to 0s and 1s. 
dative$PredictedCatRealization = ifelse(dative$PredictedProbRealization < .5, "NP", "PP")
head(dative)

# How well do predicted and actual realization match?
head(dative[,c("RealizationOfRecipient","PredictedCatRealization")],70)
prop.table(table(dative[,c("RealizationOfRecipient","PredictedCatRealization")]))
# we get a 2% increase in accuracy if we use m.c instead of m, which includes Length as a predictor

# Compute the proportion of correctly predicted cases
dative$Prediction = ifelse(dative$RealizationOfRecipient == dative$PredictedCatRealization,"correct","incorrect")
table(dative$Prediction)
prop.table(table(dative$Prediction))

