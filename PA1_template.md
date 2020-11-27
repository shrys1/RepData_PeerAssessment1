----

# Reproducible Research Week assignment

## Load ggplot2 package from library
```{r}
library(ggplot2)
```

## Load and procees data
#### Unzip file activity.zip after cloning the repo
```{r}
unzip("./activity.zip")
#### Read the csv file 
data <- read.csv("./activity.csv")
## Remove NA values
data1 <- na.omit(data)
```

----



----

## What is mean total number of steps taken per day?
#### 1. Find number of steps per day using split and sapply
```{r}
stepsperday <- sapply(split(data1$steps, data1$date), sum)
```


#### 2. Make a histogram of the total number of steps taken each day
```{r}
## Histogram of number of stpes taken per day
hist(stepsperday, col = "blue", xlab = "Number of Steps per day",breaks = 20)
```


#### 3. Calculate and report the mean and median of the total number of steps taken per day
```{r}
## Mean and Median
mean(stepsperday)
median(stepsperday)
```
-----


-----

## What is the average daily activity pattern?
#### 1. Make a time series plot of the 5-minute interval and the average number of steps taken, averaged across all days
```{r}
## Mean of each five minute interval
avg5min <- sapply(split(data1$steps, data1$interval), mean)
## Plot of mean 5 minute intervals
plot(names(avg5min), avg5min, type = "l", xlab = "Interval", col = "blue",
     ylab = "Number of Steps", main = "Average Steps in 5 minute Intervals")
```

#### 2. Which 5-minute interval, on average across all the days in the dataset, contains the maximum number of steps?
```{r}
## Maximum in five minute interval
which.max(avg5min)
## At 08:35 [24h format] most steps
```

----

----

## Imputing missing values

#### 1. Calculate and report the total number of missing values in the dataset
```{r}
## Missing values
sum(is.na(data))
```

#### 2. Filling in all of the missing values in the dataset
#### 3. Create a new dataset that is equal to the original dataset but with the missing data filled in
```{r}
## New dataset with replacement of NA's with mean of 5 minute interval
data2 <- data
data2$steps[which(is.na(data2))] <- as.numeric(paste(avg5min[as.character(
  data2$interval[which(is.na(data2))])]))
```

#### 4. Histogram of the total number of steps taken each day
```{r}
## Find number of steps per day using split and sapply of modified dataset
stepsperday2 <- sapply(split(data2$steps, data2$date), sum)
## Histogram of number of stpes taken per day of modified dataset
hist(stepsperday2, col = "blue", xlab = "Number of Steps per day",breaks = 20)
## Mean and Median
mean(stepsperday2)
median(stepsperday2)
## There is no change in mean, as for median shifts since number of
## observations has been increased
```

----

----

## Are there differences in activity patterns between weekdays and weekends?
#### 1. Create a new factor variable in the dataset with two levels – “weekday” and “weekend” indicating whether a given date is a weekday or weekend day
```{r}
#### Weekdays
data2$daytype <- ifelse(weekdays(as.Date(data2$date)) == "Saturday" | 
                weekdays(as.Date(data2$date)) == "Sunday", "Weekend", "Weekday")
avg5min2 <- aggregate(steps ~ interval + daytype, data = data2, mean)

```

#### 2. Make a panel plot containing a time series plot
```{r}
## Panel plot
ggplot(data = avg5min2, aes(interval, steps)) + geom_line() +
  facet_grid(daytype ~ .) +
  xlab("5 Minute Interval") +
  ylab("Average Steps")
## There is significant increase in Average steps taken from 10:00 to 20:00,
## whereas there is decrease in Average steps between 05:00 to 10:00, during
## Weekends compared to Weekdays
```

----