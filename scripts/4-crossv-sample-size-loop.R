corpus_location = "data/EN_fiction_small/"
n_tokens <- seq(500, 5500,by=1000) ## define the sequence for sample sizes
results_acc <- vector(length=length(n_tokens)) ## prepare an empty variable of length N for holding results
1:length(n_tokens)

for(i in 1:length(n_tokens)) {
  
  ## 1 load the corpus
  
  parsed_corpus <- stylo::load.corpus.and.parse(corpus.dir=corpus_location,
                                                features="w",
                                                sampling = "random.sampling",
                                                sample.size = n_tokens[i],
                                                ngram.size = 1)
  
  ## 2 frequency list
  feature_list = stylo::make.frequency.list(parsed_corpus, 
                                            head = 5000)
  
  # 3 table of frequencies
  frequencies = stylo::make.table.of.frequencies(corpus = parsed_corpus,
                                                 features = feature_list,
                                                 relative = TRUE)
  
  
  ## cross-validation
  res <- stylo::crossv(frequencies[,1:100],
                       cv.mode = "leaveoneout",
                       classification.method = "svm")
  
  results_acc[i] <- sum(diag(res$confusion_matrix)) / sum(res$confusion_matrix) 
  
  
}

results_acc

plot(n_tokens, 
     results_acc,
     col="blue",
     main = "Small corpus of English fiction")

