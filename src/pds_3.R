install.packages("tidytext")
install.packages("dplyr")
install.packages("wordcloud")
install.packages("tm")
install.packages("ggplot2")

# Load libraries
library(tidytext)
library(dplyr)
library(ggplot2)
library(tm)
library(wordcloud)
library(SnowballC)

# Read data
data <- read.csv("/Users/anveshkumar/Desktop/pds_assignment3/data_raw/Corona_NLP_test.csv", stringsAsFactors = FALSE)

# Preprocessing
data$OriginalTweet <- gsub("http[^[:space:]]*", "", data$OriginalTweet) # Remove URLs
data$OriginalTweet <- gsub("@[^[:space:]]*", "", data$OriginalTweet) # Remove mentions
data$OriginalTweet <- gsub("[^[:alnum:][:space:]']", "", data$OriginalTweet) # Remove non-alphanumeric characters
data$OriginalTweet <- tolower(data$OriginalTweet) # Convert text to lowercase
data <- data[!is.na(data$OriginalTweet) & data$OriginalTweet != "", ] # Remove null values

# Save cleaned data to a new CSV file
write.csv(data, "/Users/anveshkumar/Desktop/pds_assignment3/data_clean/Cleaned_Carona_NLP_test.csv", row.names = FALSE)

data <- read.csv("/Users/anveshkumar/Desktop/pds_assignment3/data_clean/Cleaned_Carona_NLP_test.csv", stringsAsFactors = FALSE)


# Tokenization
tokens <- data %>%
  unnest_tokens(word, OriginalTweet)

print(tokens)
write.csv(tokens, "/Users/anveshkumar/Desktop/pds_assignment3/results/tokens.csv", row.names = FALSE)


# Stopword removal
data_stopwords <- stop_words
tokens_no_stopwords <- tokens %>%
  anti_join(data_stopwords, by = "word")

print(tokens_no_stopwords)
write.csv(tokens_no_stopwords, "/Users/anveshkumar/Desktop/pds_assignment3/results/tokens_no_stopwords.csv", row.names = FALSE)


# Count word frequencies
word_freq <- tokens_no_stopwords %>%
  count(word, sort = TRUE)

print(word_freq)
write.csv(word_freq, "/Users/anveshkumar/Desktop/pds_assignment3/results/word_freq.csv", row.names = FALSE)


# Create word cloud
png("/Users/anveshkumar/Desktop/pds_assignment3/results/wordcloud.png", width = 800, height = 800, units = "px")
wordcloud(words = word_freq$word, freq = word_freq$n, min.freq = 1,
          max.words = 200, random.order = FALSE, rot.per = 0.35,
          colors = brewer.pal(8, "Dark2"))
dev.off()