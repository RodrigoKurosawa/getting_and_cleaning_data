#You should create one R script called run_analysis.R that does the following.
#1. Merges the training and the test sets to create one data set.
#2. Extracts only the measurements on the mean and standard deviations for each measurement.
#3. Uses descriptive activity names to name the activities in the data set.
#4. Appropriately labels the data set with descriptive variable names.
#5. From the data set in step 4, creates a second, independent tidy data set
# with the average of each variable for each activity and each subject.

#1. Merges the training and the test sets to create one data set.

#Sets
train_set <- read.table("UCI HAR Dataset/train/X_train.txt")
test_set <- read.table("UCI HAR Dataset/test/X_test.txt")
total_set <- rbind(train_set, test_set)

#Subjects
subject_train <- read.table("UCI HAR Dataset/train/subject_train.txt")
subject_test <- read.table("UCI HAR Dataset/test/subject_test.txt")
total_subjects <- rbind(subject_train, subject_test)

#Activities
train_activities <- read.table("UCI HAR Dataset/train/y_train.txt")
test_activities <- read.table("UCI HAR Dataset/test/y_test.txt")
total_activities <- rbind(train_activities, test_activities)


#2. Extracts only the measurements on the mean and standard deviation for each measurement.

#Getting the features and selecting the ones that contains 'mean()' or 'std()'
features <- read.table("UCI HAR Dataset/features.txt")
means_and_stds <- features[grepl("(mean\\(\\))|(std\\(\\))",features[,2]),]
names(total_set) <- paste(features[,1],features[,2],sep="-")

#Extracting all the mean() and std() from the dataframe 'total_set'
df_means_stds <- total_set[,means_and_stds[,1]]


#3. Uses descriptive activity names to name the activities in the data set

activity_labels <- read.table("UCI HAR Dataset/activity_labels.txt")

activities <- data.frame(Activity=character(nrow(total_activities)),stringsAsFactors=FALSE)
for (i in 1:nrow(activities)){
    activities[i,1] <- toString(activity_labels[activity_labels[1]==total_activities[i,1],2])
}


#4. Appropriately labels the data set with descriptive variable names.

# 'total_set' dataframe already done
# 'activities' dataframe already done
names(total_subjects) <- "Subject"

df_final_data <- cbind(total_subjects,activities,df_means_stds)

#5. From the data set in step 4, creates a second, independent tidy data set with
# the average of each variable for each activity and each subject.
library(dplyr)

final <- df_final_data %>% group_by(Subject,Activity) %>% summarise_each(funs(mean))
write.table(final,file='final_df.txt',row.name=FALSE,sep=";")
