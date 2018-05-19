# Get some interesting characteristics of words
library(rJava)
library(wordnet)
filter = getTermFilter("ExactMatchFilter", "cat", TRUE)
filter
terms = getIndexTerms("ADJECTIVE", 5, filter)
synsets = getSynsets(terms[[1]])
related = getRelatedSynsets(synsets[[1]], "!")
sapply(related, getWord)

longwords = reformat$longWord[1:40] 
shortwords = reformat$shortWord[1:40]
all_words = c(longwords, shortwords)

syllables = vector(mode="list", length=80)
num_chars = vector(mode="list", length=80)
freq = vector(mode="list", length=80)
ambiguity = vector(mode="list", length=80)
for (word in all_words) { 
  num_chars[word] = nchar(word)
}
num_chars
