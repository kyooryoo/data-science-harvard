library(dplyr)
library(dslabs)
data("murders")

# a simple scatterplot of total murders versus population
x <- murders$population / 10^6
y <- murders$total
plot(x, y)

# a histogram of murder rates
murders <- mutate(murders, rate = total / population * 10^5)
hist(murders$rate)
# find out which state the highest murder rate
murders$state[which.max(murders$rate)]

# boxplots of murder rates by region
boxplot(rate~region, data = murders)

## from exercise

# Load the datasets and define some variables
library(dslabs)
data(murders)

# the original plot
population_in_millions <- murders$population/10^6
total_gun_murders <- murders$total
plot(population_in_millions, total_gun_murders)

# the optimized plot with the items in a more scattered view
# Transform population and total gun murders using the log10 transformation
log10_population <- log10(murders$population)
log10_total_gun_murders <- log10(total_gun_murders)
plot(log10_population, log10_total_gun_murders)

# Store the population in millions and save to population_in_millions 
population_in_millions <- murders$population/10^6
# Create a histogram of this variable
hist(population_in_millions)
# find the state that has the most population
murders$state[which.max(murders$population)]

# Create a boxplot of state populations by region for the murders dataset
boxplot(population~region, data=murders)
