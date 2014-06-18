Getting and Cleaning Data Course Project
========================================

# Running the script
    R -f run_analysis.R
    This script will download the data set https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip and extract.
    The tidy dataset should get created in the current directory as tidy_data_with_means.txt

# Notes
    The extraction will result in a "UCI HAR Dataset" folder that has all the files in the required structure.
    The training and test data are available in folders named train and test respectively.
    For each of these data sets:
        Measurement data is present in X_<dataset>.txt file
        Subject information is present in subject_<dataset>.txt file
        Activity codes are present in y_<dataset>.txt file
    All activity codes and their labels are in a file named activity_labels.txt.
    Names of all measurements taken are present in file features.txt ordered and indexed as they appear in the X_<dataset>.txt files.
    All column names representing means contain ...mean() in them.
    All column names representing standard deviations contain ...std() in them.

