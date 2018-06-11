# Plot something
library(tidyverse)
source("helpers.R")
theme_set(theme_bw())
# add a text box onto bar with n = # of stimuli with that context
# annotate 
ggplot(longShortData %>% mutate(dummy = as.factor(1)), aes(dummy, fill=response)) + geom_bar(position= "fill")
prop.table(table(longShortData$response))
ggplot(longShortData, aes(context, fill=response)) + geom_bar(position= "fill")
prop.table(table(longShortData$response, longShortData$context), 2)
ggplot(longShortData, aes(order, fill=response)) + geom_bar(position= "fill")
prop.table(table(longShortData$response, longShortData$order), 2)

prop.table(table(longShortData$order, longShortData$context))

# TODO: color = order, x axis = context, and y axis = proportion of long 
summary(longShortData)
longShortData$response = factor(longShortData$response)
longShortData$order = factor(longShortData$order)
longShortData$context = factor(longShortData$context)
longShortDataProp = (longShortData %>% group_by(context,order, response) %>% 
  count() %>% 
  group_by(context, order) %>% 
  mutate(prop = n /sum(n)) %>% 
  filter(response == "long"))
longShortData = longShortData %>% mutate(responseNum = 2 - as.integer(response))
reformat = reformat %>% mutate(responseNum = 2 - as.integer(response))
agr = longShortData %>%
  group_by(context, order) %>%
  summarize(meanRes = mean(responseNum), CI.Low = ci.low(responseNum), CI.High = ci.high(responseNum)) %>%
  mutate(YMin = meanRes - CI.Low, YMax = meanRes + CI.High)
agr
ggplot(longShortDataProp, aes(x=context, y=prop, color=order)) + 
  geom_point(position='identity') + 
  ylim(0, 1) +
  scale_color_manual(labels = c("long first", "short first"), values=c("orange", "purple")) +
  scale_x_discrete(labels=c("neut" = "neutral", "supp" = "supportive")) + 
  labs(x = "Context", y = "Proportion of choosing long form", color = "Ordering\n") +
  geom_errorbar(aes(ymin=agr$YMin, ymax=agr$YMax),width=0.2) + 
  theme(axis.text.x = element_text(size=12), axis.text.y = element_text(size=12),
        axis.title.y = element_text(size=14), axis.title.x = element_text(size=14),
        legend.text=element_text(size=12), legend.title=element_text(size=12))

# longfirst/shortfirst not most thereotically most interesting 
# two different supportive context, mean of choosing long over short 
# add auxiliary plots show how long or short first interacts. make it as a bar plot 
# Wait... what do these notes mean? 

# TODO: recreate Kyle plot. 
# sorted alphabetically 
# difference in proportion of choosing long 
longShortDataWord = (longShortData %>% group_by(context,shortWord,response) %>% 
                       count() %>% 
                       group_by(context,shortWord) %>% 
                       mutate(prop = n /sum(n)) %>% 
                       filter(response == "long"))

# oh actually the short words are unique
length(unique(longShortData$shortWord))
length(unique(longShortData$longWord))

longShortDataWordNeut = (longShortDataWord %>% filter(context == "neut"))
longShortDataWordSupp = (longShortDataWord %>% filter(context == "supp"))
colnames(longShortDataWordNeut)[colnames(longShortDataWordNeut)=="prop"] <- "neutProp"
colnames(longShortDataWordSupp)[colnames(longShortDataWordSupp)=="prop"] <- "suppProp"
longShortDataWordDiff = left_join(longShortDataWordNeut, longShortDataWordSupp, by="shortWord")
View(longShortDataWordDiff)
longShortDataWordDiff$propDiff = longShortDataWordDiff$neutProp - longShortDataWordDiff$suppProp
vjusts = c(rep(-1.0, 40))
vjusts[6] = 1.5
vjusts[13] = 1.5
vjusts[22] = 1.5
vjusts[23] = 1.5
vjusts[28] = 1.5
vjusts[39] = 1.5
ggplot(longShortDataWordDiff, aes(x=reorder(shortWord, shortWord), y=propDiff)) + 
  geom_point() +
  geom_hline(yintercept = 0, color="gray") +
  geom_text(aes(label=shortWord),hjust=0.5, vjust=vjusts, size = 3.5) +
  labs(x = "Words in alphabetical order", y = "Difference in proportion choosing long") +
  ylim(-1, 1) +
  scale_x_discrete(expand=c(0.05,0)) +
  theme(axis.text.x = element_blank(), 
        panel.grid.major = element_blank(), axis.ticks.x = element_blank(), 
        axis.title.y = element_text(size=14), axis.title.x = element_text(size=14))

# TODO: scatter plot: x axis is lengthDiff or syllableDiff, y axis is proportion of long. 
# each point is a word. two smoothers, one for supportive and one for neutral. 
datafreqDiff = (longShortData %>% group_by(context, shortWord,response,freqDiff) %>% 
                       count() %>% 
                       group_by(context, shortWord) %>% 
                       mutate(prop = n /sum(n)) %>% 
                       filter(response == "long"))
ggplot(datafreqDiff, aes(x=freqDiff, y=prop, color=context)) + 
  geom_point() + 
  geom_smooth() +
  scale_x_log10() +
  labs(x = "Frequency difference between long and short form", y = "Proportion of choosing long form", title = "Effect of Frequency Across Words") +
  theme(axis.text.x = element_text(angle = 45, vjust = 1, hjust = 1))

dataambDiff = (longShortData %>% group_by(context, shortWord,response,ambDiff) %>% 
                  count() %>% 
                  group_by(context, shortWord) %>% 
                  mutate(prop = n /sum(n)) %>% 
                  filter(response == "long"))
ggplot(dataambDiff, aes(x=ambDiff, y=prop, color=context)) + 
  geom_point() + 
  geom_smooth() +
  labs(x = "Ambiguity difference between long and short form", y = "Proportion of choosing long form", title = "Effect of Ambiguity Across Words") +
  theme(axis.text.x = element_text(angle = 45, vjust = 1, hjust = 1))

datasyllableDiff = (longShortData %>% group_by(context, shortWord,response,syllableDiff) %>% 
                 count() %>% 
                 group_by(context, shortWord) %>% 
                 mutate(prop = n /sum(n)) %>% 
                 filter(response == "long"))
ggplot(datasyllableDiff, aes(x=syllableDiff, y=prop, color=context)) + 
  geom_point() + 
  geom_smooth() +
  labs(x = "Syllable difference between long and short form", y = "Proportion of choosing long form", title = "Effect of Syllable Difference Across Words") +
  theme(axis.text.x = element_text(angle = 45, vjust = 1, hjust = 1))

datalengthDiff = (longShortData %>% group_by(context, shortWord,response,lengthDiff) %>% 
                      count() %>% 
                      group_by(context, shortWord) %>% 
                      mutate(prop = n /sum(n)) %>% 
                      filter(response == "long"))
ggplot(datalengthDiff, aes(x=lengthDiff, y=prop, color=context)) + 
  geom_point() + 
  geom_smooth() +
  labs(x = "Length difference between long and short form", y = "Proportion of choosing long form", title = "Effect of Length Difference Across Words") +
  theme(axis.text.x = element_text(angle = 45, vjust = 1, hjust = 1))

# TODO: two points per word, one for supportive proportion and one for neutral proportion (assuming no effect from ordering)
longShortDataWord = (longShortData %>% group_by(context,shortWord,response) %>% 
                  count() %>% 
                  group_by(context,shortWord) %>% 
                  mutate(prop = n /sum(n)) %>% 
                  filter(response == "long"))
ggplot(longShortDataWord, aes(x=reorder(shortWord, prop), y=prop, color=context)) + 
  geom_point() + 
  ylim(0, 1) +
  scale_color_manual(labels = c("neutral", "supportive"), values=c("red", "orange")) +
  labs(x = "Word", y = "Proportion of choosing long form", color = "Context\n", title = "Effect of Context Across Words") +
  theme(axis.text.x = element_text(angle = 45, vjust = 1, hjust = 1))

