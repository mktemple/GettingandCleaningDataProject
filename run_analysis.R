
# Loading package

library(dplyr)

# set working directory for download

setwd("C:/Users/Home/dad/git/getting and cleaning data/Getting and Cleaning Data Course Project")

# download and unzip files

url <- "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"
download.file( url, destfile = "data.zip" )
unzip("data.zip")
setwd("C:/Users/Home/dad/git/getting and cleaning data/Getting and Cleaning Data Course Project/UCI HAR Dataset")


# read in tables

features <- read.table("features.txt", col.names = c("n","functions"))
activities <- read.table("activity_labels.txt", col.names = c("code", "activity"))
subject_test <- read.table("test/subject_test.txt", col.names = "subject")
x_test <- read.table("test/X_test.txt", col.names = features$functions)
y_test <- read.table("test/y_test.txt", col.names = "code")
subject_train <- read.table("train/subject_train.txt", col.names = "subject")
x_train <- read.table("train/X_train.txt", col.names = features$functions)
y_train <- read.table("train/y_train.txt", col.names = "code")

# Step 1 - merge the training and test sets to create one data set

X_combined <- rbind(x_train, x_test)
Y_combined <- rbind(y_train, y_test)
Subject_combined <- rbind(subject_train, subject_test)
Merged_Data <- cbind(Subject_combined, Y_combined, X_combined)

# step 2 - extract only the measurements on the mean and standard deviation for each measurement

Tidy_Data <- Merged_Data %>% select(subject, code, contains("mean"), contains("std"))

# step 3 - use descriptive activity names for the activities n the data set

Tidy_Data$code <- activities[Tidy_Data$code, 2]

# step 4 - appropreately label the data set with descriptive variable names

names(Tidy_Data)[2] = "activity"
names(Tidy_Data)<-gsub("Acc", "Accelerometer", names(Tidy_Data))
names(Tidy_Data)<-gsub("Gyro", "Gyroscope", names(Tidy_Data))
names(Tidy_Data)<-gsub("BodyBody", "Body", names(Tidy_Data))
names(Tidy_Data)<-gsub("Mag", "Magnitude", names(Tidy_Data))
names(Tidy_Data)<-gsub("^t", "Time", names(Tidy_Data))
names(Tidy_Data)<-gsub("^f", "Frequency", names(Tidy_Data))
names(Tidy_Data)<-gsub("tBody", "TimeBody", names(Tidy_Data))
names(Tidy_Data)<-gsub("-mean()", "Mean", names(Tidy_Data), ignore.case = TRUE)
names(Tidy_Data)<-gsub("-std()", "STD", names(Tidy_Data), ignore.case = TRUE)
names(Tidy_Data)<-gsub("-freq()", "Frequency", names(Tidy_Data), ignore.case = TRUE)
names(Tidy_Data)<-gsub("angle", "Angle", names(Tidy_Data))
names(Tidy_Data)<-gsub("gravity", "Gravity", names(Tidy_Data))

# step 5 - from step 4 data set, create a second, independent tidy data set with the average of 
# each variable for each activity and each subject

setwd("C:/Users/Home/dad/git/getting and cleaning data/Getting and Cleaning Data Course Project")

Tidy_Data2 <- Tidy_Data %>%
  group_by(subject, activity) %>%
  summarise_all(funs(mean))
write.table(Tidy_Data2, "TidyData.txt", row.name=FALSE)