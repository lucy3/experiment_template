library(tidyverse)
library(ngramr)

# Get some interesting characteristics of words
longwords = reformat$longWord[1:40] 
shortwords = reformat$shortWord[1:40]
all_words = c(longwords, shortwords)
cat(all_words, sep='\", \"')
for (item in all_words){
  print(item + ", ")
}

# SYLLABLES 
syllables = c(3, 3, 2, 4, 3, 
              4, 5, 3, 4, 5, 
              5, 5, 4, 3, 3, 
              5, 2, 3, 4, 3,
              3, 4, 3, 3, 4, 
              3, 4, 6, 3, 5, 
              5, 4, 5, 3, 3, 
              4, 5, 5, 5, 4,
              1, 2, 1, 1, 1, 
              2, 3, 2, 2, 2, 
              2, 1, 1, 1, 1, 
              2, 1, 1, 1, 2, 
              1, 1, 1, 2, 2, 
              1, 1, 2, 1, 2, 
              1, 1, 2, 1, 2, 
              2, 2, 1, 2, 1)
longsyllables = data.frame(longWord=longwords,longSyllables=syllables[1:40])
shortsyllables = data.frame(shortWord=shortwords,shortSyllables=syllables[41:80])
reformat = reformat %>% 
  left_join(longsyllables, by=c('longWord')) %>% 
  left_join(shortsyllables, by=c('shortWord')) 
reformat$syllableDiff = reformat$longSyllables - reformat$shortSyllables

# CHARACTER LENGTH 
reformat$lengthShort = nchar(reformat$shortWord)
reformat$lengthLong = nchar(reformat$longWord)
reformat$lengthDiff = reformat$lengthLong - reformat$lengthShort

# FREQUENCY Google Books r package 
# Unfortunately the ngram function can only take in 12 words at a time... 
# so... maybe I will write a loop oops
# also ran into a lot of server busy errors so I'm storing
# the frequencies here after getting them. 
for (i in 1:length(all_words)) {
  print(ngram(all_words[i], corpus = "eng_2012", year_start=2006, year_end=2008, smoothing=1)$Frequency[3])
}
freqs = c(5.750457e-07, 7.906859e-07, 1.358045e-07, 3.134869e-06, 3.295621e-06,
          7.435356e-07, 5.726067e-06, 9.038452e-07, 4.190034e-06, 1.423511e-06, 
          1.669196e-05, 1.091765e-06, 5.560162e-06, 8.37735e-07, 6.720658e-07, 
          5.419988e-06, 4.47114e-07, 4.94043e-06, 1.470832e-06, 9.800227e-07,
          5.664211e-07, 2.852517e-06, 2.258073e-05, 9.124634e-07, 3.935501e-05,
          4.300801e-06, 2.587675e-06, 2.959364e-05, 1.356475e-06, 1.246354e-05, 
          4.072069e-06, 1.371962e-06, 9.803362e-07, 1.367426e-06, 1.470013e-05, 
          0.0001824527, 4.320485e-07, 1.962259e-05, 4.042473e-05, 1.549296e-05,
          2.952129e-07, 1.730539e-07, 1.406508e-05, 1.536788e-06, 6.470023e-07, 
          3.811773e-07, 1.413678e-07, 7.287587e-07, 3.181543e-06, 5.256674e-06, 
          2.116058e-06, 1.764348e-06, 2.365374e-05, 2.823839e-07, 6.115861e-07, 
          5.024421e-07, 4.302494e-07, 5.513792e-05, 1.270794e-06, 9.200223e-07, 
          1.750432e-07, 4.69424e-07, 5.122335e-05, 4.576148e-07, 2.830579e-05, 
          5.626267e-06, 2.425691e-07, 1.134854e-05, 3.402761e-06, 2.885971e-06, 
          1.790544e-06, 3.273994e-06, 8.118417, 1.774963e-06, 1.544812e-05,
          0.0001994894, 2.539075e-07, 7.893366e-06, 7.573707e-06, 7.794503e-06)
longfreqs = data.frame(longWord=longwords,longFreqs=freqs[1:40])
shortfreqs = data.frame(shortWord=shortwords,shortFreqs=freqs[41:80])
reformat = reformat %>% 
  left_join(longfreqs, by=c('longWord')) %>% 
  left_join(shortfreqs, by=c('shortWord')) 
reformat$freqDiff = reformat$longFreqs - reformat$shortFreqs

# WordNet AMBIGUITY 
# Going through too many JavaVM fatal errors to do this in R. 
ambiguity = c(1, 1, 1, 1, 1, 1, 1, 2, 1, 0, 
              0, 1, 1, 1, 2, 1, 1, 1, 2, 1, 
              1, 1, 3, 1, 3, 2, 2, 5, 1, 0, 
              1, 0, 0, 5, 3, 0, 1, 2, 5, 1, 
              2, 1, 15, 1, 0, 1, 1, 2, 1, 2, 
              0, 6, 2, 1, 4, 0, 7, 8, 1, 1, 
              4, 0, 4, 1, 2, 3, 1, 3, 1, 1, 
              1, 4, 0, 1, 1, 2, 2, 1, 1, 1)
longambs = data.frame(longWord=longwords,longAmbs=ambiguity[1:40])
shortambs = data.frame(shortWord=shortwords,shortAmbs=ambiguity[41:80])
reformat = reformat %>% 
  left_join(longambs, by=c('longWord')) %>% 
  left_join(shortambs, by=c('shortWord')) 
reformat$ambDiff = reformat$longAmbs - reformat$shortAmbs
write.csv(reformat, file = "/Users/lucyli/Documents/Senior/ling245all/ling245exp/practice/data/longShortData.csv")

