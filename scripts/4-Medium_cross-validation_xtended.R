library(stylo)
## French drama comes from Théâtre classique collection (that was integrated into DraCor at some point)
## Only body text is taken from TC (avoiding character names and stage directions) 
corpus_location = "data/FR18_drama/"

## parse corpus using stylo
parsed_corpus <- stylo::load.corpus.and.parse(corpus.dir=corpus_location,
                                              features="w",
                                              ngram.size = 1)
## check tokens!
parsed_corpus$C_1701_boursault_esope

## 
feature_list = stylo::make.frequency.list(parsed_corpus, head = 5000)
feature_list[1:10]
# producing a table of relative frequencies:
frequencies = stylo::make.table.of.frequencies(corpus = parsed_corpus,
                                               features = feature_list,
                                               relative = TRUE)
frequencies[1:5,1:5]
## set a frequency cut-off for words
mff=100
## run a high-level cross-validation function
res<-stylo::crossv(frequencies[,1:mff],
                   cv.mode = "leaveoneout",
                   classification.method = "svm")

## confusion matrix showing classification results
res$confusion_matrix


## also can be constructed by tabulating "expected" against "predicted" vectors / factors
res$expected
res$predicted

## calculate accuracy: number of correct classifications (diagonal) divided by all classifications (overall sum)
acc <- sum(diag(res$confusion_matrix)) / sum(res$confusion_matrix) 
acc


## 'y' lists a 1/0 value for all documents depending on the outcome 
res$y 
## since its sequence is the same as the sequence of rows in our feature table we can access missclassified dramas
wrongs <- as.logical(res$y) # transform 1 & 0 to TRUE & FALSE

rownames(frequencies[!wrongs,]) # select rows that were FALSE (i.e. 0)
## this data also available in res$misclassified :) 


#### Let's build a loop for testing how many MFF we need for drama classification

library(dplyr)
library(ggplot2)

mff_list <- seq(5, 205,by=20) ## define the sequence for mff's cutoffs
results_acc <- vector(length=length(mff_list)) ## prepare an empty variable of length N for holding results

for(i in 1:length(mff_list)) {
  
  res<-stylo::crossv(frequencies[,1:mff_list[i]],
                     cv.mode = "leaveoneout",
                     classification.method = "svm")
  
  results_acc[i] <- sum(diag(res$confusion_matrix)) / sum(res$confusion_matrix) 
  
  
}

plot(mff_list, results_acc,
     ylim=c(0.5,1),
     col="blue",
     main = "Tragedies vs. comedies classification using SVM")



##########################################################
## run a single classification , but first prepare sets ##
##########################################################

## rows 1-154 are C, 155-249 are T
set.seed(1989) # seed will make sure that the outcome of the next random number generation (e.g. random sampling) will be the same

## 50 ids for C and 50 for T
train_ids <- c(sample(1:154, 50), sample(155:249, 50)) # sample 50 from both pools
train_set <- frequencies[train_ids,] # select rows based on IDs


## remove dramas that went to the test
rest <- frequencies[-train_ids,]
set.seed(1984)
test_ids <- c(sample(1:104, 30), sample(105:149,30)) ## NB! now genre ids are shifted in a table

## finally get a test set
test_set <- rest[test_ids,]


res <- stylo::classify(gui=F,
                training.frequencies = train_set[,1:200],
                test.frequencies = test_set[,1:200],method="svm")

table(res$expected,res$predicted)
