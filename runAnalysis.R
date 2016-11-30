# 1. Merges the datasets
train1 <- read.table("train/X_train.txt")
test1 <- read.table("test/X_test.txt")
traintest1 <- rbind(train1, test1)
train1 <- read.table("train/subject_train.txt")
test1 <- read.table("test/subject_test.txt")
traintest2 <- rbind(train1, test1)
train1 <- read.table("train/y_train.txt")
test1 <- read.table("test/y_test.txt")
traintest3 <- rbind(train1, test1)
# 2. Extracts only the measurements 
features <- read.table("features.txt")
good_features <- grep("-mean\\(\\)|-std\\(\\)", features[, 2])
traintest1 <- traintest1[, good_features]
names(traintest1) <- features[good_features, 2]
names(traintest1) <- gsub("\\(|\\)", "", names(traintest1))
names(traintest1) <- tolower(names(traintest1))
# 3. Uses descriptive activity names
activities <- read.table("activity_labels.txt")
activities[, 2] = gsub("_", "", tolower(as.character(activities[, 2])))
traintest3[,1] = activities[traintest3[,1], 2]
names(traintest3) <- "activity"
# 4. Labels the data set
names(traintest2) <- "subject"
cleaned <- cbind(traintest2, traintest3, traintest1)
write.table(cleaned, "clean_data.txt")
# 5. Creates independent tidy data set 
uniqueSubs = unique(traintest2)[,1]
numSubs = length(unique(traintest2)[,1])
numActs = length(activities[,1])
numCols = dim(cleaned)[2]
result = cleaned[1:(numSubs*numActs), ]
row = 1
for (x in 1:numSubs) {
  for (y in 1:numActs) {
    result[row, 1] = uniqueSubs[x]
    result[row, 2] = activities[y, 2]
    tmp <- cleaned[cleaned$subject==x & cleaned$activity==activities[y, 2], ]
    result[row, 3:numCols] <- colMeans(tmp[, 3:numCols])
    row = row+1
  }
}
write.table(result, "with_the_averages.txt")
