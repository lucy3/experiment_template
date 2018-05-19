# A Replication of Mahowald et al. (2013) 

Replicating the multiple-choice sentence completion part of the behavioral study from [this paper](https://www.sciencedirect.com/science/article/pii/S0010027712002107?via%3Dihub).

## Hypotheses

Our main hypothesis is the same as the conclusion in the original paper: participants will choose shorter word forms in predictive (supportive) contexts and longer forms in neutral contexts. In our analysis using a mixed-effect logistic regression, we will use the original predictors of supportive vs. neutral context and answer choice ordering. We may extend our analysis further by looking at other factors, such as the difference in number of characters, number of syllables, frequency, or surprisal between the long and short forms, and ambiguity. We predict that some of these additional factors may correlate with the variation in results across word pairs. 

## Stimuli & Data

We are using the same sentence items and fillers as the original paper, provided by Kyle Mahowald. These can be found [here](https://github.com/lucy3/predictive_info/blob/master/practice/stimuli/long_short_words-materials.txt). Each "LongShort" item has four versions, with each possible pairing of supportive/neutral context and long word first/second in the ordering of answer options. There are 40 long/short pairs and 40 fillers. Therefore, each of our 50 participants were presented with 80 sentence completions total. Participant #21 had 65% accuracy on comprehension questions, so their results are excluded from analyses, leaving 49 participants. 
