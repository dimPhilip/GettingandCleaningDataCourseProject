## Getting and Cleaning Data (Coursera Project)
GitHub Name: dimPhilip

##	Purpose of the Project/Code
The purpose of this project is to return a tidy dataset (output under the name "dataTidy.txt").
This tidy data set contains the means each subject-activity combination for a set of variables
extracted from a larger dataset. The set of variables themselves are either simple means 
weighted averages were excluded) or standard deviations.

## Describing the Original Data
The original (larger) dataset randomly split 30 study subjects (between the ages of 19-48) into a
test group and a training group.
These groups are reintegrated in the tidy dataset. There were six activities that subjects were engaged
(WALKING, WALKING_UPSTAIRS, WALKING_DOWNSTAIRS, SITTING, STANDING, LAYING). Each participant had a
Samsung Galaxy S II on his/her waist. Using the embedded accelerometer and gyroscope, 3-axial
measurements were captured. These measurements were further processed, resulting in the files that are
contained in the original "data.zip" file. For more information on the design of the study and measurement of the
variables, see "features_info.txt" and "README.txt" files which are also in the original "data.zip" file.
Original "data.zip" file can be downloaded from this link:
https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip

## Processing the Original Data into the Tidy Dataset
The R code in "run_analysis.R" contains all the code for processing the data. It assumes that you have
"data.zip" unzipped in R's working directory. For a full description of the tidy dataset variables, see the accompanying codebook ("Code.Book.md").

### Code for Downloading Original Data
As already noted, "run_analysis.R" assumes that the original data is downloaded and unzipped in R's working directory. Code that downloads and unzips the original data is included below

	###########################################
	#Setup working directory and download data#
	###########################################

	#check if there is a folder named "Getting and Cleaning Data - Q1 data" and create
	#folder if it doesn't exist
	if(!file.exists("Getting and Cleaning Data - project data")) {
	  dir.create("Getting and Cleaning Data - project data")
	}
	setwd("./Getting and Cleaning Data - project data")
	URL <- "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"
	download.file(URL, destfile = "./data.zip")
	unzip("./data.zip")

### High level data processing description
* Read in and combine the training group subject IDs, measurements data,and numeric code for the activity engaged in by subject (each is one .txt file). Measurements is read in with "messy" variable names
* Read in and combine the test group subject IDs, measurements data,and numeric code for the activity engaged in by subject (each is one .txt file). Measurements is read in with "messy" variable names
* Merge the combined training and test datasets
* Merge in the descriptive version of activity (i.e. 1 corresponds to WALKING, etc.)
* Remove any variables not related to simple mean or standard deviation
* Clean "messy" variable names
* Reshape data for easy transformation into tidy form (means of all kept variables). Done with "melt" command
* Transform reshaped data into tidy dataset
* Output tidy dataset as "dataTidy.txt"

### Detailed data processing description
* Read in the file ("features.txt") that contains the names of the measurement variables
* Construct Complete Training Dataset by reading in and combining the following:
	* "subject_training.txt" - this is the subject number for each observation is the training dataset, variable name to be added after loading and combining test data
	* "x_training.txt" - this is the main dataset, variable(column) names added as read in using "features.txt" which is already ready in and prepared
	* "y_training.txt" - this is the numeric version of activity, variable name to be added after loading and combining test data
* Construct Complete Test Dataset by reading in and combining the following:
	* "subject_test.txt" - this is the subject number for each observation is the training dataset, variable name to be added after loading and combining test data
	* "x_test.txt" - this is the main dataset, variable(column) names added as read in using "features.txt" which is already ready in and prepared
	* "y_test.txt" - this is the numeric version of activity, variable name to be added after loading and combining test data
* Stack combined training and test datasets and add variable name for subject and numeric activity code variables (columns)
* Merge the descriptive activity variable (named "Activity) onto the stacked dataset
* Remove any variables not related to simple mean or standard deviation ("std")
	* Remove "Mean" from variable names (because "mean" is a word that will be used to identify variables to keep). Variables with "Mean" in the name are related to "angle" variables and so are not of a similar type as the rest of the variables to be kept
	* Remove "meanFreq" from variable names (because "mean" is a word that will be used to identify variables to keep). Variables with "meanFreq" are not simple averages but weighted averages and so are not of a similar type as the rest of the "mean" variables
	* Make a logical vector with TRUE whenever "Subject" "Activity" "mean" or "std" is in a variable name and FALSE otherwise. This drops the numeric activity code variable.
	* Use logical vector made above to only keep the select group of variables related to simple means and standard deviations ("std")
* Clean and standardize variable names
	* Remove all dots/periods
	* Replace "BodyBody" with "Body" as this seems to have been a typo created along with the original dataset
	* Capitalize the first letter in "mean" and "std" so all words and abbreviations (except "t" and "f" see CodeBook.md for more detail) start with a capital letter
* Reshape data using the "melt" command from the "reshape2" R package. This yields a dataset with four columns, "Subject" and "Activity" as ID variables and a variable names column and a variable value column (e.g. if "Subject" "Activity" and three other variables (V1, V2, V3) were the only variables and there was only one observation, the new dataset would have three observations: Obs1[Subject, Activity, V1 Name, V1 Value] Obs2[Subject, Activity, V2 Name, V2 Value] Obs3[Subject, Activity, V3 Name, V3 Value]
* Recast the data taking the mean of each variable by Subject-Activity combination.
	* After recasting the data (using the "dcast" command from the "reshare2" R package), add "MEAN" to the front of each new mean variable.
* Output the dataset as a "dataTidy.txt" file

### Full R Code for Processing Original Dataset into Tidy Dataset

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