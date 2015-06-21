## Getting and Cleaning Data Project


### Running the run_analysis.R Script

1. Download the source data [here]. (https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip)

2. Once you have obtained and unzipped the source files, you will need to set the working directory in R 
to the location of the downloaded and unzipped source file. This can be done using the setwd() command.Do not change the name of the folder downloaded.  NOTE: the script uses the getwd() command. The run_analysis.R script will also have to be sourced.

3. Please refer to the CodeBook.md file for additional details.


## List of tasks performed by the run_analysis.R script

1. Merges the training and the test sets to create one data set.
2. Extracts only the measurements on the mean and standard deviation for each measurement. 
3. Uses descriptive activity names to name the activities in the data set
4. Appropriately labels the data set with descriptive activity names. 
5. Creates a second, independent tidy data set with the average of each variable for each activity and each subject. 

