# load the library
library(stylo)

# To proceed in this part you need your texts arranged in two folders named:
# 'primary_set' (= training set) and 'secondary_set' (= test set)
# Go to the folder that contains them:
setwd(".........")

# start classification
classify()

# open 'final_results.txt' and see how good was the accuracy of the classification
# and what, if anything, got misclassfied

# now let's try running a serial experiment with a very simple type of cross-validation
# perform the classification:
results = classify(cv.folds = 10)

# get the classification accuracy:
results$cross.validation.summary
