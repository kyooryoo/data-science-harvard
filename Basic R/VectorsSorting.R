# about vectors
# We may create vectors of class numeric or character with the concatenate function
codes <- c(380, 124, 818)
country <- c("italy", "canada", "egypt")

# We can also name the elements of a numeric vector
# Note that the two lines of code below have the same result
codes <- c(italy = 380, canada = 124, egypt = 818)
codes <- c("italy" = 380, "canada" = 124, "egypt" = 818)

# We can also name the elements of a numeric vector using the names() function
codes <- c(380, 124, 818)
country <- c("italy","canada","egypt")
names(codes) <- country

# Using square brackets is useful for subsetting to access specific elements of a vector
codes[2]
codes[c(1,3)]
codes[1:2]

# If the entries of a vector are named, they may be accessed by referring to their name
codes["canada"]
codes[c("egypt","italy")]

# coercion happens when R guessing data types for entries that do not match the expected.
x <- c(1, "canada", 3) # 1 and 3 are coerced to be characters
as.numeric(x) # turn characters into numbers
as.character(x) # turn numbers into characters
# when there is missing data or something cannot convert, it will be value NA

# Create a vector x of integers that starts at 12 and ends at 73.
x <- 12:73
# Determine the length of object x.
length(x)

# length.out generates sequences that are increasing by the same amount 
x <- seq(0, 100, length.out = 5) # produces the numbers 0, 25, 50, 75, 100.

# integers occupy less memory, so big computations using integers have impact
a <- seq(1, 10)
class (a) # # the class of a is integer
class(1) # by default, R may prefer numeric as data type
class(1L) # for forcing the use of integer data type add L suffix

# about sorting
library(dslabs)
data(murders)
sort(murders$total)

x <- c(31, 4, 15, 92, 65)
x
sort(x)    # puts elements in order

index <- order(x)    # returns index that will put x in order
x[index]    # rearranging by this index puts elements in order
order(x)

murders$state[1:10]
murders$abb[1:10]

index <- order(murders$total)
index[1] # the index of the entry with the smallest total murders
murders$abb[index]    # order abbreviations by total murders

max(murders$total)    # highest number of total murders
i_max <- which.max(murders$total)    # index with highest number of murders
murders$state[i_max]    # state name with highest number of total murders

x <- c(31, 4, 15, 92, 65)
x
rank(x)    # returns ranks (smallest to largest)

# in summary
x <- c(31, 4, 15, 92, 65)
sort(x) # [1]  4 15 31 65 92
order(x) # [1] 2 3 1 5 4 use this index to order vector elements
rank(x) # [1] 3 1 2 5 4 the index of current vector elements in order

# from exercise
# Define a variable states to be the state names from the murders data frame
states <- murders$state
# Define a variable ranks to determine the population size ranks 
ranks <- rank(murders$population)
# Define a variable ind to store the indexes needed to order the population values
ind <- order(murders$population)
# Create a data frame my_df with the state name and its rank and ordered from least populous to most 
my_df <- data.frame(states[ind], ranks[ind])

# from exercise
# Using new dataset 
library(dslabs)
data(na_example)
# Checking the structure 
str(na_example)
# Find out the mean of the entire dataset 
mean(na_example)
# Use is.na to create a logical index ind that tells which entries are NA
ind <- is.na(na_example)
# Determine how many NA ind has using the sum function
sum(ind[TRUE])
# Compute the average, for entries of na_example that are not NA 
mean(na_example[!is.na(na_example)])

# The name of the state with the maximum population is found by doing the following
murders$state[which.max(murders$population)]
# how to obtain the murder rate
murder_rate <- murders$total / murders$population * 100000
# ordering the states by murder rate, in decreasing order
murders$state[order(murder_rate, decreasing=TRUE)]

# from exercise
# Assign city names to `city` 
city <- c("Beijing", "Lagos", "Paris", "Rio de Janeiro", "San Juan", "Toronto")
# Store temperature values in `temp`
temp <- c(35, 88, 42, 84, 81, 30)
# Convert temperature into Celsius and overwrite the original values of 'temp'
temp <- 5/9 * (temp - 32)
# Create a data frame `city_temps` 
city_temps <- data.frame(city, temp)

# 1 + 1/2^2 + 1/3^2 + ... + 1/100^2
x <- 1:100
sum(1/(x*x))

# Write a line of code to convert time to hours
name <- c("Mandi", "Amy", "Nicole", "Olivia")
distance <- c(0.8, 3.1, 2.8, 4.0)
time <- c(10, 30, 40, 50)
hour <- time / 60 # time in hour
speed <- distance / hour # speed per hour
name[which.max(speed)] # runner who has the fastest speed
