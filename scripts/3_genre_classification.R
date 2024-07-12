
#### Method 1. stylo. 

####  NB! Function looks in "primary_set" folder for training set and "secondary_set" for test set. Make sure you have these folders in your working directory that you need to manually fill with data (which maybe not very convenient)

library(stylo)
x=classify(gui = F,
         method="svm",
         kernel="linear",
         cost=1)
summary(x)




##### classify() is basically a wrapper around SVM model in e1071 package - so we can work with it directly. It potentially allows more control over corpus and makes it easier to split/manipulate data
##### first let's prepare corpus & features


#### 0. prepare corpus
library(tidyverse)
library(tidytext)


## list files in fr18 corpus

#unzip files if you need
unzip("fr18_drama.zip")

files = list.files("fr18_drama", full.names = T)


## read whole texts as character strings and put them into one tibble together with document names
corpus = tibble(title = files,
                 text = sapply(files, read_file)) %>%
  mutate(title = str_replace(title, ".*/(.*?).txt", "\\1"),
         text = str_replace_all(text,"'|’", " "))
  

corpus


# words arranged by their frequency

rank = corpus %>%
  #tokenize by word -> new column "word" out of column "text"
  unnest_tokens(input = text, output = word, token = "words") %>%
  #count & sort
  count(word, sort = T) %>% 
  select(-n) %>% 
  head(5000) # cut wordlist to 5000 MFWs


# calculate word frequencies for each text in corpus
 
freqs = corpus %>%
  unnest_tokens(input = text, output = word, token = "words") %>%
  right_join(rank,by="word") %>% # we are leaving 5000 MFWs that we cut-off earlier 
  count(title, word) %>% # count words within each text
  group_by(title) %>%
  mutate(n = n/sum(n)) %>% # because of group_by() will sum word counts only within titles -> we get relative frequencies
  rename(text_title = title) %>%
  mutate(word = factor(word, levels = rank$word)) %>% #reorder words by their rank
  spread(key = "word", value="n",fill = 0) # make the table wider


freqs[1:10,1:15]

## scale desired amount of MFWs
z = freqs[,102:201] %>% as.matrix() %>% scale() %>% as_tibble()

## combine it back with titles
z_fin = freqs[,1] %>% 
  ungroup() %>% 
  mutate(text_id = row_number())  %>% # text id's for later splitting
  bind_cols(z) %>%
  mutate(text_title = str_extract(text_title, "^.")) %>% # extract first character from title (C or T) as genre label
  rename(text_genre=text_title) 

z_fin[1:10,1:10]

##### Method 2. SVM from e1071
library(e1071)

### Now when we have represented texts by feature vectors, we can split our data to test and train

## First, check genre labels

z_fin$text_genre %>% table()

## deal with disproportionate genres

n = min(table(z_fin$text_genre)) # what is the value of the less frequent class
## in what proportion split to training and test sets (roughly 60% of texts will go to training)
train_size = round(n*0.60)
test_size = n - train_size


train_set = z_fin %>%
  group_by(text_genre) %>%
  sample_n(train_size) %>% # sample n times per each group (genre) 
  ungroup() 

test_set = z_fin %>% 
  anti_join(train_set, by="text_id") %>% # 1. remove already sampled training set from the data
  group_by(text_genre) %>% 
  sample_n(test_size) %>% # 2. sample again the test per each genre
  ungroup() 


### fit SVM model

svm_model <-svm(as.factor(text_genre)~.,  # we try to predict genre with all words (GENRE ~ WORDS), so we take all columns as predictor variables, we use . to select all data
                data=train_set %>% select(-text_id), # fit on train data, remove ids, 
            method="C-classification", 
            kernel="linear", 
            cost=1,
            scale=T)

### check summary
summary(svm_model)

### compute features weights using slopes of vectors and Support Vector alignment to features

w = t(svm_model$coefs) %*% svm_model$SV

tibble(weight=w[1,], word=colnames(w)) %>% 
  mutate(genre = case_when(weight > 0 ~ "Comedie", # label weights
                           weight < 0 ~ "Tragedie")) %>%
  group_by(genre) %>% 
  mutate(abs=abs(weight)) %>%
  top_n(20,abs) %>% 
  ggplot(aes(reorder(word,abs),abs,fill=genre)) + geom_col() +
  coord_flip() + 
  facet_wrap(~genre,scales="free") +
  theme(axis.text.y = element_text(size=14))


### now predict classes from unseen test set with the model we have

prediction <- predict(svm_model, test_set %>% select(-text_id))

# final confusion matrix
table(test_set$text_genre, prediction)


