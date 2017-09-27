# Load necessary libraries
library(tidyr,dplyr)

# Download data and save file. Couldn't unzip automatically so did manually
if(!file.exists("./data")){dir.create("./data")}
fileUrl = "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"
download.file(fileUrl,destfile="./data/dataset.zip")
# unzip somehow 

## 1. Merge training and test sets to create one dataset
# Read and merge files
testSet = read.table("./data/UCI HAR Dataset/test/X_test.txt")
trainSet = read.table("./data/UCI HAR Dataset/train/X_train.txt")
mergedData = rbind(testSet,trainSet)

## 2. Extracts only the measurements on the mean and standard deviation for each measurement.
# Read features_info into in order to filter it
features = read.table("./data/UCI HAR Dataset/features.txt")
# get terms with mean and std in variables
features2 <- filter(features, grepl("-mean()|-std()",V2))
# get terms that need to get removed
features3 <- filter(features2, grepl("meanFreq()",V2), invert)
# get intersection of terms, so that only mean and std remains and sort ascending
features4 <- anti_join(features2,features3)
features4 <- arrange(features4,V1)

# 4. Appropriately labels the data set with descriptive variable names.
for (i in 1:ncol(mergedData)) {
  newname <- toString(features$V2[i])
  oldname <- names(mergedData[i])
  names(mergedData)[names(mergedData) == oldname] <- newname
}

# Remove unwanted columns that produce problems (bandsEnergy)
select(mergedData,-contains("bandsEnergy"))
mergedDataA <- mergedData[1:460]
mergedDataB <- mergedData[503:ncol(mergedData)]
mergedDataC <- cbind(mergedDataA,mergedDataB)

# Select variables that are of interest
mergedDataMean <- select(mergedDataC,contains("-mean()"))
mergedDataStd <- select(mergedDataC,contains("-std()"))
newData <- cbind(mergedDataMean,mergedDataStd)

# 3. Uses descriptive activity names to name the activities in the data set
# Read files subject_train and subject_test contain the subject per rows for each dataset, y_test and y_train are labeled activities of the users
testLabels = read.table("./data/UCI HAR Dataset/test/y_test.txt")
trainLabels = read.table("./data/UCI HAR Dataset/train/y_train.txt")
mergedLabels = rbind(testLabels,trainLabels)

#Add activities to table and rename variable
newData <- cbind(newData,mergedLabels)
names(newData)[names(newData) == "V1"] <- "activity"

# Read files, add subjects to table and rename variable
testSubjects = read.table("./data/UCI HAR Dataset/test/subject_test.txt")
trainSubjects = read.table("./data/UCI HAR Dataset/train/subject_train.txt")
mergedSubjects = rbind(testSubjects,trainSubjects)
newData <- cbind(newData,mergedSubjects)
names(newData)[names(newData) == "V1"] <- "subjects"

# Change number of activity into name of activity
newDataLabels <- mutate(newData, activity_labels = activityLabels$V2[activity_labels])
activityLabels = read.table("./data/UCI HAR Dataset/activity_labels.txt")

# 5. From the data set in step 4, creates a second, independent tidy data set with the average of each variable for each activity and each subject.
# Group data by subject and activity
newDataGrouped <- group_by(newDataLables,subjects,activity)

# Provide mean of data for each subject + activity
dataMeans <- summarize_all(newDataGrouped,funs(mean))

# FOR UPLOADING
# upload your data set as a txt file created with write.table() using row.name=FALSE
write.table(dataMeans,file="./Final Project/tidy_data.txt",row.name=FALSE)

