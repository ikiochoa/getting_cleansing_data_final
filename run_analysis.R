# R project
# 1) a tidy data set as described below
# 2) a link to a Github repository with your script for performing 
# the analysis
# 3) a code book that describes the variables, the data, and any 
# transformations or work that you performed to clean up the data 
# called CodeBook.md.
# 4) a README.md that explains how all scripts work together

# Download data and save file. Couldn't unzip automatically so did manually
if(!file.exists("./data")){dir.create("./data")}
fileUrl = "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"
download.file(fileUrl,destfile="./data/dataset.zip")
# unzip somehow 

# 1. Merge training and test sets to create one dataset (DONE)
# 'train/X_train.txt': Training set. and 'test/X_test.txt': Test set.
testSet = read.table("./data/UCI HAR Dataset/test/X_test.txt")
names(testSet)
trainSet = read.table("./data/UCI HAR Dataset/train/X_train.txt")
names(trainSet)

# merges both sets of data into one 
mergedData = rbind(testSet,trainSet)
# checking it went ok
dim(testSet)
dim(trainSet)
dim(mergedData)

testSet[1:3]
trainSet[1:3]
mergedData[1:3]
class(mergedData[1])

# 2. Extracts only the measurements on the mean and standard 
#    deviation for each measurement.
# Each row is a 561-feature vector with time and frequency domain variables.

#load tidyr to clean data
library(tidyr,dplyr)

#add features_info into the dataset so that we can filter it
features = read.table("./data/UCI HAR Dataset/features.txt")
head(features)
features2 <- filter(features, grepl("-mean()|-std()",V2))
features3 <- filter(features2, grepl("meanFreq()",V2), invert)
features4 <- anti_join(features2,features3)
#according to features4, we need to clean mergedData columns
features4 <- arrange(features4,V1)

for (i in 1:ncol(mergedData)) {
  newname <- toString(features$V2[i])
  oldname <- names(mergedData[i])
  #rename(mergedData, newname = oldname) #always gave error
  names(mergedData)[names(mergedData) == oldname] <- newname
}

select(mergedData,-contains("bandsEnergy"))

#remove unwanted columns
mergedDataA <- mergedData[1:460]
mergedDataB <- mergedData[503:ncol(mergedData)]
mergedDataC <- cbind(mergedDataA,mergedDataB)

mergedData %>%
  select(contains("mean") OR contains("std")) 
#%>%
#  gather(part_sex, count, -score_range) %>%
#  separate(part_sex, c("part", "sex")) %>%
#  group_by(part,sex) %>%
#  mutate(total = sum(count),
#         prop = count/total
#  ) %>% print



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


