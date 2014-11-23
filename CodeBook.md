Data structure:
```
---------------------------------
//Primary key = subjectId, activityLabel
subjectId - unique identifier of subject
activityLabel - unique identifier of activity
------------------------ 
//means of a subset (mean, sd) of observed variables for each primary key
tBodyAcc-mean()-X
tBodyAcc-mean()-Y
tBodyAcc-mean()-Z
tBodyAcc-std()-X
tBodyAcc-std()-Y
tBodyAcc-std()-Z
tGravityAcc-mean()-X
tGravityAcc-mean()-Y
tGravityAcc-mean()-Z
tGravityAcc-std()-X
tGravityAcc-std()-Y
tGravityAcc-std()-Z
tBodyAccJerk-mean()-X
tBodyAccJerk-mean()-Y
tBodyAccJerk-mean()-Z
tBodyAccJerk-std()-X
tBodyAccJerk-std()-Y
tBodyAccJerk-std()-Z
tBodyGyro-mean()-X
tBodyGyro-mean()-Y
tBodyGyro-mean()-Z
tBodyGyro-std()-X
tBodyGyro-std()-Y
tBodyGyro-std()-Z
tBodyGyroJerk-mean()-X
tBodyGyroJerk-mean()-Y
tBodyGyroJerk-mean()-Z
tBodyGyroJerk-std()-X
tBodyGyroJerk-std()-Y
tBodyGyroJerk-std()-Z
tBodyAccMag-mean()
tBodyAccMag-std()
tGravityAccMag-mean()
tGravityAccMag-std()
tBodyAccJerkMag-mean()
tBodyAccJerkMag-std()
tBodyGyroMag-mean()
tBodyGyroMag-std()
tBodyGyroJerkMag-mean()
tBodyGyroJerkMag-std()
fBodyAcc-mean()-X
fBodyAcc-mean()-Y
fBodyAcc-mean()-Z
fBodyAcc-std()-X
fBodyAcc-std()-Y
fBodyAcc-std()-Z
fBodyAcc-meanFreq()-X
fBodyAcc-meanFreq()-Y
fBodyAcc-meanFreq()-Z
fBodyAccJerk-mean()-X
fBodyAccJerk-mean()-Y
fBodyAccJerk-mean()-Z
fBodyAccJerk-std()-X
fBodyAccJerk-std()-Y
fBodyAccJerk-std()-Z
fBodyAccJerk-meanFreq()-X
fBodyAccJerk-meanFreq()-Y
fBodyAccJerk-meanFreq()-Z
fBodyGyro-mean()-X
fBodyGyro-mean()-Y
fBodyGyro-mean()-Z
fBodyGyro-std()-X
fBodyGyro-std()-Y
fBodyGyro-std()-Z
fBodyGyro-meanFreq()-X
fBodyGyro-meanFreq()-Y
fBodyGyro-meanFreq()-Z
fBodyAccMag-mean()
fBodyAccMag-std()
fBodyAccMag-meanFreq()
fBodyBodyAccJerkMag-mean()
fBodyBodyAccJerkMag-std()
fBodyBodyAccJerkMag-meanFreq()
fBodyBodyGyroMag-mean()
fBodyBodyGyroMag-std()
fBodyBodyGyroMag-meanFreq()
fBodyBodyGyroJerkMag-mean()
fBodyBodyGyroJerkMag-std()
fBodyBodyGyroJerkMag-meanFreq()
```

Steps to create above dataset from raw data:
```
library(reshape2)
activityLabels<-read.table("UCI HAR Dataset/activity_labels.txt",col.names=c('row.names','activityLabel'), stringsAsFactors = FALSE)
varNames<-read.table("UCI HAR Dataset/features.txt",col.names=c('row.names','varName'))$varName

trainData<-read.table("UCI HAR Dataset/train/X_train.txt")
names(trainData)<-varNames
trainLabels<-read.table("UCI HAR Dataset/train/y_train.txt",col.names=c('activityLabel'))
trainSubjectID<-read.table("UCI HAR Dataset/train/subject_train.txt",col.names=c('subjectId'))

trData<-cbind(trainData,trainSubjectID)
trData<-cbind(trData,trainLabels)

testData<-read.table("UCI HAR Dataset/test/X_test.txt")
names(testData)<-varNames
testLabels<-read.table("UCI HAR Dataset/test/y_test.txt",col.names=c('activityLabel'))
testSubjectID<-read.table("UCI HAR Dataset/test/subject_test.txt",col.names=c('subjectId'))
tsData<-cbind(testData,testSubjectID)
tsData<-cbind(tsData,testLabels)

allData<-rbind(trData, tsData)
allData<-allData[,grepl('mean|std|subjectId|activityLabel',names(allData))]
 
allData$activityLabel=activityLabels$activityLabel[allData$activityLabel]

meltedData<-melt(allData,id=c('subjectId','activityLabel'))
castDataMean<-dcast(meltedData,subjectId + activityLabel ~ variable,mean)
castDataSd<-dcast(meltedData,subjectId + activityLabel ~ variable,sd)

write.table(castDataMean, file = "tidy.txt", row.name=FALSE)
```
