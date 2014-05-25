##################################################################################
#Getting and Cleaning Data - Coursera Class Project                              #
#Author: dimPhilip (GitHub name)                                                 #
##################################################################################

##################################################################################
#Load and combined training and test data into a single dataset for each         #
#                                                                                #
#Code assumes that datafile is unziped in current work directory                 #
##################################################################################

#   The observations in the file "features.txt" are the variable names of the main
#training and test datasets. This will be used to add names to the main training
#and test datasets (x_training.txt and x_test.txt)

varNames <- read.table("./UCI HAR Dataset/features.txt")
varNamesClean <- varNames[,2]

#Construct Complete Training Dataset by reading in and combining the following:
# *subject_training -> is the subject number for each observation is the
#  training dataset, variable name to be added after loading and combining test data
# *x_training -> this is the main dataset, variable(column) names added as read in
# *y_training -> this is the numeric version of activity, variable name to be added
#  after loading and combining test data

dataTrainingSubject <- read.table("./UCI HAR Dataset/train/subject_train.txt")
dataTraining <- read.table("./UCI HAR Dataset/train/X_train.txt",
                           col.names = varNamesClean)
dataTrainingNumAct <- read.table("./UCI HAR Dataset/train/y_train.txt")

dataTrainingComb <- cbind(dataTrainingSubject, dataTraining, dataTrainingNumAct)
names(dataTrainingComb)[c(1, 563)] <- c("Subject", "Act.Num")

#Construct Complete Test Dataset by reading in and combining the following:
# *subject_test -> is the subject number for each observation is the
#  training dataset, variable name to be added after loading and combining test
#  data
# *x_test -> this is the main dataset, variable(column) names added as read in
# *y_test -> this is the numeric version of activity, variable name to be added
#  after loading and combining test data

dataTestSubject <- read.table("./UCI HAR Dataset/test/subject_test.txt")
dataTest <- read.table("./UCI HAR Dataset/test/X_test.txt",
                       col.names = varNamesClean)
dataTestNumAct <- read.table("./UCI HAR Dataset/test/y_test.txt")

dataTestComb <- cbind(dataTestSubject, dataTest, dataTestNumAct)
names(dataTestComb)[c(1, 563)] <- c("Subject", "Act.Num")

##################################################################################
#Merge the test and training datasets (by stacking) and merge descriptive        #
#activity names onto the dataset                                                 #
##################################################################################

#Stack training and test datasets
dataComb <- rbind(dataTrainingComb, dataTestComb)

#   Load descriptive activity names in the "activity_labels.txt" file
#and merge onto the "dataComb" dataset
dataActivityDescr <- read.table("./UCI HAR Dataset/activity_labels.txt", 
                                col.names = c("Act.Num", "Activity"))
dataCombMerged <- merge(dataActivityDescr, dataComb, by.x = "Act.Num",
                        by.y = "Act.Num", all = TRUE)

##################################################################################
#Keep only variables related to "mean," standard deviation "std," subject "ID,"  #
#and "activity" using a descriptive string in each observation.                  #
#                                                                                #
#Also clean up variables names such that there is only ever one "." and a "."    #
#seperates words or abbreviation and "Body" only appears once in each name.      #
##################################################################################

#Get all the names in the dataset
varNamesCM <- names(dataCombMerged)

#   Modify names to replace "meanFreq" and "Mean" with nothing ("") so only
#simple averages for the accelerometer and gyroscope 3-axial raw signals
#remain: "meanFreq" is a weighted average as per the description in
#"features_info.txt and "Mean" is a mean related to "angle" variables
varNamesCMMod <- gsub("Mean|meanFreq", "", varNamesCM)

#Make a logical vector of with "TRUE" for variables to keep
varNamesKeep <- grepl("Subject|Activity|mean|std", varNamesCMMod)

#Subset dataset based on logical vector of names to keep
dataKeep <- dataCombMerged[, varNamesKeep]

#   Remove all "."s; remove double "Body" in variable names, which appears to be
#a typo;and caitalize the first letter of mean and std so that all words and 
#abbreviations (except standalone "t" and "f") start with a capital letter.
namesDataKeep1 <- names(dataKeep)
namesDataKeep2 <- gsub(".", "", namesDataKeep1, fixed = TRUE)
namesDataKeep3 <- gsub("BodyBody", "Body", namesDataKeep2)
namesDataKeep4 <- gsub("mean", "Mean", namesDataKeep3)
namesDataKeep5 <- gsub("std", "Std", namesDataKeep4)

names(dataKeep) <- namesDataKeep5

##################################################################################
#Create a "tidy" dataset with the mean of each variable for subject-Activity pair#
#and rename variables to be prefaced with "MEAN"                                 #
##################################################################################

library(reshape2)

dataKeepMelt <- melt(dataKeep, id = c("Subject", "Activity"),
                     measure.vars = names(dataKeep)[3:length(dataKeep)])

dataTidy <- dcast(dataKeepMelt, Subject + Activity ~ variable, mean)
names(dataTidy)[3:length(dataTidy)] <- paste("MEAN",
                                             names(dataTidy)[3:length(dataTidy)],
                                             sep = "")

##################################################################################
#Write the tidy dataset to a text file                                           #
##################################################################################

write.table(dataTidy, paste(getwd(), "/Tidy_Data.txt", sep = ""),
            row.names = FALSE, sep = "\t")