library(plyr);library(dplyr)

# Clean up workspace
rm(list=ls())

#Create file paths using the main directory (this step assumes the directory is set to the path
#with the main directory). It creates platform independent paths based on Windows,MAC, or Linux

main_dir <- file.path(getwd(),"UCI HAR Dataset")
train_data_file <- file.path(main_dir,"train","X_train.txt",fsep = .Platform$file.sep)
train_label_file <- file.path(main_dir,"train","y_train.txt",fsep = .Platform$file.sep)
train_subject_file <- file.path(main_dir,"train","subject_train.txt",fsep = .Platform$file.sep)
test_data_file <- file.path(main_dir,"test","X_test.txt",fsep = .Platform$file.sep)
test_label_file <- file.path(main_dir,"test","y_test.txt",fsep = .Platform$file.sep)
test_subject_file <- file.path(main_dir,"test","subject_test.txt",fsep = .Platform$file.sep)
features_file <- file.path(main_dir,"features.txt",fsep = .Platform$file.sep)
activity_file <- file.path(main_dir,"activity_labels.txt",fsep = .Platform$file.sep)

#####################################################################
# Step1. Merges the training and the test sets to create one data set.
#####################################################################

#Read Training Data
train_data <- read.table(train_data_file)
train_label <- read.table(train_label_file)
train_subject <- read.table(train_subject_file)

#Read Test Data
test_data <- read.table(test_data_file)
test_label <- read.table(test_label_file) 
test_subject <- read.table(test_subject_file)

#Read Activity and Features Data
features <- read.table(features_file)
activity <- read.table(activity_file)

# Assigin column names to the data imported above
colnames(activity)        = c('activityId','activityName');
colnames(train_subject)   = "subjectId";
colnames(train_data)      = features[,2]; 
colnames(train_label)     = "activityId";
colnames(test_subject)    = "subjectId";
colnames(test_data)       = features[,2]; 
colnames(test_label)      = "activityId";

#Merge Train and Test Data
merged_train_data <- cbind(train_subject,train_label,train_data);
merged_test_data <- cbind(test_subject,test_label,test_data);
merged_data <- rbind(merged_train_data,merged_test_data);
id  <- colnames(merged_data)

#####################################################################
# Step2. Extracts only the measurements on the mean and standard 
# deviation for each measurement. 
#####################################################################

# Create a index vector that contains TRUE values for the ID, mean() & stddev() columns and FALSE for others
mean_std_ind <- (grepl("activity..",id) | grepl("subject..",id) | grepl("-mean..",id) & !grepl("-meanFreq..",id) & !grepl("mean..-",id) | grepl("-std..",id) & !grepl("-std()..-",id));

# Subset merged_data table based on the index vector to keep only desired columns
merged_data <- merged_data[mean_std_ind==TRUE]

#####################################################################
# Step3. Uses descriptive activity names to name the activities in 
# the data set
#####################################################################

# Merge the merged_data set with the acitivity table to include descriptive activity names
merged_data = merge(merged_data,activity,by='activityId',all.x=TRUE)

# Updating the id vector to include the new column names after merge
id  <- colnames(merged_data)

#####################################################################
# Step4. Appropriately labels the data set with descriptive activity 
# names. 
#####################################################################

#Make variable names consistent
for (i in 1:length(id)) 
{ 
  id[i] <- gsub("\\()","",id[i])
  id[i] <- gsub("-std$","StdDev",id[i])
  id[i] <- gsub("-mean","Mean",id[i])
  id[i] <- gsub("^(t)","Time",id[i])
  id[i] <- gsub("^(f)","Freq",id[i])
  id[i] <- gsub("([Gg]ravity)","Gravity",id[i])
  id[i] <- gsub("([Bb]ody[Bb]ody|[Bb]ody)","Body",id[i])
  id[i] <- gsub("[Gg]yro","Gyro",id[i])
  id[i] <- gsub("Mag","Magnitude",id[i])
  id[i] <- gsub("([Bb]odyaccjerkmag)","BodyAccJerkMagnitude",id[i])
};

# Reassigning the new descriptive column names to the merged_data set
colnames(merged_data) = id;

#####################################################################
# Step5. Creates a second, independent tidy data set with the average of 
# each variable for each activity and each subject. 
#####################################################################

#Make Dataset to calculate mean
split_merged_data  <- merged_data[,names(merged_data) != 'activityName'];
#Calculate mean 
tidyDataSet    <- aggregate(split_merged_data[,names(split_merged_data) != c('activityId','subjectId')],by=list(activityId=split_merged_data$activityId,subjectId = split_merged_data$subjectId),mean);
#Merge data set with activity type
tidyDataSet    <- merge(tidyDataSet,activity,by='activityId',all.x=TRUE);


# Export the tidyData set 
write.table(tidyDataSet, './TidyDataSet.txt',row.names=FALSE,sep='\t');