# R project
# 1) a tidy data set as described below
# 2) a link to a Github repository with your script for performing 
# the analysis
# 3) a code book that describes the variables, the data, and any 
# transformations or work that you performed to clean up the data 
# called CodeBook.md.
# 4) a README.md that explains how all scripts work together

if(!file.exists("./data")){dir.create("./data")}
fileUrl = "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"
download.file(fileUrl,destfile="./data/dataset.zip")
# unzip somehow (did it manually)

# 1. Merge training and test sets to create one dataset
# 'train/X_train.txt': Training set. and 'test/X_test.txt': Test set.
testSet = read.table("./data/UCI HAR Dataset/test/X_test.txt")
names(testSet)
trainSet = read.table("./data/UCI HAR Dataset/train/X_train.txt")
names(trainSet)

# merges both sets of data into one
mergedData = rbind(testSet,trainSet)

# 2. Extracts only the measurements on the mean and standard 
#    deviation for each measurement.
dim(testSet)
testSet[1:3]
trainSet[1:3]
dim(trainSet)
head(mergedData)
dim(mergedData)
class(mergedData[1])
# get mean and standard deviations
sapply(mergedData,mean)
sapply(mergedData,sd)
# 3. Uses descriptive activity names to name the activities 
#    in the data set
# 4. Appropriately labels the data set with descriptive variable names.
# 5. From the data set in step 4, creates a second, independent 
#    tidy data set with the average of each variable for each 
#    activity and each subject.





# FOR UPLOADING
# upload your data set as a txt file created with write.table() using row.name=FALSE


