# First, check that everyone was paying attention (75%+ accuracy on comprehension)
# Get correct answers
stimuli = file("/Users/lucyli/Documents/Senior/ling245all/ling245exp/practice/stimuli/long_short_words-materials.txt", "r")
correct = vector(mode="list", length=80)
questions = vector(mode="list", length=80)
idx = 0
while ( TRUE ) {
  line = readLines(stimuli, n = 1)
  if ( length(line) == 0 ) {
    break
  }
  if ( startsWith(line, '# filler')) {
    idx = idx + 1
    s = unlist(strsplit(line, ' '))
    questions[idx] = paste(s[2], s[3])
  }
  if ( startsWith(line, '#') & endsWith(line, 'supp_shortfirst') ) {
    idx = idx + 1
    s = unlist(strsplit(line, ' '))
    questions[idx] = paste(s[2], s[3])
  }
  if ( endsWith(line, 'No')) {
    correct[idx] = 'no'
  }
  if ( endsWith(line, "Yes")) {
    correct[idx] = 'yes'
  }
}
names(correct) = questions
correct
close(stimuli)
worker_accuracy = integer(50) # num correct for worker
for (row in 1:nrow(all_experiment)) {
  worker = as.numeric(all_experiment[row, "workerid"])
  sentence = gsub("\"", '', all_experiment[row, "sentence"])
  response = gsub("\"", '', all_experiment[row, "response2"])
  s = unlist(strsplit(sentence, ' '))
  sentence = paste(s[1], s[2])
  if (correct[sentence] == response) {
    worker_accuracy[worker] = worker_accuracy[worker] + 1
  }
}
print(worker_accuracy)
for (i in 1:length(worker_accuracy)) {
  if (worker_accuracy[i] < 60) {
    print(i)
    print(worker_accuracy[i])
  }
}
# We learn that worker 21 may not have paid attention, so we're tossing out their results.
