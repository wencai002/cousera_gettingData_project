###Step1 
library(reshape2)
#fileUrl<-"https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"
#download.file(fileUrl,destfile = "./data/dataset.zip",method="curl")
#unzip("./data/dataset.zip")
features<-read.table("UCI HAR Dataset/features.txt")
activity_labels<-read.table("UCI HAR Dataset/activity_labels.txt")
subject_test<-read.table("UCI HAR Dataset/test/subject_test.txt")
x_test<-read.table("UCI HAR Dataset/test/X_test.txt")
y_test<-read.table("UCI HAR Dataset/test/y_test.txt")
subject_train<-read.table("UCI HAR Dataset/train/subject_train.txt")
x_train<-read.table("UCI HAR Dataset/train/X_train.txt")
y_train<-read.table("UCI HAR Dataset/train/y_train.txt")
#rowbind *_test and *_train to *_total
x_total<-rbind(x_test,x_train)
y_total<-rbind(y_test,y_train)
subject_total<-rbind(subject_test,subject_train)
#optionally remove the old test and train objects
#rm(x_test,x_train,y_test,y_train,subject_test,subject_train)
#columnbind the x,y and subject together
rawData<-cbind(subject_total,y_total,x_total)
names(rawData)[1]<-"Subject"
names(rawData)[2]<-"activity"
#optionally remove the *_total objects
#rm(x_total,y_total,subject_total)

###Step2 
#change the value of character from factor to character
rawData[,2]<-as.character
#replace the colnames
for (i in 3:(ncol(rawData))){
    names(rawData)[i]<-features[i-2,2]
    i<-i+1
}
#subsetting the column names via grepl
rawData_mean_std<-rawData[,grepl("[Mm]ean|[Ss]td",names(rawData))]
rawData_mean_std<-cbind(rawData[,1:2],rawData_mean_std)

###Step3
#merge the big dataset from last step and activitiy labels and then select the ones needed
MergeData<-merge(rawData_mean_std,activity_labels,by.x = "activity",by.y="V1") %>%
    select(Subject:V2)
#adjust the colname
names(MergeData)[ncol(MergeData)]<-"Activity"

###Step4
#try to clean the special character
names(MergeData)<-gsub("^t", "Time", names(MergeData))
names(MergeData)<-gsub("^f", "Freq", names(MergeData))
names(MergeData)<-gsub("Acc", "Acceleration", names(MergeData))
names(MergeData)<-gsub("mean\\()", "MEAN", names(MergeData))
names(MergeData)<-gsub("std\\()", "STD", names(MergeData))
names(MergeData)<-gsub("[Ff]req\\()", "FREQ", names(MergeData))
names(MergeData)<-gsub("Mag", "Magnitude", names(MergeData))
names(MergeData)<-gsub("Gyro", "Gyroscope", names(MergeData))
#maybe not a bad idea to melt the dataset now since the variable names are better now
MergeData<-melt(MergeData,(id.vars=c("Subject","Activity")))

###Step5
#groupby the dataset from step4 and then run the mean function
MeanData<-group_by(MergeData,Activity,Subject,variable) %>%
    summarize(Mean=mean(value))
#output the result dataset to a txttable
write.table(MeanData, "MeanData.txt", row.name=FALSE)