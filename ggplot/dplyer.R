library(dslabs)
data(na_example)

# without removing the NAs, mean and standard deviation are NA
mean(na_example) # [1] NA
sd(na_example) # [1] NA

# after removing NAs, mean and standard deviation return meaningful values
mean(na_example, na.rm = TRUE) # [1] 2.301754
sd(na_example, na.rm = TRUE) # [1] 1.22338

library(dplyr)
library(NHANES)
data(NHANES)

# check the AgeDecade and Gender values
levels(NHANES$AgeDecade) # [1] " 0-9"   " 10-19" " 20-29" ...
levels(NHANES$Gender) # [1] "female" "male"  

# filter the data
tab <- NHANES %>%
  filter(AgeDecade == " 20-29" & Gender == "female")

# notice, the NAs should be removed in the mean and sd functions
ref <- NHANES %>% 
  filter(AgeDecade == " 20-29" & Gender == "female") %>%
  summarise(average = mean(BPSysAve, na.rm = TRUE), 
            standard_deviation = sd(BPSysAve, na.rm = TRUE)) %>%
  pull(average)

NHANES %>%
  filter(AgeDecade == " 20-29"  & Gender == "female") %>%
  summarise(minbp = min(BPSysAve, na.rm = TRUE), 
            maxbp = max(BPSysAve, na.rm = TRUE))

# group_by 
NHANES %>%
  filter(Gender == "female", !is.na(AgeDecade)) %>% 
  group_by(AgeDecade) %>%
  summarise(average = mean(BPSysAve, na.rm = TRUE), 
            standard_deviation = sd(BPSysAve, na.rm = TRUE))

# group_by + summarise
NHANES %>% 
  filter(Gender == "male", !is.na(AgeDecade)) %>%
  group_by(AgeDecade) %>%
  summarise(average = mean(BPSysAve, na.rm = TRUE),
            standard_deviation = sd(BPSysAve, na.rm = TRUE))

# group_by with two fields
NHANES %>% group_by(AgeDecade, Gender) %>%
  summarise(average = mean(BPSysAve, na.rm = TRUE),
            standard_deviation = sd(BPSysAve, na.rm = TRUE))

# arrange(x) or arrange(desc(x))
NHANES %>%
  filter(Gender == "male" & AgeDecade == " 40-49") %>%
  group_by(Race1) %>%
  summarise(average = mean(BPSysAve, na.rm = TRUE),
            standard_deviation = sd(BPSysAve, na.rm = TRUE)) %>%
  arrange(average)