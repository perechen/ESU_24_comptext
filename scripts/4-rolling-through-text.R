# library, as usual!
library(stylo)

# rolling classify needs to be set up manually
roll <- rolling.classify(training.corpus.dir = "data/RomanDeLaRosa/reference_set/", # path to training dir
                         test.corpus.dir = "data/RomanDeLaRosa/test_set/", # path to test dir
                         mfw = 100, # most frequent features
                         slice.size = 5000, # slice sizes (in features)
                         slice.overlap = 4500, # slice overlap (in features)
                         training.set.sampling="normal.sampling", # normal sampling is important here
                         classification.method="svm",
                         corpus.lang="French")



# If you want to mark specific parts in the text, 
# just put the word "xmilestone" (without "") in the place of interest.
# These locations are later stored in:
roll$milestone.points
