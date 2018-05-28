# Mixed effects logistic regression
# created by jdegen on May 25, 2017
# modified by jdegen on May 23, 2018

library(tidyverse)
library(lme4)
library(languageR)

summary(reformat)
names(reformat)

# What's the distribution of true/false responses?
table(reformat$response)
prop.table(table(reformat$response))

# Recall that R by default interprets factor levels in alphanumeric order, so the model will predict the log odds of the recipient being realized as a PP (prepositional object) over an NP
reformat$response <- factor(reformat$response)
is.factor(reformat$response)
contrasts(reformat$response)

# We start with a simple logistic regression model (no random effects). The syntax is the same as in the linear model, but we use the function glm(). The only difference is that the assumed noise distribution is binomial.
m.norandom = glm(response ~ 1, data=reformat, family="binomial")
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
table(reformat$longWord,reformat$response)

# QUESTION: difference between random effect and predictor? 

# Note the use of glmer() instead of glm() for mixed effects. We again specify the binomial noise distribution.
m = glmer(response ~ 1 + (1|longWord), data=reformat, family="binomial")
summary(m)

# 3. How does the overall intercept change? 
# Intercept estimate is now 
# Our intercept estimate is now 0.2593, so our bias against longs has increased slightly
# p value of 0.163 which is nonsignificant? QUESTION: what should be my main takeaway from this
plogis(0.2593) # has increased 

# Let's add a predictor. 
table(reformat[,c("context","response")])
prop.table(table(reformat[,c("context","response")]),mar=c(1))

m = glmer(response ~ context + (1|longWord), data=reformat, family="binomial")
summary(m)

# 4. What is the interpretation of the coefficients?
# There is a positive effect of supportive context (0.2653) on being realized as a short
# Our intercept term is now slightly less (0.1281) than before. (What does this mean?)
table(reformat$context)

# If we want to get the intercept for the grand mean, we need to center animacy first:
source("helpers.R")
centered = cbind(reformat,myCenter(reformat[,c("context","order")]))
head(centered) # QUESTION: Why are ccontext and corder all NA? 
summary(centered)

m.c = glmer(response ~ ccontext + (1|longWord), data=centered, family="binomial")
# QUESTION: Error: Invalid grouping factor specification, shortWord
summary(m.c)

# We can add additional predictors just as in the linear model
m.c = glmer(RealizationOfRecipient ~ cAnimacyOfRec + cLengthOfRecipient + (1|Verb), data=centered, family="binomial")
summary(m.c)
# Changed coefficient of animacy and intercept after adding length of recipient. 
ggplot(dative, aes(x=LengthOfRecipient)) + geom_histogram()
# Positive 0.60099 for length of recipient means positive effect on being realized as PP. 
# As the length of the recipient increases, people prefer producing it as a PP rather than an NP. 
# Animacy remains but slightly weaker now. 
# The longer you are, the more inanimate you are? 
# Longest lengths tend to be inanimate, some of the variance 
# that was previously explained by animacy now explained by length. 
table(dative$AnimacyOfRec, dative$LengthOfRecipient)

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

