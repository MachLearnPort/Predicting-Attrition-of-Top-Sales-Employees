# TPO R script for HR_Project - For Ranking Attrition Risk
# By: Jeff Schwartzentruber
# Date: Oct 11th 2017

#Laptop
#PW <- "C:\\Users\\Jeff\\Google Drive\\Tailored Process Optimization\\TPO\\HR_Project\\HR_Sales\\"
#Dekstop
PW <- "D:\\Users\\Jeff\\Google Drive\\Tailored Process Optimization\\TPO\\HR_Project\\HR_Sales\\"

library(h2o) #Import h2o library (must be installed prior)
localH2O = h2o.init(ip = "localhost", port = 54321, startH2O = TRUE,min_mem_size = "3g", nthreads = 4) #Initalize h2o instance, 
#*** nthreads has to be to set to 4, or we get and error from H2o about unhealthy nodes after several iterations (i think it has something to do with vitrual cores and their cluster computing infrastructure)
setwd = PW # set working directory where file repo is

library(readr)
Strat <- read_csv(paste(PW, "StratRisk.csv", sep=""))

Risk <- data.frame() #initalize ranking
# Loop through HR data to generate ranks

  for (row in 1:nrow(Strat)) {

  #Create input.csv
  inputFile <-  Strat[row,] #get the ith row
  write.table(as.matrix(inputFile), file=paste(PW,"input.csv", sep=""), row.names=FALSE, sep=",") #Write to csv file
    
    
  input <- h2o.importFile(path = paste(PW, "input.csv", sep=""), destination_frame = "input") #Load generated predict input.csv file, must be an h2o frame

  ## Attrition Model - GBM
  modelPath_A = paste(PW, "Model_Exports\\Attrition_GBM\\gbm-dc422bcf-62bd-40a3-8adc-5f8c9fc1b2f0", sep="") # Location of the exported model from flow
  model_A <- h2o.loadModel(modelPath_A) #Load exported model
  pred_A_h2o <- h2o.predict(model_A, input) #Predict with input.csv with generated model
  pred_A=as.data.frame(pred_A_h2o) #convert h2o from to r frame
  Risk <- rbind(Risk, pred_A) #Create ranking data frame
  
  print(row)
}

write.table(as.matrix(Risk), file=paste(PW,"Predictions\\StratRisk.csv", sep=""), row.names=FALSE, sep=",") #Write ranking to file

# h2o.shutdown(prompt = FALSE)  #Turn to TRUE for paralle computing


