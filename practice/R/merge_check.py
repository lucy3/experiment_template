"""
See if experiment.csv turned out ok
"""
import csv
from collections import Counter, defaultdict

counts = Counter()
non_fillers = defaultdict(set)
rounds = range(2, 8)
with open('../results/all_experiment.csv', 'w') as outputfile:
    writer = csv.writer(outputfile, delimiter=',')
    writer.writerow(['workerid', 'sentence', 'response2', 'response1', \
        'language', 'gender', 'age'])
    unique_IDs = set()
    for r in rounds:
        with open('../mturk/round' + str(r) + '/experiment.csv', 'r') as inputfile: 
            reader = csv.DictReader(inputfile, delimiter=',')
            for row in reader:
                unique_IDs.add(r*10 + int(row['workerid']))
                newID = str(len(unique_IDs))
                writer.writerow([newID, row['sentence'], row['response2'], \
                    row['response1'], row['language'], row["gender"], row["age"]])
                sentence = row['sentence'].split()
                counts[sentence[0] + ' ' + sentence[1]] += 1
                if 'LongShort' in sentence[0]:
                    non_fillers[sentence[0] + ' ' + sentence[1]].add(sentence[2])

for longshort in non_fillers:
    print longshort, non_fillers[longshort]
print len(non_fillers)
print len(counts)
print float(sum(counts.values())) / len(counts)