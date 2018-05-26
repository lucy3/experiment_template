# Mixed effects logistic regression
# created by jdegen on May 25, 2017
# modified by jdegen on May 23, 2018

library(tidyverse)
library(lme4)
library(languageR)

# The dative alternation dataset from Bresnan et al. 2007
data(dative)
summary(dative)
names(dative)

# What's the distribution of true/false responses?
table(dative$RealizationOfRecipient)
prop.table(table(dative$RealizationOfRecipient))

# Recall that R by default interprets factor levels in alphanumeric order, so the model will predict the log odds of the recipient being realized as a PP (prepositional object) over an NP
contrasts(dative$RealizationOfRecipient)

# We start with a simple logistic regression model (no random effects). The syntax is the same as in the linear model, but we use the function glm(). The only difference is that the assumed noise distribution is binomial.
m.norandom = glm(RealizationOfRecipient ~ 1, data=dative, family="binomial")
summary(m.norandom) 

# 1. What is the interpretation of the intercept coefficient?
# Intercept capturing what's overall difference in log odds between one prediction versus another. 
# NP is assigned to 0 and PP is assigned to 1
# A negative intercept of -1.0450 = log(p(PP)/(1 - p(PP))) means there is a general bias towards NP. 

# What if we want to convert this back into probability space? First we define the function that takes a log odds ratio and turns it into a probability.
logit2prop <- function(l){
  exp(l)/(1+exp(l))
}

# 2. Use the logit2prop function to find out the probability of a PP realization
logit2prop(-1.0450)
qlogis(logit2prop(-1.0450))
# If you map the log odds to the logistic regression plot you basically retrieve the proportions.

# Let's add a random effect (verb intercept). There is clearly a lot of by-verb variability:
table(dative$Verb,dative$RealizationOfRecipient)

# Note the use of glmer() instead of glm() for mixed effects. We again specify the binomial noise distribution.
m = glmer(RealizationOfRecipient ~ 1 + (1|Verb), data=dative, family="binomial")
summary(m)

# 3. How does the overall intercept change? Convert this back into probability space. What was the effect of adding random by-verb variability?
# Our intercept estimate is now -0.4803, so our bias against PPs has decreased. 
# Now it thinks it's only marginally signigificant with a p value of 0.0983.
plogis(-.4803) # has increased

# Let's add a predictor. 
table(dative[,c("AnimacyOfRec","RealizationOfRecipient")])
prop.table(table(dative[,c("AnimacyOfRec","RealizationOfRecipient")]),mar=c(1))

m = glmer(RealizationOfRecipient ~ AnimacyOfRec + (1|Verb), data=dative, family="binomial")
summary(m)

# 4. What is the interpretation of the coefficients?
# There is a positive effect of animacy (1.4395) on being realized as a PP
# Our intercept term is now slightly more negative (-0.5667) than before. 
# If we don't center our animacy variable, intercept only reflects ...? 
# Intercept says there's a stronger bias being realized as a PP in the animate row. 
# Going from animate to inanimate increases our log odds by 1.4395, so PP more likely with inanimate. 
table(dative$AnimacyOfRec)

# If we want to get the intercept for the grand mean, we need to center animacy first:
source("helpers.R")
centered = cbind(dative,myCenter(dative[,c("AnimacyOfRec","LengthOfRecipient")]))
head(centered)
summary(centered)

m.c = glmer(RealizationOfRecipient ~ cAnimacyOfRec + (1|Verb), data=centered, family="binomial")
summary(m.c)
# there's so many more animate than inanimate, if we want zero to be in middle of these two variables
# we need the absolute value of the animate ones to be much smaller and so if we sum them all up and divide
# by total number we get 0. 
# We should get back the overall NP and PP in the dataframe. 
# The intercept is -0.4613 which is the same intercept that we got with the first model. 
# Center in general. The coefficient for animacy remains the same as before centering. 
# The only thing that changes is the interpretation of the intercept. 
# Useful for colinear predictors. If two predictors are too strongly correlated, 
# then that increases type 2 error overall, and doing centering makes them more orthogonal. 

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

