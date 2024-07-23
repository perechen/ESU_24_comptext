library(stylo)

res = classify(training.corpus.dir = "primary_TAG",
               test.corpus.dir = "secondary_TAG")
summary(res)
res$predicted
res$expected
# Confusion matrix (which classes ended up being classified into/predicted as which)
table(res$expected, res$predicted)

# Other performance metric apart from accuracy
performance.measures(res$predicted,res$expected)


res = classify(training.frequencies = res$frequencies.training.set,
         test.frequencies = res$frequencies.test.set)


# NSC throws an error in classify() function
# Workaround step by step

primary_set <- stylo::load.corpus.and.parse(corpus.dir="primary_TAG",
                                              features="w",
                                              ngram.size = 2)
secondary_set <- stylo::load.corpus.and.parse(corpus.dir="secondary_TAG",
                                            features="w",
                                            ngram.size = 2)
feature_list = stylo::make.frequency.list(primary_set, head = 5000, value = TRUE)
feature_list = rownames(sort(feature_list, decreasing = TRUE))
# feature_list[1:10]
primary_frequencies = stylo::make.table.of.frequencies(corpus = primary_set,
                                               features = feature_list,
                                               relative = TRUE)
secondary_frequencies = stylo::make.table.of.frequencies(corpus = secondary_set,
                                                       features = feature_list,
                                                       relative = TRUE)

mff = 100
res = perform.nsc(training.set = primary_frequencies[,1:mff],
                                     test.set = secondary_frequencies[, 1:mff], 
                                     show.features = TRUE)

summary(res)
res$ranking
res$confusion_matrix
acc <- sum(diag(res$confusion_matrix)) / sum(res$confusion_matrix) 
acc

features = res$features
View(features)


