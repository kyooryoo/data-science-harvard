options(digits = 3)    # report 3 significant digits
library(tidyverse)
# install.packages("titanic")
library(titanic)

titanic <- titanic_train %>%
  select(Survived, Pclass, Sex, Age, SibSp, Parch, Fare) %>%
  mutate(Survived = factor(Survived),
         Pclass = factor(Pclass),
         Sex = factor(Sex))

?titanic_train
str(titanic_train)

# from the following density plot, you can conclude:
# females and males had the same general shape of age distribution.
# age distribution is bi-modal, around 25 and around 5 respectively
# for the proportion of age 18-35, male was higher than female.
# for the proportion of under age 17, female was higher than male.
# the oldest passengers were male.
titanic %>% filter(!is.na(Age)) %>%
  ggplot(aes(Age, fill = Sex)) + 
  geom_density(alpha = 0.2)

# from the following density plot with count on y axis, you can see:
# there were less females than males.
# the count of males of age 40 was higher than the count of females of age 40
titanic %>% filter(!is.na(Age)) %>%
  ggplot(aes(Age, fill = Sex, y = ..count..)) + 
  geom_density(alpha = 0.2)

# make a qq plot
params <- titanic %>%
  filter(!is.na(Age)) %>%
  summarize(mean = mean(Age), sd = sd(Age))
titanic %>% filter(!is.na(Age)) %>%
  ggplot(aes(sample = Age)) + 
  geom_qq(dparams = params) + 
  geom_abline()

# bar plot the survived
titanic %>% 
  ggplot(aes(Survived)) + 
  geom_bar()
titanic %>% 
  ggplot(aes(Sex, fill = Survived)) + 
  geom_bar(position = position_dodge())

# density plot of age filled by survival status, you can see:
# 0-8 group is more likely to survive than die
# 18-30 group has the most deaths
# 70-80 group has the highest proportion of deaths
titanic %>% filter(!is.na(Age)) %>%
  ggplot(aes(Age, fill = Survived, y = ..count..)) + 
  geom_density(alpha = 0.2)

# you can get the following information from the following plot:
# survived generally payed higher fares than those who did not survive.
# the interquartile range for fares was larger for passengers who survived.
# the median fare was lower for passengers who did not survive.
# most individuals who paid a fare around $8 did not survive.
titanic %>% filter(!is.na(Fare)) %>% 
  ggplot(aes(Fare, Survived)) +
  geom_boxplot() +
  geom_jitter(width = 0.2, alpha = 0.2) + 
  scale_x_continuous(trans = "log2")

# survival of passenger numbers per class
titanic %>% ggplot(aes(Pclass, fill = Survived)) + geom_bar()
# survival of passenger proportions per class
titanic %>% ggplot(aes(Pclass, fill = Survived)) + 
  geom_bar(position = position_fill())
# survival proportions per passenger class
titanic %>% ggplot(aes(Survived, fill = Pclass)) + 
  geom_bar(position = position_fill())

titanic %>% filter(!is.na(Age)) %>% 
  ggplot(aes(Age, fill = Survived, y = ..count..)) +
  geom_density(alpha = 0.2, position = "stack") + 
  facet_grid(Sex~Pclass)