# Function to split long character strings with newlines. Not efficient!
add_newlines <- function(obj, limit=30){
  words <- strsplit(obj, split=' ')[[1]]
  n <- 0
  out_str <- ''
  for(word in words){
    
    word_l <- nchar(word)
    if(word_l>limit){
      stop(sprintf('limit (%s) too short to include: %s', limit, word))
    }
    if(n + word_l > limit){
      out_str <- paste0(out_str, '\n', word)
      n <- 0
    } else{
      out_str <- paste0(out_str, ' ', word)
      n <- n + word_l
    }
  }
  return(out_str)
}