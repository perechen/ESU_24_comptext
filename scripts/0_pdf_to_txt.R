# we need a library to process PDFs!
install.packages("pdftools")

# load the library
library(pdftools)

## this functions extracts the text layer from PDF (if there is one)
## replace "MY_PDF.pdf" with your file name :) (it should be in working directoy, or provide the path)
plain_text <- pdf_text("MY_PDF.pdf") # returns set of lines, separated by pages in PDF

## this writes the text to a file of your selection
writeLines(plain_text,con="my_plain.txt")

############
## But what if you want to process many files in a folder?
############

## Let's say you have a folder with pdfs! 
## First, we need to list all files in the folder
all_pdfs <- list.files("pdfs/",full.names = T)

## now we apply pdf-to-text function to every item in this list
## the result is a list of plain texts (depending on how many texts you had)
list_of_texts <- lapply(all_pdfs,pdf_text)

## now we want to save each file in this list of the folder, so we need a list of corresponding paths. we will loop over results to do that

for(i in 1:length(all_pdfs)) {
  print(i)
  writeLines(list_of_texts[[i]], con=paste0("pdfs/file_", i, ".txt")) # we write each file back as a .txt with the corresponding name
}
