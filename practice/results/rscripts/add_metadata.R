# Get some interesting characteristics of words
longwords = reformat$longWord[1:40] 
shortwords = reformat$shortWord[1:40]
all_words = c(longwords, shortwords)

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
View(reformat)
reformat$syllableDiff = reformat$longSyllables - reformat$shortSyllables

# CHARACTER LENGTH 
reformat$lengthShort = nchar(reformat$shortWord)
reformat$lengthLong = nchar(reformat$longWord)
reformat$lengthDiff = reformat$lengthLong - reformat$lengthShort
summary(reformat)

# for syllables instead of cbind just left join 

# FREQUENCY Google Books r package 

# AMBIGUITY 
