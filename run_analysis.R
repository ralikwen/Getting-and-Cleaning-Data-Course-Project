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

