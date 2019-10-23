rm(list=ls()) # clean R environment
cat("\f") # clear the console

source('./utils.R') # source the utils functions
source('./bs_greedy_search.R') # source the bs GS

set.seed(47) # for reproducibility

####### Data Generation
m_obs = 50 # number of observations
var_noise = 1 # noise of the data
data = make_test_Data(m_obs, var_noise) # generate data
bsIterations = c(40, 80, 100) # the amount of iterations we are going to use to compare

results = vector()
for (i in 1:length(bsIterations)) {
  ####### Call the BS Greedy Search Algorithm
  currbsIterations = bsIterations[i]  # num BS iterations
  start_time = Sys.time()
  bsResults = bs_greedy_search(data, currbsIterations) # get the bs output list
  end_time = Sys.time()
  elapsed_time = end_time - start_time
  cat('\nElapsed time for bootstrap Greedy Search: ', elapsed_time, '\n')
  
  ###### Evaluate the results
  # sum over all values outputed by the GS
  SCORES_undirected <- matrix(0,11,11)
  for (i in 1:currbsIterations) {
    SCORES_undirected <- (SCORES_undirected + bsResults[[i]] + t(bsResults[[i]]))
  }
  
  # divide by the number of iterations to get the score for a certain edge
  SCORES_undirected = SCORES_undirected/currbsIterations
  
  # Compute the AUROC
  true_Net = make_true_Net()
  true_Net = true_Net + t(true_Net)
  AUROC    = compute_AUROC(SCORES_undirected,true_Net)
  cat('The AUROC of the experiment was:', AUROC)
  results = c(results, AUROC) # append the value of the AUROC
}
