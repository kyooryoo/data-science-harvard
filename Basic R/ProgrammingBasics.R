# an example showing the general structure of an if-else statement
a <- 0
if(a!=0){
  print(1/a)
} else{
  print("No reciprocal for 0.")
}

# an example that tells us which states, if any, have a murder rate less than 0.5
library(dslabs)
data(murders)
murder_rate <- murders$total / murders$population*100000
ind <- which.min(murder_rate)
if(murder_rate[ind] < 0.5){
  print(murders$state[ind]) 
} else{
  print("No state has murder rate that low")
}

# changing the condition to < 0.25 changes the result
if(murder_rate[ind] < 0.25){
  print(murders$state[ind]) 
} else{
  print("No state has a murder rate that low.")
}

# the ifelse() function works similarly to an if-else conditional
a <- 0
ifelse(a > 0, 1/a, NA)

# the ifelse() function is particularly useful on vectors
a <- c(0,1,2,-4,5)
result <- ifelse(a > 0, 1/a, NA)

# the ifelse() function is also helpful for replacing missing values
data(na_example)
sum(is.na(na_example)) # notice there are 145 nas in the data set
no_nas <- ifelse(is.na(na_example), 0, na_example) # replace nas with 0s
sum(is.na(no_nas)) # now there is no nas in the sample data set anymore

# the any() and all() functions evaluate logical vectors
z <- c(TRUE, TRUE, FALSE)
any(z) # return TRUE if any of the elements is TRUE
all(z) # return TRUE if all of the elements are TRUE

# example of defining a function to compute the average of a vector x
avg <- function(x){
  s <- sum(x)
  n <- length(x)
  s/n
}

# we see that the above function and the pre-built R mean() function are identical
x <- 1:100
identical(mean(x), avg(x)) # this function checks if two args are identical

# variables inside a function are not defined in the workspace
s <- 3 # s got assigned value before the function
avg(1:10) # inside the function, s got new values
s # however, s will still has its original value afer the function

# the general form of a function
my_function <- function(VARIABLE_NAME){
  perform operations on VARIABLE_NAME and calculate VALUE
  VALUE
}

# functions can have multiple arguments as well as default values
# depending on the second argument, compute different average values
avg <- function(x, arithmetic = TRUE){
  n <- length(x)
  ifelse(arithmetic, sum(x)/n, prod(x)^(1/n))
}

# a table of values comparing our function to the summation formula
head(data.frame(s_n = s_n, formula = n*(n+1)/2))
# we will evaluate the correctness of the above formula as follows

# creating a function that computes the sum of integers 1 through n
# this function will be used for the evaluation later
compute_s_n <- function(n){
  x <- 1:n
  sum(x)
}

# a very simple for-loop for a better understanding about the for loop
for(i in 1:5){
  print(i)
}

# a for-loop for computing the summation from 1 to m without using formula
m <- 25
s_n <- vector(length = m) # create an empty vector
for(n in 1:m){
  s_n[n] <- compute_s_n(n)
}

# creating a plot for our summation function
n <- 1:m
plot(n, s_n)
# overlaying with the summation from formula to validate its correctness
lines(n, n*(n+1)/2)
# as a result you can see the plot of dots matches the plot of lines
# this means the results are the same with or without the formula

# the vector test is defined outside of the for loop
test <- vector(length = 5)
for (i in 1:5){
  test[i] <- i^2 # the elements of the test vector are assigned in the loop
}
test # the value of the elements in test are defined in the for loop
i # so does i

# in R the are more powerful functions than the for loop they are
# apply()
# sapply()
# tapply(vector, index, function)
# mapply(function, ...)

# nchar function returns the number of characters in a string
# Assign the state abbreviation when the state name is longer than 8 characters 
new_names <- ifelse(nchar(murders$state)>8, murders$abb, murders$state)

# Create function called `sum_n`
sum_n <- function(n) {
  sum <- 0
  for(i in 1:n) {
    sum = i + sum
  }
  sum
}
# Use the function to determine the sum of integers from 1 to 5000
sum_n(5000)

# compute the 1+2^2+...+n^2 from 1 to m
m = 25
# Define a function and store it in `compute_s_n`
compute_s_m <- function(n){
  x <- 1:n
  sum(x^2)
}
# Create a vector for storing results
s_m <- vector("numeric", m)
# write a for-loop to store the results in s_n
for (i in 1:m) {
  s_m[i] <- compute_s_m(i)
}
print(s_m)
# plot the s_m to n
plot(n, s_m)
# create a new vector with the same result calculated from formula
s_n <- vector("numeric", 25)
for(i in n){
  s_n[i] <- i*(i+1)*(2*i+1)/6
}
# check if the two results are identical or not
identical(s_n,s_m)