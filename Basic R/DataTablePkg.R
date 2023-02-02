# data.table package is good at handling big amount of data

# install the data.table package before you use it!
install.packages("data.table")

# load data.table package
library(data.table)

# load other packages and datasets
library(tidyverse)
library(dplyr)
library(dslabs)
data(murders)

# convert the data frame into a data.table object
# notice there will be two murders objects from here on
murders <- setDT(murders)

# selecting in dplyr
select(murders, state, region)
# selecting in data.table - 2 methods
murders[, c("state", "region")] |> head()
murders[, .(state, region)] |> head()

# adding or changing a column in dplyr
murders <- mutate(murders, rate = total / population * 10^5)
# adding or changing a column in data.table
murders[, rate := total / population * 100000]
head(murders)
murders[, ":="(rate = total / population * 100000, rank = rank(population))]

# y is referring to x and := changes by reference
x <- data.table(a = 1)
y <- x # y is a reference of x but not a copy
x[,a := 2]
y # y is changed by a := 2
y[,a := 1]
x # x is changed by a := 1

# use copy to make an actual copy
x <- data.table(a = 1)
y <- copy(x) # y is a copy of x
x[,a := 2]
y # changing x does not change y

# subsetting in dplyr
filter(murders, rate <= 0.7)
# subsetting in data.table
murders[rate <= 0.7]

# combining filter and select in data.table
murders[rate <= 0.7, .(state, rate)]
# combining filter and select in dplyr
murders %>% filter(rate <= 0.7) %>% select(state, rate)

# prepare the heights data set for practice
data(heights)
heights <- setDT(heights)

# summarizing in dplyr
s <- heights %>% 
  summarize(average = mean(height), standard_deviation = sd(height))
# summarizing in data.table
s <- heights[, .(average = mean(height), standard_deviation = sd(height))]

# subsetting and then summarizing in dplyr
s <- heights %>% 
  filter(sex == "Female") %>%
  summarize(average = mean(height), standard_deviation = sd(height))
# subsetting and then summarizing in data.table
s <- heights[sex == "Female", .(average = mean(height), standard_deviation = sd(height))]

# previously defined function
median_min_max <- function(x){
  qs <- quantile(x, c(0.5, 0, 1))
  data.frame(median = qs[1], minimum = qs[2], maximum = qs[3])
}
# multiple summaries in data.table
heights[, .(median_min_max(height))]

# grouping then summarizing in data.table
heights[, .(average = mean(height), standard_deviation = sd(height)), by = sex]
# in dplyr
heights %>%
  group_by(sex) %>%
  summarise(average = mean(height), standard_deviation = sd(height))

# order by population
murders[order(population)] |> head()
# order by population in descending order
murders[order(population, decreasing = TRUE)] 
# order by region and then murder rate
murders[order(region, rate)]

# view the dataset returned by group_by
murders %>% group_by(region)
# see the class
murders %>% group_by(region) %>% class()

# compare the print output of a regular data frame to a tibble
gapminder
as_tibble(gapminder)

# compare subsetting a regular data frame and a tibble
class(murders[,1]) # subset of a data frame is not a data frame but a vector
class(as_tibble(murders)[,1]) # sebset of a tibble is still a tibble
# access a column as a vector but not as a tibble using $
class(as_tibble(murders)$state)

# accessing a column that doesn't exist in a regular data frame or in a tibble
murders$State
as_tibble(murders)$State

# create a tibble
tibble(id = c(1, 2, 3), func = c(mean, median, sd))

# there are several differences between tibble and data frame
# print returns more readable result of a tibble than a data frame
# subset a tibble gives you a tibble unless you tell it not to do that
# trying accessing a not existing column in tibble returns error message
# tibble can hold more complex typed data such as functions or lists

options(digits = 3)    # report 3 significant digits for all answers
str(heights) # check the data structure of the sample data frame
# how many individuals in the data set are above average height
ind <- heights$height > mean(heights$height)
sum(ind) 
# how many female are in the above individuals
female <- filter(heights, sex == "Female")
ind <- female$height > average
sum(ind)
# What proportion of individuals in the dataset are female

# generate all integers between 50 and 82
x <- 50:82
# how many numbers between 50 and 82 are not height values
sum(!x %in% heights$height)