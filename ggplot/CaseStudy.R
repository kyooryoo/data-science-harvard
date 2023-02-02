# dispel myths, educate public, contradict sensationalist/outdated claims
# let's try using data to answer the questions about world health and economics:
# Is the world still divided into the westen rich and the developing countries?
# Has income inequality across countries worsened over the last 40 years?

# load and inspect gapminder data
library(dslabs)
data(gapminder)
head(gapminder)

# compare infant mortality in Sri Lanka and Turkey
gapminder %>%
  filter(year == 2015 & country %in% c("Sri Lanka", "Turkey")) %>%
  select(country, infant_mortality)

# scatterplot of life expectancy versus fertility with color
filter(gapminder, year == 1962) %>%
  ggplot(aes(fertility, life_expectancy, color = continent)) +
  geom_point()

# Making multiple side-by-side plots is a way to ease comparisons.
# Faceting keeps the axes fixed across all plots, easing comparisons.

# The facet_grid() function allows faceting by up to two variables
# with rows faceted by one variable and columns faceted by the other variable.
# facet by continent and year
filter(gapminder, year %in% c(1962, 2012)) %>%
  ggplot(aes(fertility, life_expectancy, col = continent)) +
  geom_point() +
  facet_grid(continent ~ year)
# To facet by only one variable, use the dot operator as the other variable.
filter(gapminder, year %in% c(1962, 2012)) %>%
  ggplot(aes(fertility, life_expectancy, col = continent)) +
  geom_point() +
  facet_grid(. ~ year)

# The facet_wrap() function facets by one variable.
# It automatically wraps the series of plots so they have readable dimensions.
# facet by year, plots wrapped onto multiple rows
years <- c(1962, 1980, 1990, 2000, 2012)
continents <- c("Europe", "Asia")
gapminder %>%
  filter(year %in% years & continent %in% continents) %>%
  ggplot(aes(fertility, life_expectancy, col = continent)) +
  geom_point() +
  facet_wrap(~year)

# single time series plot
# scatterplot of US fertility by year - by points
gapminder %>%
  filter(country == "United States") %>%
  ggplot(aes(year, fertility)) +
  geom_point()
# line plot of US fertility by year - by line - better
gapminder %>%
  filter(country == "United States") %>%
  ggplot(aes(year, fertility)) +
  geom_line()

# multiple time plots
# line plot fertility time series for two countries- only one line (incorrect)
countries <- c("South Korea", "Germany")
gapminder %>% filter(country %in% countries) %>%
  ggplot(aes(year, fertility)) +
  geom_line()
# line plot fertility time series for two countries - one line per country
gapminder %>% filter(country %in% countries) %>%
  ggplot(aes(year, fertility, group = country)) +
  geom_line()
# fertility time series for two countries - lines colored by country
gapminder %>% filter(country %in% countries) %>%
  ggplot(aes(year, fertility, col = country)) +
  geom_line()

# adding text labels to plots
# life expectancy time series - lines colored by country and labeled, no legend
labels <- data.frame(country = countries, x = c(1975, 1965), y = c(60, 72))
gapminder %>% filter(country %in% countries) %>%
  ggplot(aes(year, life_expectancy, col = country)) +
  geom_line() +
  geom_text(data = labels, aes(x, y, label = country), size = 5) +
  theme(legend.position = "none")

# add dollars per day variable
gapminder <- gapminder %>%
  mutate(dollars_per_day = gdp/population/365)
# histogram of dollars per day
past_year <- 1970
gapminder %>%
  filter(year == past_year & !is.na(gdp)) %>%
  ggplot(aes(dollars_per_day)) +
  geom_histogram(binwidth = 1, color = "black")
# repeat histogram with log2 scaled data
# notice the x-axis is not as easy to interpret as in the next plot
gapminder %>%
  filter(year == past_year & !is.na(gdp)) %>%
  ggplot(aes(log2(dollars_per_day))) + # log2 applies to the raw data
  geom_histogram(binwidth = 1, color = "black")
# repeat histogram with log2 scaled x-axis
# x-axis has more meaningful data for easy understanding
gapminder %>%
  filter(year == past_year & !is.na(gdp)) %>%
  ggplot(aes(dollars_per_day)) +
  geom_histogram(binwidth = 1, color = "black") +
  scale_x_continuous(trans = "log2") # log2 applies to the visualization scale

# by default, factor order is alphabetical
fac <- factor(c("Asia", "Asia", "West", "West", "West"))
levels(fac) # "Asia" "West"
# reorder factor by the category means
value <- c(10, 11, 12, 6, 4)
fac <- reorder(fac, value, FUN = mean)
levels(fac) # "West" "Asia"

# Enhanced boxplot ordered by median income, scaled, and showing data
# reorder by median income and color by continent
p <- gapminder %>%
  filter(year == past_year & !is.na(gdp)) %>%
  # uncomment the following line to order regions by median of dollars per day
  mutate(region = reorder(region, dollars_per_day, FUN = median)) %>% # reorder
  ggplot(aes(region, dollars_per_day, fill = continent)) + # color by continent
  geom_boxplot() +
  theme(axis.text.x = element_text(angle = 90, hjust = 1))
  xlab("")
p

# log2 scale y-axis, now you can see the data on left better
p + scale_y_continuous(trans = "log2")
# add data points (the points are not too many in this case)
p + scale_y_continuous(trans = "log2") + geom_point(show.legend = FALSE)

# add dollars per day variable and define past year
gapminder <- gapminder %>%
  mutate(dollars_per_day = gdp/population/365)
past_year <- 1970

# define Western countries
west <- c("Western Europe", "Northern Europe", "Southern Europe", "Northern America", "Australia and New Zealand")

# facet by West vs devloping
gapminder %>%
  filter(year == past_year & !is.na(gdp)) %>%
  mutate(group = ifelse(region %in% west, "West", "Developing")) %>%
  ggplot(aes(dollars_per_day)) +
  geom_histogram(binwidth = 1, color = "black") +
  scale_x_continuous(trans = "log2") +
  facet_grid(. ~ group)

# facet by West/developing and year
present_year <- 2010
gapminder %>%
  filter(year %in% c(past_year, present_year) & !is.na(gdp)) %>%
  mutate(group = ifelse(region %in% west, "West", "Developing")) %>%
  ggplot(aes(dollars_per_day)) +
  geom_histogram(binwidth = 1, color = "black") +
  scale_x_continuous(trans = "log2") +
  facet_grid(year ~ group)

# define countries that ONLY have data available in both years
country_list_1 <- gapminder %>%
  filter(year == past_year & !is.na(dollars_per_day)) %>% .$country
country_list_2 <- gapminder %>%
  filter(year == present_year & !is.na(dollars_per_day)) %>% .$country
country_list <- intersect(country_list_1, country_list_2)

# make histogram including only countries with data available in both years
gapminder %>%
  filter(year %in% c(past_year, present_year) & country %in% country_list) %>%
  mutate(group = ifelse(region %in% west, "West", "Developing")) %>%
  ggplot(aes(dollars_per_day)) + geom_histogram(binwidth = 1, color = "black") +
  scale_x_continuous(trans = "log2") + facet_grid(year ~ group)

# Boxplots of income in West versus developing world, 1970 and 2010
p <- gapminder %>%
  filter(year %in% c(past_year, present_year) & country %in% country_list) %>%
  mutate(region = reorder(region, dollars_per_day, FUN = median)) %>%
  ggplot() + theme(axis.text.x = element_text(angle = 90, hjust = 1)) +
  xlab("") + scale_y_continuous(trans = "log2")
# two boxplots side by side - not so easy to compare
p + geom_boxplot(aes(region, dollars_per_day, fill = continent)) +
  facet_grid(year ~ .)
# arrange matching boxplots next to each other, colored by year - better
p + geom_boxplot(aes(region, dollars_per_day, fill = factor(year)))

# smooth density plots - area under each curve adds to 1
gapminder %>%
  filter(year == past_year & country %in% country_list) %>%
  mutate(group = ifelse(region %in% west, "West", "Developing")) %>% group_by(group) %>%
  summarize(n = n()) %>% knitr::kable()
# smooth density plots WITHOUT comparing - variable counts on y-axis
p <- gapminder %>%
  filter(year %in% c(past_year, present_year) & country %in% country_list) %>%
  # using the computed variable COUNT for y axis values instead of density
  ggplot(aes(dollars_per_day, y = ..count..)) +
  scale_x_continuous(trans = "log2")
p + geom_density() + facet_grid(year ~ .)
# smooth density plots WITH comparing - variable counts on y-axis
p <- gapminder %>%
  filter(year %in% c(past_year, present_year) & country %in% country_list) %>%
  mutate(group = ifelse(region %in% west, "West", "Developing")) %>%
  # without y=..count.. we cannot tell there are more developing countries
  ggplot(aes(dollars_per_day, y = ..count.., fill = group)) +
  scale_x_continuous(trans = "log2")
# you can control the smoothness of the plot with the bw parameter
p + geom_density(alpha = 0.2, bw = 0.75) + facet_grid(year ~ .)

# Create stacked density plot
# add group as a factor, grouping regions with case_when
gapminder <- gapminder %>%
  mutate(group = case_when(
    .$region %in% west ~ "West",
    .$region %in% c("Eastern Asia", "South-Eastern Asia") ~ "East Asia",
    .$region %in% c("Caribbean", "Central America", "South America") ~ "Latin America",
    .$continent == "Africa" & .$region != "Northern Africa" ~ "Sub-Saharan Africa",
    TRUE ~ "Others"))
# reorder factor levels
gapminder <- gapminder %>%
  mutate(group = factor(group, levels = c("Others", "Latin America", "East Asia", "Sub-Saharan Africa", "West")))
# note you must redefine p with the new gapminder object first
p <- gapminder %>%
  filter(year %in% c(past_year, present_year) & country %in% country_list) %>%
  ggplot(aes(dollars_per_day, fill = group)) +
  scale_x_continuous(trans = "log2")
# removing the stack position parameter reduces readability of the plot
p + geom_density(alpha = 0.2, bw = 0.75, position = "stack") +
  facet_grid(year ~ .)

# weighted stacked density plot by the populations
gapminder %>%
  filter(year %in% c(past_year, present_year) & country %in% country_list) %>%
  group_by(year) %>%
  mutate(weight = population/sum(population*2)) %>%
  ungroup() %>%
  ggplot(aes(dollars_per_day, fill = group, weight = weight)) +
  scale_x_continuous(trans = "log2") +
  geom_density(alpha = 0.2, bw = 0.75, position = "stack") + 
  facet_grid(year ~ .)

# add additional cases
gapminder <- gapminder %>%
  mutate(group = case_when(
    .$region %in% west ~ "The West",
    .$region %in% "Northern Africa" ~ "Northern Africa",
    .$region %in% c("Eastern Asia", "South-Eastern Asia") ~ "East Asia",
    .$region == "Southern Asia" ~ "Southern Asia",
    .$region %in% c("Central America", "South America", "Caribbean") ~ "Latin America",
    .$continent == "Africa" & .$region != "Northern Africa" ~ "Sub-Saharan Africa",
    .$region %in% c("Melanesia", "Micronesia", "Polynesia") ~ "Pacific Islands"))
# define a data frame with group average income and average infant survival rate
surv_income <- gapminder %>%
  filter(year %in% present_year & !is.na(gdp) & !is.na(infant_mortality) & !is.na(group)) %>%
  group_by(group) %>%
  summarize(income = sum(gdp)/sum(population)/365,
            infant_survival_rate = 1 - sum(infant_mortality/1000*population)/sum(population))
surv_income %>% arrange(income)
# plot infant survival versus income, with transformed axes
surv_income %>% ggplot(aes(income, infant_survival_rate, label = group, color = group)) +
  scale_x_continuous(trans = "log2", limit = c(0.25, 150)) +
  scale_y_continuous(trans = "logit", limit = c(0.875, .9981),
                     breaks = c(.85, .90, .95, .99, .995, .998)) +
  geom_label(size = 3, show.legend = FALSE) 

# from exercise
# a scatter plot of life expectancy versus fertility for African in 2012.
gapminder %>% filter( continent == "Africa" & year == 2012) %>%
  ggplot(aes(fertility, life_expectancy, color = region)) +
  geom_point()

df <- gapminder %>%
  filter(year == 2012 & continent == "Africa" & fertility <= 3 & life_expectancy >= 70) %>%
  select(country, region)

tab <- gapminder %>% 
  filter(year >= 1960 & year <= 2010 & country %in% c("Vietnam", "United States"))
p <- tab %>% ggplot(aes(year, life_expectancy, color = country)) + geom_line()
p

gapminder %>% 
  filter(year >= 1960 & year <= 2010 & country == "Cambodia") %>%
  ggplot(aes(year, life_expectancy)) + geom_line()

daydollars <- gapminder %>% 
  filter(continent == "Africa" & year %in% c(1970, 2010) & !is.na(gdp)) %>%
  mutate(dollars_per_day = gdp/population/365)
daydollars %>%
  ggplot(aes(dollars_per_day, fill = region)) + 
  scale_x_continuous(trans = "log2") + 
  geom_density(bw = 0.5, position = "stack") + 
  facet_grid(.~year)

gapminder_Africa_2010 <- gapminder %>%
  filter(year == 2010 & continent == "Africa" & !is.na(gdp)) %>%
  mutate(dollars_per_day = gdp/population/365)
gapminder_Africa_2010 %>% 
  ggplot(aes(dollars_per_day, infant_mortality, color = region)) +
  scale_x_continuous(trans = "log2") +
  geom_point()
gapminder_Africa_2010 %>% 
  ggplot(aes(dollars_per_day, infant_mortality, color = region, label = country)) +
  geom_text() + 
  scale_x_continuous(trans = "log2")

gapminder %>%
  filter(year %in% c(1970, 2010) & continent == "Africa" & !is.na(gdp) 
         & !is.na(infant_mortality)) %>%
  mutate(dollars_per_day = gdp/population/365) %>% 
  ggplot(aes(dollars_per_day, infant_mortality, 
             color = region, label = country)) +
  scale_x_continuous(trans = "log2") +
  geom_text() +
  facet_grid(year~.)

