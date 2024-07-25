library(stylo)
###################
# Corpus preparation:
# 1. Download and extract https://github.com/perechen/ESU_24_comptext/tree/main/data/small_collection_POS.zip
# in your working directory.
# 2. Copy the contents of the corpus directory to 'primary_set' folder (default directory that classify() looks for). 
# 3. Make another folder 'secondary_set'. From 'primary_set', move there 1 book of each author.
# 4. Run classify()
###################
res = classify()

summary(res)
# A list predicted classes of books in the 'secondary_set' 
res$predicted
# A list real classes (labels provided) of books in the 'secondary_set' 
res$expected
# A list of books in the 'secondary_set' which were misclassified and how they were missclassified
res$misclassified

# Confusion matrix (which classes ended up being classified into/predicted as which)
res$confusion_matrix
# If it's not there, there's an easy way to make it in R:
table(res$expected, res$predicted)

# Other performance metric apart from accuracy (precision, recall, F1 score)
performance.measures(res$predicted,res$expected)


# If you named the directories otherwise, use optional arguments to point to them
res = classify(training.corpus.dir = "primary_TAG",
               test.corpus.dir = "secondary_TAG")

# If you choose NSC method you need to change the parameter show.features (otherwise the method won't work)
res = classify(training.corpus.dir = "primary_TAG",
               test.corpus.dir = "secondary_TAG",
               show.features = TRUE)
# NSC tries to minimise the number of features used for classification.
# These features can be found below (zero value means a feature not used by NSC)
View(res$distinctive.features)
