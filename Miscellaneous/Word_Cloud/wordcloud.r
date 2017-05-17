# load libraries
library(wordcloud)
library(png)
library(tm)
library(RColorBrewer)

directory = '/Users/jaegukang/GoogleDrive/MATLAB/[WordCloud]/text'
fileList = dir(directory)

# Corpus
txt = Corpus(DirSource(directory))

# preprocessing
txt = tm_map(txt,removeNumbers)
txt = tm_map(txt,removePunctuation)
txt = tm_map(txt,stripWhitespace)
txt = tm_map(txt,removeWords,stopwords('english'))
dtm = TermDocumentMatrix(txt,control=list(wordLengths=c(1,Inf), tolower=T))
Freq = data.frame(as.matrix(dtm))

# WordCloud
# 1) only one text file exists
# 2) multiple text files exist

if (length(fileList)==1) {
freq.col = matrix(Freq[,1],ncol=length(Freq[,1]),byrow=TRUE)
colnames(freq.col) = rownames(Freq)
newFreq = as.table(freq.col)

png(filename = 'WordCloud.png')
wordcloud(rownames(Freq), 
scale=c(3,.2),
min.freq=2,
max.words=1000,
newFreq, 
random.order=F, 
rot.per=.15,
colors = brewer.pal(8,"Dark2"))
dev.off()

} else {
# Compare texts
png(filename = 'WordCloud_compare.png')
comparison.cloud(Freq, max= 400,
scale=c(4,0.4), rot.per=.3,
colors = rep(brewer.pal(8,"Dark2"), 2),
title.size=1)
dev.off()
# Common words
png(filename = 'wordCloud_common.png')
commonality.cloud(Freq, scale=c(4,.5),
rot.per=.3, colors = brewer.pal(8,"Dark2"))
dev.off()
}
