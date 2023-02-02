# installing and loading the dplyr package
install.packages("dplyr")
library(dplyr)

# adding a column with mutate
library(dslabs)
data("murders")
murders <- mutate(murders, rate = total / population * 100000)

# subsetting with filter
filter(murders, rate <= 0.71)

# selecting columns with select
new_table <- select(murders, state, region, rate)

# using the pipe
murders %>% select(state, region, rate) %>% filter(rate <= 0.71)

# creating a data frame with stringAsFactors = TRUE
grades <- data.frame(names = c("John", "Juan", "Jean", "Yao"), 
                     exam_1 = c(95, 80, 90, 85), 
                     exam_2 = c(90, 85, 85, 90),
                     stringsAsFactors = TRUE)

# Note that if rank(x) gives you the ranks of x from lowest to highest, 
# rank(-x) gives you the ranks from highest to lowest.
x <- c(88, 100, 83, 92, 94)
rank(-x)
# Redefine murders to include a column named rank
# with the ranks of rate from highest to lowest
rate <-  murders$total/ murders$population * 100000
murders <- mutate(murders, rank(-rate))
# Use select to only show state names and abbreviations from murders
select(murders, state, abb)

# show the top 5 states with the highest murder rates.
murders <- mutate(murders, rate = total/population * 100000, rank = rank(-rate))
# Filter to show the top 5 states with the highest murder rates
filter(murders, rank <= 5)

# remove rows using the != operator. For example to remove Florida
no_florida <- filter(murders, state != "Florida")
# Use filter to create a new data frame no_south
no_south <- filter(murders, region != "South")
# Use nrow() to calculate the number of rows
nrow(no_south)

# use the %in% to filter data from New York and Texas like this:
filter(murders, state %in% c("New York", "Texas"))
# Create a new data frame with only the states from the northeast and the west
murders_nw <- filter(murders, region %in% c("Northeast", "West"))
# Number of states (rows) in this category 
nrow(murders_nw)

# you can use logical operators with filter:
filter(murders, population < 5000000 & region == "Northeast")
# add the rate and rank columns
murders <- mutate(murders, rate =  total / population * 100000, rank = rank(-rate))
# Create a table, call it my_states, that satisfies both the conditions 
my_states <- filter(murders, rate < 1 & region %in% c("Northeast", "West"))
# Use select to show only the state name, the murder rate and the rank
select(my_states, state, rate, rank)

# use %>% to perform the same task as above, all in one line
my_states <- murders %>%
  mutate(rate = total / population * 100000, rank = rank(-rate)) %>%
  filter(region %in% c("Northeast", "West") & rate < 1) %>%
  select(state, rate, rank)