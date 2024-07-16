##################################################################################################################################################
# Now with rolling classification - you need two folders - 'reference_set' (= training set), 
# which holds the training data, and 'test_set' (= test set), where you put the text you want to examine

library(stylo)

# just run the fist experiment
rolling.classify(classification.method = "svm")
# let's also try to save the graph
rolling.classify(classification.method = "svm", write.png.file = TRUE)
# In fact there is a number of parameters you can control, go ahead and try changing some of them, you can find all options in CRAN documentation: https://cran.r-project.org/web/packages/stylo/stylo.pdf or by checking
help(rolling.classify) 

results = rolling.classify(write.png.file = TRUE, classification.method = "nsc", 
                 mfw=50, training.set.sampling = "normal.sampling", 
                 slice.size = 5000, slice.overlap = 4500,
                 dump.samples = TRUE) 



# If you want to mark specific parts in the text, 
# just put the word "xmilestone" (without "") in the place of interest.
# These locations are later stored in:
results$milestone.points

###
# How to find point at which the classification changes
summary(results)
results$classification.results
classes = unique(results$classification.results)
changes = diff(results$classification.results==classes[1])
# This gives you placement of the last slice before a change
results$classification.results[abs(changes)==1]



test.corpus = load.corpus.and.parse(files = "all", corpus.dir = "test_set",
                                    sampling = "normal.sampling", 
                                    sample.size = 5000, sample.overlap = 4500)

names(classification.results$y) =

c(round(5000/2) + ((5000 - 4500) * (1:length(results$classification.results)-1)))

1:length(results$classification.results)-1

########################################################################################
# prepare the text tokenization
tokenized.texts = load.corpus.and.parse(files = "all", corpus.dir = "corpus", markup.type = "plain", language = "Other", encoding = "UTF-8")
# make features
features = make.frequency.list(tokenized.texts, head = 2000)
# make table of frequencies
data = make.table.of.frequencies(tokenized.texts, features, relative = TRUE)

# do the imposters
imposters(reference.set = data[-c(1),], test = data[1,], distance="wurzburg") 

# you can also compare it with cross-validation results
crossv(training.set = data, cv.mode = "leaveoneout", classification.method = "svm") 
