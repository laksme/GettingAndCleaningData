XTrain <- NULL
XTest <- NULL
runAnalysis <- function() {
  filePath <- function(...) { paste(..., sep = "/") }
  
  unzipAfterDownload <- function() {
    url <- "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"
    dirD <- "data"
      
    zipFile <- filePath(dirD, "dataset.zip")
    if(!file.exists(zipFile)) { 
      download.file(url, zipFile, method = "curl") 
    }
    
    directoryName <- "UCI HAR Dataset"
    if(!file.exists(directoryName)) {
      unzip(zipFile, exdir = ".") 
    }
    
    directoryName
  }
  
  directoryName <- unzipAfterDownload()
  
  
  
  loadInfo <- function(path) {
    read.table(filePath(directoryName, path))
  }
  
  
  if(is.null(XTrain)) { XTrain <<- loadInfo("train/X_train.txt") }
  if(is.null(XTest))  { XTest  <<- loadInfo("test/X_test.txt") }
  # Merging training and the test set
  XCombined <- rbind(XTrain, XTest)
  
  featureNames <- loadInfo("features.txt")[, 2]
  names(XCombined) <- featureNames
  
  # Extract only feature names matching mean() or std():
  meanSd <- grep("(mean|std)\\(\\)", names(XCombined))
  CombinedMeanSD <- XCombined[, meanSd]
  
  # Use descriptive activity names to name the activities in the data set.
  # Get the activity data and map to nicer names:
  yTrain <- loadInfo("train/y_train.txt")
  yTest  <- loadInfo("test/y_test.txt")
  YCombined <- rbind(yTrain, yTest)[, 1]
  
  typeOfActivity <-c("Walking", "Walking Upstairs", "Walking Downstairs", "Sitting", "Standing", "Laying")
  act <- typeOfActivity[YCombined]
  
  # Appropriately label the data set with descriptive variable names.
  # Change t to Time, f to Frequency, mean() to Mean and std() to StdDev
  # Remove extra dashes and BodyBody naming error from original feature names
  names(CombinedMeanSD) <- gsub("^t", "Time", names(CombinedMeanSD))
  names(CombinedMeanSD) <- gsub("^f", "Frequency", names(CombinedMeanSD))
  names(CombinedMeanSD) <- gsub("-mean\\(\\)", "Mean", names(CombinedMeanSD))
  names(CombinedMeanSD) <- gsub("-std\\(\\)", "StdDev", names(CombinedMeanSD))
  names(CombinedMeanSD) <- gsub("-", "", names(CombinedMeanSD))
  names(CombinedMeanSD) <- gsub("BodyBody", "Body", names(CombinedMeanSD))
    
  # Add activities and subject with nice names
  trainSubject <- loadInfo("train/subject_train.txt")
  testSubject  <- loadInfo("test/subject_test.txt")
  sub <- rbind(trainSubject, testSubject)[, 1]
  
  tidy <- cbind(Subject = sub, Activity = act, CombinedMeanSD)
  
  # Create a second, independent tidy data set with the average of each variable for each activity and each subject.
  library(plyr)
  # Column means for all but the subject and activity columns
  filterColMeans <- function(data) { colMeans(data[,-c(1,2)]) }
  tidyMeans <- ddply(tidy, .(Subject, Activity), filterColMeans)
  names(tidyMeans)[-c(1,2)] <- paste0("Mean", names(tidyMeans)[-c(1,2)])
  
  # Write file
  write.table(tidyMeans, "tidyMeans.txt", row.names = FALSE)
  
  # Also return data
  tidyMeans
}
