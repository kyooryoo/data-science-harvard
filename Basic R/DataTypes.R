class(1) # check the data type of an object
a <- "hello"
class(a) # check the data type of the object saved in a variable

library(dslabs)
class(murders) # check the data type of a data set

# show the data structure of an object
str(1)
str(a)
str(murders) # especially useful for data frames

# show the top and bottom observations in a data frame
head(murders)
tail(murders)

murders$population # get the population column of the murders
murders[["population"]] # another way to get the population column
names(murders) # return all the column names in the murders

pop <- murders$population # create a vector from a df column
length(pop) # check the length of a vector

class(murders$state) # character data type
z <- 3 == 2
class(z) # logical data type
levels(murders$region) # check the levels of a factor data type
# notice, factor is a categorical data type that has levels
# factor is number in the back end but seem like character in front

#######################################################################
# sample code from the official training course

# loading the dslabs package and the murders dataset
library(dslabs)
data(murders)

# determining that the murders dataset is of the "data frame" class
class(murders)
# finding out more about the structure of the object
str(murders)
# showing the first 6 lines of the dataset
head(murders)

# using the accessor operator to obtain the population column
murders$population
# another way to obtain the population column
murders[["population"]]
# displaying the variable names in the murders dataset
names(murders)
# determining how many entries are in a vector
pop <- murders$population
length(pop)
# vectors can be of class numeric and character
class(pop)
class(murders$state)

# logical vectors are either TRUE or FALSE
z <- 3 == 2
z
class(z)

# factors are another type of class
class(murders$region)
# obtaining the levels of a factor
levels(murders$region)