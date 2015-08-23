library(dplyr)
library(reshape2)

#Opening Training Data
TrainSubject<-read.table("UCI HAR Dataset/train/subject_train.txt")
TrainSet<-read.table("UCI HAR Dataset/train/X_train.txt")
TrainLabel<-read.table("UCI HAR Dataset/train/y_train.txt")

#Opening Test Data
TestLabel<-read.table("UCI HAR Dataset/test/y_test.txt")
TestSet<-read.table("UCI HAR Dataset/test/x_test.txt")
TestSubject<-read.table("UCI HAR Dataset/test/subject_test.txt")

#Merging Train and Test Data
Train<-cbind(TrainSubject,TrainLabel,TrainSet)
Test<-cbind(TestSubject,TestLabel,TestSet)
Merged<-rbind(Train,Test)

#Extracting Mean and STD measurements
Features<-read.table("UCI HAR Dataset/features.txt")
FeaturesSelectSet<-grep(".*mean.*|.*std.*",as.character(Features[,2]))
FeaturesSelectSetOffset<-FeaturesSelectSet+2
FeaturesSelectMerged<-c(1,2,FeaturesSelectSetOffset)
MergedSetSelect<-Merged[FeaturesSelectMerged] #Extracting required columns of Merged data frame

ActivityLabel<-read.table("UCI HAR Dataset/activity_labels.txt")
MeasurementName<-as.character(Features[FeaturesSelectSet,2])
names(MergedSetSelect)<-c("Subject", "Label", MeasurementName)

#Giving descriptive name 
MergedSetSelect$Label<-mapvalues(as.character(MergedSetSelect[[2]]),from=as.character(ActivityLabel[[1]]),to=as.character(ActivityLabel[[2]]))

#Creating tidy data with average of each activity and label
MergedSetSelectMelt<-melt(MergedSetSelect,id=c("Subject","Label"))
part5<-dcast(MergedSetSelectMelt,Subject+Label~variable,mean)
output<-write.table(part5,"tidy.txt",row.name=FALSE)