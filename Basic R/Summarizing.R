library(tidyverse)
library(dplyr)
library(dslabs)
data(murders)
murders <- mutate(murders, rate = total / population * 10^5)

# minimum, median, and maximum murder rate for the states in the West region
s <- murders %>% 
  filter(region == "West") %>%
  summarize(minimum = min(rate), 
            median = median(rate), 
            maximum = max(rate))
s
class(s) # you can see it is a data frame

# accessing the components with the accessor $
s$median
s$maximum

# average rate unadjusted by population size
mean(murders$rate)

# average rate adjusted by population size
us_murder_rate <- murders %>% 
  summarize(rate = sum(total) / sum(population) * 10^5)
us_murder_rate

class(us_murder_rate) # you can see it is a data frame
us_murder_rate$rate # so you can get its value from $ sign
pull(us_murder_rate) # or with the pull function from dplyr package

# use . as the placeholder for the data being piped
us_murder_rate <- murders %>% 
  summarize(rate = sum(total) / sum(population) * 10^5) %>%
  .$rate # this return the same data as the $ sign or pull function
# notice, PrestoDB use the same syntax int its SQL

# minimum, median, and maximum murder rate in the West region using quantile
# note that this returns a vector
murders %>% 
  filter(region == "West") %>%
  summarize(range = quantile(rate, c(0, 0.5, 1)))

# returning minimum, median, and maximum as a data frame
my_quantile <- function(x){
  r <-  quantile(x, c(0, 0.5, 1))
  data.frame(minimum = r[1], median = r[2], maximum = r[3]) 
}
murders %>% 
  filter(region == "West") %>%
  summarize(my_quantile(rate))

# group by region creates a special data frame by groups
murders %>% group_by(region)
# summarize after grouping: group_by + summarize
murders %>% 
  group_by(region) %>%
  summarize(minimum = min(rate), 
            median = median(rate), 
            maximum = max(rate))

# use the arrange function from the dplyr package for sorting
# order the states by population size
murders %>% arrange(population) %>% head() # head returns the top five rows
# order the states by murder rate in descending order
murders %>% arrange(desc(rate)) %>% head()
# order the states by region and then by murder rate within region
murders %>% arrange(region, desc(rate)) %>% head()
# return the top 10 states by murder rate
murders %>% top_n(10, rate)
# return the top 10 states ranked by murder rate, sorted by murder rate
murders %>% arrange(desc(rate)) %>% top_n(10)

# use na.rm=TRUE to remove NA values
data("na_example")
mean(na_example) # NA
sd(na_example) # NA
mean(na_example, na.rm=TRUE) # valid value now
sd(na_example, na.rm=TRUE) # valid value now

library(dplyr)
library(NHANES)
data(NHANES)
# take a look at the sample of the data set HNANES
head(HNANES)
NHANES %>%
  filter(AgeDecade == " 20-29" & Gender == "female")

NHANES %>% 
  filter(AgeDecade == " 20-29" & Gender == "female") %>%
  summarise(average=mean(BPSysAve,na.rm=TRUE), 
            standard_deviation=sd(BPSysAve,na.rm=TRUE)) %>%
  .$average

NHANES %>%
  filter(AgeDecade == " 20-29"  & Gender == "female") %>%
  summarise(minbp = min(BPSysAve, na.rm = TRUE), 
            maxbp = max(BPSysAve, na.rm = TRUE))

NHANES %>%
  filter(Gender == "female") %>%
  group_by(AgeDecade) %>%
  summarise(average = mean(BPSysAve, na.rm = TRUE),
            standard_deviation = sd(BPSysAve, na.rm = TRUE))

NHANES %>%
  filter(Gender == "male") %>%
  group_by(AgeDecade) %>%
  summarise(average = mean(BPSysAve, na.rm = TRUE),
            standard_deviation = sd(BPSysAve, na.rm = TRUE))

NHANES %>%
  group_by(AgeDecade, Gender) %>%
  summarise(average = mean(BPSysAve, na.rm = TRUE),
            standard_deviation = sd(BPSysAve, na.rm = TRUE))

NHANES %>%
  filter(Gender == "male" & AgeDecade == " 40-49") %>%
  group_by(Race1) %>%
  summarise(average = mean(BPSysAve, na.rm = TRUE),
            standard_deviation = sd(BPSysAve, na.rm = TRUE)) %>%
  arrange(average) 