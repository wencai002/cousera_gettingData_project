# Describe the dataset
This Data CodeBook is used to explain the dataset MeanData.txt. This dataset has four columns:
* Activity: character, describes the activity which is carried out during the observation of this record
* Subject: factor/character, respresents the volunteer ID which is carring out the activity during this observation
* variable: character, describes the feature of the observation, or to be specific the variable of the value in the last column "Mean"
* Mean: numeric/double, the mean value of "Activity+Subject+variable" calculated based on rawData

# Describe how this dataset is cleaned based on the raw dataset
## Getting: at the beginning we download all the files and use 8 files of them:
* features: 561rows, 2columns
* activity_labels: 6rows, 2columns
* subject_test: 2947rows, 1column
* x_test: 2947rows (correspond to subject_test), 561columns (correspond to features) --> one observation is one subject
* y_test: 2947rows (correspond to subject_test), 1column --> one observation is one subject, value corresponds to actitivy
* 3 "*_train" files analog to the last 3 datasets, only difference is with 7352 observations this time
## Cleaning: start the data cleaning process based on the requirements
### main idea is to make "subject+activity+feature" the "key" of the dataset
1) put the 3 "%_test" and the other 3 related "%_train" together, so that we get 10299 observations altogether
2) column binding the 3 files got from 1) "%_subject", "x" and "y" together, based on the assumption that every row in each file corresponds to the identical observation
3) exchange the colNames of the 2) file "rawData" from ID to descriptive, based on dataset "features"
4) merge/exchange the activity ID of the 3) file to descriptive, based on dataset "activity_labels"
5) melt the dataset from 563 cols down to 4, so that the 561 features become part of the observatio value instead of colnames
6) group the same "subject+activity+feature" together and calculate the mean value
