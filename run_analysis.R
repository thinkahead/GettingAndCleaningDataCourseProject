# The numbered comments are to correlate with project description
library("data.table")
library("reshape2")
url <- "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"
f <- "Dataset.zip"
path <- getwd()
if (!file.exists(paste(path,"Dataset.zip",sep="/"))) {
    download.file(url, file.path(path, f), "curl")
    unzip(paste(path,"Dataset.zip",sep="/"))
}
pathDataSet <- file.path(path, "UCI HAR Dataset")
list.files(pathDataSet, recursive=TRUE)

# Read the subject files
dtSubjectTrain <- fread(file.path(pathDataSet, "train", "subject_train.txt"))
dtSubjectTest <- fread(file.path(pathDataSet, "test" , "subject_test.txt" ))
dim(dtSubjectTrain)
dim(dtSubjectTest)
# Read the label files
dtActivityTrain <- fread(file.path(pathDataSet, "train", "y_train.txt"))
dtActivityTest <- fread(file.path(pathDataSet, "test" , "y_test.txt" ))
dim(dtActivityTrain)
dim(dtActivityTest)
# Read the training sets
dtTrain <- read.table(file.path(pathDataSet, "train", "X_train.txt"))
dtTest <- read.table(file.path(pathDataSet, "test" , "X_test.txt" ))
dim(dtTrain)
dim(dtTest)

# 1. Merges the training and the test sets to create one data set.

# Merge the training and the test sets
dtSubject <- rbind(dtSubjectTrain, dtSubjectTest)
setnames(dtSubject, "V1", "subject")
dtActivity <- rbind(dtActivityTrain, dtActivityTest)
setnames(dtActivity, "V1", "activityNum")
dt <- rbind(dtTrain, dtTest)
dim(dtSubject)
dim(dtActivity)
dim(dt)

# 2. Extracts only the measurements on the mean and standard deviation for each measurement. 

# Read the `features.txt` file that tells which variables/columns in `dt` are measurements for the mean and standard deviation.
dtFeatures <- fread(file.path(pathDataSet, "features.txt"))
dim(dtFeatures)
setnames(dtFeatures, names(dtFeatures), c("featureNum", "featureName"))
requiredIndices <- grep("mean\\(\\)|std\\(\\)", dtFeatures$featureName)
length(requiredIndices) 

# 4. Appropriately labels the data set with descriptive variable names. 
# Get only the feature columns for std and mean
dt <- dt[requiredIndices,]
dim(dt)
names(dt) <- gsub("\\(\\)", "", dtFeatures$featureName[requiredIndices]) # remove "()"
names(dt) <- gsub("mean", "Mean", names(dt)) # capitalize M
names(dt) <- gsub("std", "Std", names(dt)) # capitalize S
names(dt) <- gsub("-", "", names(dt)) # remove "-" in column names

# 3. Uses descriptive activity names to name the activities in the data set
# Read `activity_labels.txt` for adding descriptive names to the activities.
dtActivityNames <- fread(file.path(pathDataSet, "activity_labels.txt"))
setnames(dtActivityNames, names(dtActivityNames), c("activityNum", "activityName"))

# Merge columns
dtSubject <- cbind(dtSubject, dtActivity)
dt <- cbind(dtSubject, dt)

# Merge activity labels and remove activityNum
dt <- merge(dt, dtActivityNames, by="activityNum", all.x=TRUE)
dt$activityNum=NULL

# Write out the merged data
write.table(dt, "merged_data.txt")

# 5. Creates a second, independent tidy data set with the average of each variable for each activity and each subject. 
id_vars = c("subject", "activityName")
measure_vars = setdiff(colnames(dt), id_vars)
melted_data <- melt(dt, id=id_vars, measure.vars=measure_vars)
# recast
tidy=dcast(melted_data, activityName + subject ~ variable, mean) 

# Unique activities
#activityLen <- length(unique(dtActivity[[1]]))
activityLen <- dim(dtActivityNames)[1]
activityLen
# Unique Subjects
subjectLen <- length(unique(dtSubject[[1]]))
subjectLen
# Number of columns
columnLen <- dim(dt)[2]
columnLen
# Check that the tidy dataset has correct number of rows
dim(tidy)[1] == activityLen*subjectLen
dim(tidy)[2] == columnLen

# Write out the tidy data
write.table(tidy, "tidy_data_with_means.txt")

