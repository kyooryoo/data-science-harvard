# Monte Carlo Simulations
# model probability by repeating a random process a large enough number of times 
# the results are similar to the result as if the process were repeated forever.

beads <- rep(c("red", "blue"), times = c(2,3))    # create an urn with 2 red, 3 blue
beads    # view beads object
sample(beads, 1)    # sample 1 bead at random
B <- 10000    # number of times to draw 1 bead

# use replicate function to perform sample for specified times
events <- replicate(B, sample(beads, 1))    # draw 1 bead, B times
tab <- table(events)    # make a table of outcome counts
tab    # view count table
prop.table(tab)    # view table of outcome proportions

# sample function does not replace the selection by default
events <- sample(beads, B, replace = TRUE) # specify to replace
tab <- table(events)    # make a table of outcome counts
tab    # view count table
prop.table(tab)    # view table of outcome proportions

# use set.seed(x) for generating the same random number every time
set.seed(1)
set.seed(1, sample.kind="Rounding") # generate a seed as in R 3.5
# a common way for determine the seed is year - month - day
set.seed(1994) # 2023 - 1 - 28 = 1994

# use mean function for calculating the probability
mean(beads == "blue")

## from exercise

# assume we have the following balls in one box
cyan <- 3
magenta <- 5
yellow <- 7
# the probability of choosing a cyan ball from the box
p_1 <- cyan / (cyan + magenta + yellow)
# without replacement
# the probability of not choosing a cyan ball on the second draw
p_2 <- (magenta + yellow) / (cyan + magenta + yellow - 1)
# the probability that the first draw is cyan and the second draw is not cyan
p_1 * p_2
# with replacement
p_2 <- (magenta + yellow) / (cyan + magenta + yellow)
p_1 * p_2


# paste() joins two strings and inserts a space in between.
number <- "Three"
suit <- "Hearts"
paste(number, suit)
# joining vectors element-wise with paste
paste(letters[1:5], as.character(1:5))
# expand.grid() gives the combinations of 2 vectors or lists.
expand.grid(pants = c("blue", "black"), shirt = c("white", "grey", "plaid"))

# generating a deck of cards
suits <- c("Diamonds", "Clubs", "Hearts", "Spades")
numbers <- c("Ace", "Deuce", "Three", "Four", "Five", "Six", "Seven", 
             "Eight", "Nine", "Ten", "Jack", "Queen", "King")
deck <- expand.grid(number = numbers, suit = suits)
deck # a matrix with all the data for cards
deck <- paste(deck$number, deck$suit)
deck # a list of all the cards
# probability of drawing a king
kings <- paste("King", suits) # all the kings in different suits
mean(deck %in% kings) # 0.0769

# a demo of permutations and combinations functions
install.packages("gtools")
library(gtools)
permutations(5,2)    # ways to choose 2 numbers in order from 1:5
# pick 7 items out from 10 items (order matters) with values of 0 to 9
all_phone_numbers <- permutations(10, 7, v = 0:9)
n <- nrow(all_phone_numbers) # there are 604800 rows
index <- sample(n, 5) # randomly select 5 out of the 604800
all_phone_numbers[index,] # use the randomly selected 5 number as index
# a demo of the two functions with the order matters or not
permutations(3,2)    # order matters
combinations(3,2)    # order does not matter

# Probability of drawing a second king given that one king is drawn
hands <- permutations(52,2, v = deck)
first_card <- hands[,1]
second_card <- hands[,2]
sum(first_card %in% kings) # 204
sum(first_card %in% kings & second_card %in% kings) / sum(first_card %in% kings)

# Probability of a natural 21 in blackjack
aces <- paste("Ace", suits)
facecard <- c("King", "Queen", "Jack", "Ten")
facecard <- expand.grid(number = facecard, suit = suits)
facecard <- paste(facecard$number, facecard$suit)
hands <- combinations(52, 2, v=deck) # all possible hands
# probability of a natural 21 given that the ace is listed first in `combinations`
mean(hands[,1] %in% aces & hands[,2] %in% facecard)
# probability of a natural 21 checking for both ace first and ace second
mean((hands[,1] %in% aces & hands[,2] %in% facecard)|(hands[,2] %in% aces & hands[,1] %in% facecard))

# Monte Carlo simulation of natural 21 in blackjack
# your values will differ because the process is random and the seed is not set.
# code for one hand of blackjack
hand <- sample(deck, 2)
hand
# code for B=100,000 hands of blackjack
B <- 100000
results <- replicate(B, {
  hand <- sample(deck, 2)
  (hand[1] %in% aces & hand[2] %in% facecard) | (hand[2] %in% aces & hand[1] %in% facecard)
})
mean(results)

# the duplicated function marks the second duplicated item with TRUE
# checking for duplicated bdays in one 50 person group
n <- 50
bdays <- sample(1:365, n, replace = TRUE)    # generate n random birthdays
any(duplicated(bdays))    # check if any birthdays are duplicated
# Monte Carlo simulation with B=10000 replicates
B <- 10000
results <- replicate(B, {    # returns vector of B logical values
  bdays <- sample(1:365, n, replace = TRUE)
  any(duplicated(bdays))
})
mean(results)    # calculates proportion of groups with duplicated bdays

# Element-wise operation over vectors and sapply
x <- 1:10
sqrt(x)    # sqrt operates on each element of the vector
x <- 1:10
sapply(x, sqrt)    # this is equivalent to sqrt(x)
y <- 1:10
x*y    # * operates element-wise on both vectors

n <- seq(1, 60)

# probability of shared bdays across n people with Monte Carlo simulations
compute_prob <- function(n, B = 10000) {
  same_day <- replicate(B, {
    bdays <- sample(1:365, n, replace = TRUE)
    any(duplicated(bdays))
  })
  mean(same_day)
}
prob <- sapply(n, compute_prob)    # element-wise application of compute_prob to n
plot(n, prob)

# function for computing exact probability of shared birthdays for any n
exact_prob <- function(n){
  prob_unique <- seq(365, 365-n+1)/365   # vector of fractions for mult. rule
  1 - prod(prob_unique)    # calculate prob of no shared birthdays and subtract from 1
}
# some explanation of the above function:
# think about the probability of n persons that do not have duplicated birthday
# the first person has a probability of 365/365, the second has 364/365...
# so the probability is 365/365 * 364/365 *...* (365-n+1)/365 -> ng_prob
# so we can get prob <- 1 - ng_prob

# applying function element-wise to vector of n values
eprob <- sapply(n, exact_prob)
# plotting Monte Carlo results and exact probabilities on same graph
plot(n, prob)    # plot Monte Carlo results
lines(n, eprob, col = "red")    # add line for exact prob

# estimating a practical value of B for Monte Carlo simulations
# when B is large enough that the estimated probability stays stable
B <- 10^seq(1, 5, len = 100)    # defines vector of many B values
compute_prob <- function(B, n = 22){    # function to run Monte Carlo simulation with each B
  same_day <- replicate(B, {
    bdays <- sample(1:365, n, replace = TRUE)
    any(duplicated(bdays))
  })
  mean(same_day)
}
prob <- sapply(B, compute_prob)    # apply compute_prob to many values of B
plot(log10(B), prob, type = "l")    # plot a line graph of estimates 

# another example from exercise
# A team is better than B, which has a 60% of possibility of winning the game
# what is the possibility of team B win at least once in four games?
# we firstly calculate the possibility X that team A win all four games
# then use 1 - X for getting the possibility of team B win at least once
X <- 0.6^4 # team A win all four games
1 - X # the possibility of team B win at least once in the four games

# Create an object called `celtic_wins` that replicates two steps for B iterations: 
# (1) generating a random four-game series `simulated_games` using the example code, then 
# (2) determining whether the simulated series contains at least one win for the Celtics.
celtic_wins <- replicate(10^5, {
  simulated_games <- sample(c("lose","win"), 4, replace = TRUE, prob = c(0.6, 0.4))
  any(simulated_games=="win")
})
# Calculate the frequency out of B iterations that the Celtics won at least one game.
mean(celtic_wins)