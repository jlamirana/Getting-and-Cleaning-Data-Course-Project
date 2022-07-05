install.packages("dplyr")
library(dplyr)

file_name <- "getdata_projectfiles_UCI HAR Dataset.zip"
if(!file.exists(file_name)) {
  url <- "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"
  download.file(url, destfile = file_name) #note: add "method = curl" as the third arg mac/linux users
  unzip(file_name)
}

activities <- read.table("UCI HAR Dataset/activity_labels.txt", col.names = c("code","activity"))
features  <- read.table("UCI HAR Dataset/features.txt", col.names = c("code","signal"))

#train datasets
sub_train <- read.table("UCI HAR Dataset/train/subject_train.txt", col.names = "subject")
x_train <- read.table("UCI HAR Dataset/train/X_train.txt", col.names = features$signal)
y_train <- read.table("UCI HAR Dataset/train/Y_train.txt", col.names = "activity")

#test datasets
sub_test <- read.table("UCI HAR Dataset/test/subject_test.txt", col.names = "subject")
x_test <- read.table("UCI HAR Dataset/test/X_test.txt", col.names = features$signal)
y_test <- read.table("UCI HAR Dataset/test/Y_test.txt", col.names = "activity")

#combining train and test datasets
subject <- rbind(sub_train, sub_test)
x_dataset <- rbind(x_train, x_test)
y_dataset <- rbind(y_train, y_test)
merged_dataset <- cbind(subject, y_dataset, x_dataset)

#extracting only the measurements on the mean and standard deviation for each measurement
tidy_data <- select(merged_dataset, subject, activity, contains("mean"), contains("sd"))

#naming the activities in the data set using descriptive activity names
tidy_data$activity <- activities[tidy_data$activity, 2]

#setting descriptive variable names
names(tidy_data) = (gsub("^t", "t.", names(tidy_data)))
names(tidy_data) = (gsub("^f", "f.", names(tidy_data)))
names(tidy_data) = (gsub("BodyBody", "body-", names(tidy_data)))
names(tidy_data) = (gsub("BodyAccJerkMag", "body-acc-jerk-mag", names(tidy_data)))
names(tidy_data) = (gsub("BodyAccJerk", "body-acc-jerk", names(tidy_data)))
names(tidy_data) = (gsub("BodyGyroJerk", "body-gyro-jerk", names(tidy_data)))
names(tidy_data) = (gsub("BodyGyroMag", "body-gyro-mag", names(tidy_data)))
names(tidy_data) = (gsub("AccJerkMag", "acc-jerk-mag", names(tidy_data)))
names(tidy_data) = (gsub("BodyGyroJerkMag", "body-gyro-jerk-mag", names(tidy_data)))
names(tidy_data) = (gsub("GyroJerkMag", "acc-gyro-jerk-mag", names(tidy_data)))
names(tidy_data) = (gsub("BodyAccMag", "body-acc-mag", names(tidy_data)))
names(tidy_data) = (gsub("GravityAccMag", "gravity-acc-mag", names(tidy_data)))
names(tidy_data) = (gsub("GravityAcc", "gravity-acc", names(tidy_data)))
names(tidy_data) = (gsub("gravityMean", "gravity-mean", names(tidy_data)))
names(tidy_data) = (gsub("meanFreq", "freq-mean", names(tidy_data)))
names(tidy_data) = (gsub("BodyAcc", "body-acc", names(tidy_data)))
names(tidy_data) = (gsub("BodyGyro", "body-gyro", names(tidy_data)))
names(tidy_data) = (gsub("GyroMag", "gyro-mag", names(tidy_data)))
names(tidy_data) = (gsub("gyroMean", "gyro-mean", names(tidy_data)))
names(tidy_data) = (gsub("accMean", "acc-mean", names(tidy_data)))

#grouping-by and exporting into csv file
final_data <- group_by(tidy_data, subject, activity)
write.csv(final_data, "tidy_data.csv", row.names = T)
str(final_data)