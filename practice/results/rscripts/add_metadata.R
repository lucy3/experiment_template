# Get some interesting characteristics of words
longwords = reformat$longWord[1:40] 
shortwords = reformat$shortWord[1:40]
all_words = c(longwords, shortwords)

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
num_chars = vector(mode="list", length=80)
# http://ucrel.lancs.ac.uk/bncfreq/lists/1_2_all_freq.txt
freq_file = file("/Users/lucyli/Documents/Senior/ling245all/ling245exp/practice/data/1_2_all_freq.txt", "r")
c = 0
while ( TRUE ) {
  line = readLines(freq_file, n = 1)
  if ( length(line) == 0 ) {
    break
  }
  l = unlist(strsplit(line, '\t'))
  if (l[2] %in% all_words) {
    print(l[2])
    print(l[4])
    c = c + 1
  }
}
print(c)
close(freq_file)
freq = vector(mode="list", length=80)
ambiguity = vector(mode="list", length=80)
for (word in all_words) { 
  num_chars[word] = nchar(word)
}
num_chars
