# Plot something
library(tidyverse)
theme_set(theme_bw())
ggplot(reformat, aes(context)) + geom_bar()
ggplot(reformat, aes(context + response)) + geom_bar()
