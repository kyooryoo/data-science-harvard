# defining murder rate as before
murder_rate <- murders$total / murders$population * 100000
# creating a logical vector that specifies if the murder rate is <= 0.71
index <- murder_rate <= 0.71
# returns the states that have murder rates less than or equal to 0.71
murders$state[index]
# find out how many states have a murder rate less than or equal to 0.71
sum(index)

# creating the two logical vectors representing our conditions
west <- murders$region == "West"
safe <- murder_rate <= 1
# defining an index and identifying states with both conditions true
index <- safe & west
murders$state[index]

x <- c(FALSE, TRUE, FALSE, TRUE, TRUE, FALSE)
which(x)    # returns indices that are TRUE

# to determine the murder rate in Massachusetts we may do the following
index <- which(murders$state == "Massachusetts")
index
murder_rate[index]

# to obtain the indices and subsequent murder rates of New York, Florida, Texas, we do:
index <- match(c("New York", "Florida", "Texas"), murders$state)
index
murders$state[index]
murder_rate[index]

x <- c("a", "b", "c", "d", "e")
y <- c("a", "d", "f")
y %in% x

# to see if Boston, Dakota, and Washington are states
c("Boston", "Dakota", "Washington") %in% murders$state

# You must use !ind to return TRUE for missing values
# return TRUE for vector ind that are missing from the murders dataset
!ind %in% murders$state

# Store the 3 abbreviations in a vector called `abbs`
abbs <- c("AK", "MI", "IA")
# Match the abbs to the murders$abb and store in ind
ind <- match(abbs, murders$abb)
# Print state names from ind
murders$state[ind]

# store the 5 abbreviations in `abbs`
abbs <- c("MA", "ME", "MI", "MO", "MU")
# check if the entries of abbs are in the the murders data frame
abbs %in% murders$abb
# find out which index abbreviations are not part of the dataset
ind <- which(!abbs%in%murders$abb)
# Names of abbreviations in `ind`
abbs[ind]