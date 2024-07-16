###################################################################################################################################################################################################################
# And let's try to make the cross-validation step by step 
# and see how well classify() can manage in telling the author
# of every text in our corpus

library(stylo)

#######
# Option 1: leave-one-out cross validation

# loading the corpus
texts = load.corpus.and.parse(files = "all", corpus.dir = "corpus")

# getting a genral frequency list
freq.list = make.frequency.list(texts, head = 1000)
# preparing the document-term matrix:
word.frequencies = make.table.of.frequencies(corpus = texts, features = freq.list)

# now the main procedure takes place:
results  = crossv(training.set = word.frequencies, cv.mode = "leaveoneout",
                  classification.method = "delta")

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
