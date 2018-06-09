# Plot something
library(tidyverse)
source("helpers.R")
theme_set(theme_bw())
# add a text box onto bar with n = # of stimuli with that context
# annotate 
ggplot(reformat %>% mutate(dummy = as.factor(1)), aes(dummy, fill=response)) + geom_bar(position= "fill")
prop.table(table(reformat$response))
ggplot(reformat, aes(context, fill=response)) + geom_bar(position= "fill")
prop.table(table(reformat$response, reformat$context), 2)
ggplot(reformat, aes(order, fill=response)) + geom_bar(position= "fill")
prop.table(table(reformat$response, reformat$order), 2)

# TODO: add error bars, two lines for different order and x axis context and y axis proportion of long 
reformatProp = (reformat %>% group_by(context,order, response) %>% 
  count() %>% 
  group_by(context, order) %>% 
  mutate(prop = n /sum(n)) %>% 
  filter(response == "long"))
reformat = reformat %>% mutate(responseNum = 2- as.integer(response))
agr = reformat %>%
  group_by(context, order) %>%
  summarize(meanRes = mean(responseNum), CI.Low = ci.low(responseNum), CI.High = ci.high(responseNum)) %>%
  mutate(YMin = meanRes - CI.Low, YMax = meanRes + CI.High)
agr
ggplot(reformatProp, aes(x=context, y=prop, color=order)) + 
  geom_point(position='identity') + 
  ylim(0, 1) +
  geom_errorbar(aes(ymin=agr$YMin, ymax=agr$YMax),width=0.2)

# longfirst/shortfirst not most thereotically most interesting 
# two different supportive context, mean of choosing long over short 
# add auxiliary plots show how long or short first interacts. make it as a bar plot 
# Wait... what do these notes mean? 

# TODO: scatter plot: x axis is lengthDiff or syllableDiff, y axis is proportion of long. 
# each point is a word. two smoothers, one for supportive and one for neutral. 
# geomtext, length differences on x-axis and each word is a point. 

# TODO: two points per word, one for supportive proportion and one for neutral proportion (assuming no effect from ordering)
reformatWord = (reformat %>% group_by(context,longWord,response) %>% 
                  count() %>% 
                  group_by(context,longWord) %>% 
                  mutate(prop = n /sum(n)) %>% 
                  filter(response == "long"))
View(reformatWord)
ggplot(reformatWord, aes(x=reorder(longWord, prop), y=prop, color=context)) + 
  geom_point() + 
  ylim(0, 1) +
  theme(axis.text.x = element_text(angle = 45, vjust = 1, hjust = 1))

# TODO: recreate Kyle plot. 

