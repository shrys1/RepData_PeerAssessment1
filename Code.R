## Load ggplot2 package from library
library(ggplot2)
## Unzip file activity.zip after cloning the repo
unzip("./activity.zip")
## Read the csv file 
data <- read.csv("./activity.csv")
## Remove NA values
data1 <- na.omit(data)
## Find number of steps per day using split and sapply
stepsperday <- sapply(split(data1$steps, data1$date), sum)
## Histogram of number of stpes taken per day
hist(stepsperday, col = "blue", xlab = "Number of Steps per day",breaks = 20)
## Mean and Median
mean(stepsperday)
median(stepsperday)
## Mean of each five minute interval
avg5min <- sapply(split(data1$steps, data1$interval), mean)
## Plot of mean 5 minute intervals
plot(names(avg5min), avg5min, type = "l", xlab = "Interval", col = "blue",
     ylab = "Number of Steps", main = "Average Steps in 5 minute Intervals")
## Maximum in five minute interval
which.max(avg5min)
## At 08:35 [24h format] most steps
## Missing values
sum(is.na(data))
## New dataset with replacement of NA's with mean of 5 minute interval
data2 <- data
data2$steps[which(is.na(data2))] <- as.numeric(paste(avg5min[as.character(
                                    data2$interval[which(is.na(data2))])]))
## Find number of steps per day using split and sapply of modified dataset
stepsperday2 <- sapply(split(data2$steps, data2$date), sum)
## Histogram of number of stpes taken per day of modified dataset
hist(stepsperday2, col = "blue", xlab = "Number of Steps per day",breaks = 20)
## Mean and Median
mean(stepsperday2)
median(stepsperday2)
## There is no change in mean, as for median shifts since number of
## observations has been increased
## Weekdays
data2$daytype <- ifelse(weekdays(as.Date(data2$date)) == "Saturday" | 
                weekdays(as.Date(data2$date)) == "Sunday", "Weekend", "Weekday")
## 
avg5min2 <- aggregate(steps ~ interval + daytype, data = data2, mean)
## Panel plot
ggplot(data = avg5min2, aes(interval, steps)) + geom_line() +
  facet_grid(daytype ~ .) +
  xlab("5 Minute Interval") +
  ylab("Average Steps")
## There is significant increase in Average steps taken from 10:00 to 20:00,
## whereas there is decrease in Average steps between 05:00 to 10:00, during
## Weekends compared to Weekdays
