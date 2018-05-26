# Chop up the sentence column
# Add actual long / short forms, ignore fillers
stimuli_file = file("/Users/lucyli/Documents/Senior/ling245all/ling245exp/practice/stimuli/long_short_words-materials.txt", "r")
longword = vector(mode="list", length=40)
shortword = vector(mode="list", length=40)
stimuli_name = vector(mode="list", length=40)
idx = 0
read = FALSE
while ( TRUE ) {
  line = readLines(stimuli_file, n = 1)
  if ( length(line) == 0 ) {
    break
  }
  if ( startsWith(line, '#') & endsWith(line, 'supp_shortfirst') ) {
    idx = idx + 1
    s = unlist(strsplit(line, ' '))
    stimuli_name[idx] = paste(s[2], s[3])
    read = TRUE
  }
  if ( startsWith(line, '1.') & read == TRUE) {
    s = unlist(strsplit(line, '   2. '))
    longword[idx] = s[2]
    a = gsub("1. ", '', s[1])
    shortword[idx] = gsub(" ", '', a)
    read = FALSE
  }
}
names(longword) = stimuli_name
names(shortword) = stimuli_name
close(stimuli_file)

workers = integer(nrow(all_experiment)/2 - 40)
stimuli = character(nrow(all_experiment)/2 - 40)
contexts = character(nrow(all_experiment)/2 - 40)
responses = character(nrow(all_experiment)/2 - 40)
longs = character(nrow(all_experiment)/2 - 40)
shorts = character(nrow(all_experiment)/2 - 40)
orders = character(nrow(all_experiment)/2 - 40)
new_row = 1
for (row in 1:nrow(all_experiment)) {
  worker = as.numeric(all_experiment[row, "workerid"])
  sentence = gsub("\"", '', all_experiment[row, "sentence"])
  choice = gsub("\"", '', all_experiment[row, "response1"])
  s = unlist(strsplit(sentence, ' '))
  if ( s[1] != 'filler' & worker != 21) {
    stimulus = paste(s[1], s[2])
    c = unlist(strsplit(s[3], '_'))
    context = c[1]
    order = c[2]
    if (order == 'longfirst' & choice == 'first') {
      response = "long"
    } else if (order == 'longfirst' & choice == 'second') {
      response = "short"
    } else if (order == 'shortfirst' & choice == 'first') {
      response = "short"
    } else if (order == 'shortfirst' & choice == 'second') {
      response = "long"
    }
    workers[new_row] = worker
    stimuli[new_row] = stimulus
    contexts[new_row] = context
    responses[new_row] = response
    orders[new_row] = order
    longs[new_row] = as.character(longword[stimulus])
    shorts[new_row] = as.character(shortword[stimulus])
    new_row = new_row + 1
  }
}
new_all <- data.frame("stimulus" = stimuli,
                "context" = contexts,
                "response" = responses, 
                "longWord" = longs,
                "shortWord" = shorts,
                "order" = orders,
                "workerid" = workers)
View(new_all)
write.csv(new_all, file = "/Users/lucyli/Documents/Senior/ling245all/ling245exp/practice/data/reformat.csv")

