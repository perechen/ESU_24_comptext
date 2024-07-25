## seetrees package aims to provide more explanatory/exploratory ways to work with stylo
## you need `devtools` library to install it from the github 
install.packages("devtools")
devtools::install_github("perechen/seetrees")


library(stylo)
library(seetrees)


# view_tree() cuts a dendrogram at a selected height and associates features with clusters


data(lee) 
stylo_res = stylo(gui = F,frequencies = lee)


## cut the tree, and associate features with clusters
view_tree(stylo_res,k = 2,right_margin = 12,color_leaves = T)


## view_scores()
## see the highest z-score distribution in an author or a class
view_scores(stylo_res, target_text = "Faulkner_Absalom_1936",top=15)
view_scores(stylo_res, target_class = "Faulkner",top=15)

## compare_scores()
## compare profiles of two documents
compare_scores(stylo_res,
               source_text = "Capote_Blood_1966",
               target_text = "HarperLee_Mockingbird_1960")

compare_scores(stylo_res,
               source_text = "Capote_Blood_1966",
               target_text = "Capote_Breakfast_1958")

compare_scores(stylo_res,
               source_text = "Capote_Blood_1966",
               target_text = "HarperLee_Mockingbird_1960",
               type = "diff")

compare_scores(stylo_res,
               source_text = "Faulkner_Absalom_1936",
               target_text = "Faulkner_Sound_1929",
               type = "diff",top_diff = 15)

## view distance distribution! 
view_distances(stylo_res,group = F)
view_distances(stylo_res,group = T)

## what is going on there? let's check within-author distances
view_distances(stylo_res,group = T,author = "Capote")
view_distances(stylo_res,group = T,author = "HarperLee")
view_distances(stylo_res,group = T,author = "McCullers")
view_distances(stylo_res,group = T,author = "OConnor")
view_distances(stylo_res,group = T,author = "Welty")
view_distances(stylo_res,group = T,author = "Glasgow")
view_distances(stylo_res,group = T,author = "Styron")
view_distances(stylo_res,group = T,author = "Faulkner")

## analyse another dataset to compare distance distribution
data("galbraith")
gal = stylo(frequencies = galbraith)

view_distances(gal,group = T,author = "rowling")


