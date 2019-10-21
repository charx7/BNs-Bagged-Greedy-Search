rm(list=ls()) # clean R environment
cat("\f") # clear the console

source('./greedy_search/Greedysearch.R', chdir = TRUE) # source the vanilla greedy search 
source('./utils.R') # source the utils functions
set.seed(43) # set seed to the answer of life

library(magrittr) # for the %>% operator 
library(dplyr)
library(purrr)

m_obs = 50 # number of observations
var_noise = 1 # noise of the data

data = make_test_Data(m_obs, var_noise) # generate data

n_nodes = nrow(data)  #  no. of network nodes
start_incidence = matrix(0, n_nodes, n_nodes) # Generate an empty incidence matrix

#res = greedy_search(data, start_incidence) # run the greedy search algo

bootTrials = 3 # the amount of bs trials
bsResults = list()
for(i in 1:bootTrials) {
  set.seed(47 + i)
  # Sample from your data with replacement
  index       = sample(ncol(data), replace = TRUE)
  bsData      = data[1:n_nodes, index] # get the data from the bs sampled indexes
  
  currBsResults   = greedy_search(bsData, start_incidence) # run a greedy search on the bs sample
  bsResults[[i]] = currBsResults # append to the bsResults list
}
