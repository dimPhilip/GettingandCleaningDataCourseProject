## Variables Selected for Dataset
The variables (originally call "features in the source documentation) in this dataset are a subset of
from the data provided for this Coursera project. Specifically, it is the "Human Activity Recognition
Using Smartphones Dataset" from the University of California Irvine Machine Learning Repository (UCI MLR):
http://archive.ics.uci.edu/ml/datasets/Human+Activity+Recognition+Using+Smartphones
The variables in this dataset are means of "other variables" calculated by study subject-activity pairs
(e.g. means of variables for subject #2 for each activity subject #2 preformed). The "other variables"
--from the larger dataset from the above mentioned dataset from UCI MLR-- are simple averages (mean)
or standard deviations (std) for different measurement type. This results in means of means or means of
standard deviations. All original variables are normalized and bounded within [-1,1].

## Guide to Variable Name Components
The following list details all the possible components of variable names in the dataset:
* "MEAN" - All variables --except Subject and Activity-- are means of other summary measurements by subject-activity combinations
* "t" - Variable is related to time domain signals (captured at a constant rate of 50 Hz and then filtered using a median filter and a 3rd order low pass Butterworth filter with a corner frequency of 20 Hz to remove noise.  "t" and "f" are mutually exclusive
* "f" - Variable is related to frequency domain signals (a Fast Fourier Transform (FFT) was applied to some of these signals producing a subset of variables). "f" and "t" are mutually exclusive
* "Body" - Variable is related to body movement measurements "Body" and "Gravity" are mutually exclusive
* "Gravity" - Variable is related to gravity measurements. "Gravity" and "Body" are mutually exclusive
* "Acc" - Variable is an accelerometer measurement
* "Gyro" - Variable is a gyroscope measurement
* "Jerk" - Variable is related to jerk signals
* "Mag" - Variable is the magnitude of signals
* "X" - Variable is related to the x-axis in three-dimensional space. A variable that is prefixed by "MEAN" but does not have "X" "Y" or "Z" is calculated across all through axes (e.g. the mean across X, Y, and Z)
* "Y" - Variable is related to the y-axis in three-dimensional space. A variable that is prefixed by "MEAN" but does not have "X" "Y" or "Z" is calculated across all through axes (e.g. the mean across X, Y, and Z)
* "Z" - Variable is related to the z-axis in three-dimensional space. A variable that is prefixed by "MEAN" but does not have "X" "Y" or "Z" is calculated across all through axes (e.g. the mean across X, Y, and Z)

## Variable List
### Non-measurement variables
* "Subject" - The study subject number
* "Activity" - The activity the subject was engaged in. This variable takes on the following values
	1. WALKING
	2. WALKING_UPSTAIRS
	3. WALKING_DOWNSTAIRS
	4. SITTING
	5. STANDING
	6. LAYING

### Measurement variables
* "MEANtBodyAccMeanX"
* "MEANtBodyAccMeanY"
* "MEANtBodyAccMeanZ"
* "MEANtBodyAccStdX"
* "MEANtBodyAccStdY"
* "MEANtBodyAccStdZ"
* "MEANtGravityAccMeanX"
* "MEANtGravityAccMeanY"
* "MEANtGravityAccMeanZ"
* "MEANtGravityAccStdX"
* "MEANtGravityAccStdY"
* "MEANtGravityAccStdZ"
* "MEANtBodyAccJerkMeanX"
* "MEANtBodyAccJerkMeanY"
* "MEANtBodyAccJerkMeanZ"
* "MEANtBodyAccJerkStdX"
* "MEANtBodyAccJerkStdY"
* "MEANtBodyAccJerkStdZ"
* "MEANtBodyGyroMeanX"
* "MEANtBodyGyroMeanY"
* "MEANtBodyGyroMeanZ"
* "MEANtBodyGyroStdX"
* "MEANtBodyGyroStdY"
* "MEANtBodyGyroStdZ"
* "MEANtBodyGyroJerkMeanX"
* "MEANtBodyGyroJerkMeanY"
* "MEANtBodyGyroJerkMeanZ"
* "MEANtBodyGyroJerkStdX"
* "MEANtBodyGyroJerkStdY"
* "MEANtBodyGyroJerkStdZ"
* "MEANtBodyAccMagMean"
* "MEANtBodyAccMagStd"
* "MEANtGravityAccMagMean"
* "MEANtGravityAccMagStd"
* "MEANtBodyAccJerkMagMean"
* "MEANtBodyAccJerkMagStd"
* "MEANtBodyGyroMagMean"
* "MEANtBodyGyroMagStd"
* "MEANtBodyGyroJerkMagMean"
* "MEANtBodyGyroJerkMagStd"
* "MEANfBodyAccMeanX"
* "MEANfBodyAccMeanY"
* "MEANfBodyAccMeanZ"
* "MEANfBodyAccStdX"
* "MEANfBodyAccStdY"
* "MEANfBodyAccStdZ"
* "MEANfBodyAccJerkMeanX"
* "MEANfBodyAccJerkMeanY"
* "MEANfBodyAccJerkMeanZ"
* "MEANfBodyAccJerkStdX"
* "MEANfBodyAccJerkStdY"
* "MEANfBodyAccJerkStdZ"
* "MEANfBodyGyroMeanX"
* "MEANfBodyGyroMeanY"
* "MEANfBodyGyroMeanZ"
* "MEANfBodyGyroStdX"
* "MEANfBodyGyroStdY"
* "MEANfBodyGyroStdZ"
* "MEANfBodyAccMagMean"
* "MEANfBodyAccMagStd"
* "MEANfBodyAccJerkMagMean"
* "MEANfBodyAccJerkMagStd"
* "MEANfBodyGyroMagMean"
* "MEANfBodyGyroMagStd"
* "MEANfBodyGyroJerkMagMean"
* "MEANfBodyGyroJerkMagStd"