# Plot something
library(tidyverse)
theme_set(theme_bw())
# add a text box onto bar with n = # of stimuli with that context
# annotate 
ggplot(reformat %>% mutate(dummy = as.factor(1)), aes(dummy, fill=response)) + geom_bar(position= "fill")
prop.table(table(reformat$response))
ggplot(reformat, aes(context, fill=response)) + geom_bar(position= "fill")
prop.table(table(reformat$response, reformat$context), 2)
ggplot(reformat, aes(order, fill=response)) + geom_bar(position= "fill")
prop.table(table(reformat$response, reformat$order), 2)

# add error bars, two lines for different order and x axis context and y axis proportion of long 
ggplot(reformat, aes(context, fill=response, color=order)) + 
  geom_point(stat="count", position='fill') #+ 
  #geom_errorbar(aes(ymin=0.40, ymax=0.60),width=0.25)

# two bars per word, one for supportive proportion and one for neutral proportion (assuming no effect from ordering)
# might as well just do points 
# can I order them from least to greatest? 
ggplot(reformat, aes(shortWord, fill=response)) + 
  geom_point(stat="count", position='fill') + 
  theme(axis.text.x = element_text(angle = 45, vjust = 1, hjust = 1))

