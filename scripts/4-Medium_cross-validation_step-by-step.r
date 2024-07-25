###################################################################################################################################################################################################################
# And let's try to make the cross-validation step by step 
# and see how well classify() can manage in telling the author
# of every text in our corpus

library(stylo)

#######
# Option 1: leave-one-out cross validation
# Needed: only one corpus directory

# loading the corpus
texts = load.corpus.and.parse(files = "all", corpus.dir = "corpus")

# getting a genral frequency list
freq.list = make.frequency.list(texts, head = 1000)
# preparing the document-term matrix:
word.frequencies = make.table.of.frequencies(corpus = texts, features = freq.list)

# now the main procedure takes place:
results  = crossv(training.set = word.frequencies, cv.mode = "leaveoneout",
                  classification.method = "svm")

# see what's inside:
summary(results)

# e.g., check which texts were misattributed to which authors
results$misclassified

# or get the number of correct classifications:
results$y
sum(results$y, na.rm = TRUE)

# or see how Emily Bronte's books were classified:
results$expected
results$expected == 'EBronte'
results$predicted[results$expected == 'EBronte']


######
# Option 2: K-fold cross validation
# Needed: two corpora (primary_set, secondary_set), which allow crossv()
#         to compute proportions of classes for stratification 

# loading the corpus
texts = load.corpus.and.parse(files = "all", corpus.dir = "corpus")

# Separate the corpus into two parts:
names(texts)
primary_index = c(2,4,5,7,8,10,11,12,14,15,17,19,21,23,24,26,27)
secondary_index = setdiff(1:27,primary_index) # = all the other books
primary_texts = texts[primary_index]
secondary_texts = texts[secondary_index]
## Or, alternatively, you can load corpora from two separate directories
# primary_set <- load.corpus.and.parse(corpus.dir="primary_TAG",
#                                      features="w", ngram.size = 2)
# secondary_set <- load.corpus.and.parse(corpus.dir="secondary_TAG",
#                                        features="w", ngram.size = 2)

# getting the training frequency list
primary_freq.list = make.frequency.list(primary_texts, head = 1000)
second_freq.list = make.frequency.list(secondary_texts)
freq.list = intersect(primary_freq.list,second_freq.list)
# preparing the document-term matrix:
primary_freqs = make.table.of.frequencies(corpus = primary_texts, features = freq.list)
secondary_freqs = make.table.of.frequencies(corpus = secondary_texts, features = freq.list)

results  = crossv(training.set = primary_freqs,
                  test.set = secondary_freqs,
                  cv.mode = "stratified", cv.folds = 10,
                  classification.method = "svm")
# a bug with cosine method

summary(results)
performance.measures(results)
