# understand basic principles of effective data visualization.
# keeping your goal in mind when deciding on a visualization approach.
# position, aligned lengths, angles, area, brightness, and color hue.
# know when to include the number zero in visualizations.
# using common axes, cues adjacent to one another, and color effectively.

# bar plots should always start at 0 as it is deceptive not to do so.
# bar plots imply length is proportional to the quantity displayed. 
# Cutting off the y-axis can make differences look bigger than they actually are.
# When using position rather than length, it is not necessary to include 0 
# (scatterplot, dot plot, boxplot).

# Make sure your visualizations encode the correct quantities.
# For example, circle should use area (not radius) as proportional to the quantity.

# categories should be ordered by a meaningful value. 
# depend on your data and the message you wish to convey with your plot.
# The default ordering for categories is alphabetical which we rarely want.

# jitter adds small random shifts to points and minimize overlapping.
# alpha visualizes the density of overlapping points.
heights %>% ggplot(aes(sex, height)) + 
  geom_jitter(width = 0.1, alpha = 0.2) +
  geom_boxplot(alpha = 0)

# keep axes the same when comparing data across multiple plots.
# align plots vertically for horizontal changes, and horizontally for vertical.
# Bar plots are useful for showing one number but not for showing distributions.
heights %>% ggplot(aes(height)) + 
  geom_histogram(aes(y=..density..), color = "black") +
  facet_grid(sex~.)

# Use transformations when warranted to ease visual interpretation.
# The log transformation is useful for data with multiplicative changes.
# The logistic transformation is useful for fold changes in odds.
# The square root transformation is useful for count data.

gapminder %>% filter(year == 2015) %>%
  ggplot(aes(continent, population/10^6)) + 
  geom_jitter(width = 0.1, alpha = 0.3) + 
  labs(y = "Population in Millions")

gapminder %>% filter(year == 2015) %>%
  mutate(continent = reorder(continent, population, FUN = median)) %>%
  ggplot(aes(continent, population/10^6)) + 
  geom_jitter(width = 0.1, alpha = 0.3) + 
  labs(y = "Population in Millions") + 
  scale_y_continuous(trans = "log10", breaks=c(1,10,100,1000)) +
  geom_boxplot(alpha = 0)

# When two groups are to be compared, place them adjacent in the plot.
# prepare the dollars per day data
gapminder <- gapminder %>%
  mutate(dollars_per_day = gdp/population/365)
# prepare the yers data
past_year <- 1970
present_year <- 2010
# prepare the countries list that have data for both 1970 and 2010
country_list_1 <- gapminder %>%
  filter(year == past_year & !is.na(dollars_per_day)) %>% .$country
country_list_2 <- gapminder %>%
  filter(year == present_year & !is.na(dollars_per_day)) %>% .$country
country_list <- intersect(country_list_1, country_list_2)
# prepare the ggplot object
p <- gapminder %>%
  filter(year %in% c(past_year, present_year) & country %in% country_list) %>%
  mutate(region = reorder(continent, dollars_per_day, FUN = median)) %>%
  ggplot() + 
  # theme(axis.text.x = element_text(angle = 90, hjust = 1)) +
  scale_y_continuous(trans = "log2") + 
  ylab("Income in dollars per day")
# draw the box plot
p + geom_boxplot(aes(region, dollars_per_day, fill = factor(year)))

#  color blind friendly palette
color_blind_friendly_cols <- 
  c("#999999", "#E69F00", "#56B4E9", "#009E73", 
             "#F0E442", "#0072B2", "#D55E00", "#CC79A7")
p1 <- data.frame(x = 1:8, y = 1:8, col = as.character(1:8)) %>%
  ggplot(aes(x, y, color = col)) +
  geom_point(size = 10)
p1 + scale_color_manual(values = color_blind_friendly_cols)

# slope chart for comparing one variable at two different time points, 
# especially for a small number of observations.
west <- c("Western Europe", "Northern Europe", "Southern Europe", 
          "Northern America", "Australia and New Zealand")
dat <- gapminder %>%
  filter(year %in% c(2010, 2015) & region %in% west & 
           !is.na(life_expectancy) & population > 10^7)
dat %>%
  # for the location of the country name labels
  mutate(location = ifelse(year == 2010, 1, 2), # match countries with years
         location = ifelse(year == 2015 & country %in% c("United Kingdom", "Portugal"),
                           location + 0.2, location), # shift two countries 
         hjust = ifelse(year == 2010, 1, 0)) %>% # adjust country names to line
  mutate(year = as.factor(year)) %>%
  ggplot(aes(year, life_expectancy, group = country)) +
  geom_line(aes(color = country), show.legend = FALSE) +
  geom_text(aes(x = location, label = country, hjust = hjust), show.legend = FALSE) +
  xlab("") + ylab("Life Expectancy") 

# Bland-Altman plot (Tukey mean difference plot, MA plot) 
# graphs the diff between the y-axis and the mean on the x-axis.
# appropriate for large numbers of observations than slope charts
library(ggrepel)
dat %>%
  mutate(year = paste0("life_expectancy_", year)) %>%
  # select country, life expectancy, and year from raw data set
  # then spread country and life expectancy data by year on table columns
  select(country, year, life_expectancy) %>% spread(year, life_expectancy) %>%
  mutate(average = (life_expectancy_2015 + life_expectancy_2010)/2,
         difference = life_expectancy_2015 - life_expectancy_2010) %>%
  ggplot(aes(average, difference, label = country)) +
  geom_point() + geom_text_repel() + geom_abline(lty = 2) +
  xlab("Average of 2010 and 2015") + ylab("Difference between 2015 and 2010")

# Tile plot of measles rate by year and state
# import data and inspect
data(us_contagious_diseases)
str(us_contagious_diseases)

# assign dat to the per 10,000 rate of measles, 
# removing Alaska and Hawaii and adjusting for weeks reporting
the_disease <- "Measles"
dat <- us_contagious_diseases %>%
  filter(!state %in% c("Hawaii", "Alaska") & disease == the_disease) %>%
  mutate(rate = count / population * 10000 * 52/weeks_reporting) %>%
  mutate(state = reorder(state, rate))

# plot disease rates per year in California
dat %>% filter(state == "California" & !is.na(rate)) %>%
  ggplot(aes(year, rate)) + geom_line() +
  ylab("Cases per 10,000") + geom_vline(xintercept=1963, col = "blue")

# tile plot of disease rate by state and year
dat %>% ggplot(aes(year, state, fill=rate)) +
  geom_tile(color = "grey50") + scale_x_continuous(expand = c(0,0)) +
  scale_fill_gradientn(colors = RColorBrewer::brewer.pal(9, "Reds"), trans = "sqrt") +
  geom_vline(xintercept = 1963, col = "blue") +
  theme_minimal() + theme(panel.grid = element_blank()) +
  ggtitle(the_disease) + ylab("") + xlab("")

# Line plot of measles rate by year and state
# compute US average measles rate by year
avg <- us_contagious_diseases %>%
  filter(disease == the_disease) %>% group_by(year) %>%
  summarize(us_rate = sum(count, na.rm = TRUE)/sum(population, na.rm = TRUE)*10000)
# make line plot of measles rate by year by state
dat %>%
  filter(!is.na(rate)) %>% ggplot() +
  geom_line(aes(year, rate, group = state), color = "grey50", 
            show.legend = FALSE, alpha = 0.2, size = 1) +
  geom_line(mapping = aes(year, us_rate), data = avg, size = 1, col = "black") +
  scale_y_continuous(trans = "sqrt", breaks = c(5, 25, 125, 300)) +
  ggtitle("Cases per 10,000 by state") + xlab("") + ylab("") +
  geom_text(data = data.frame(x = 1975, y = 25), fontface = "bold", size = 5,
            mapping = aes(x, y, label = "US average"), color = "black") +
  geom_vline(xintercept = 1963, col = "blue") # highlight the vaccine intro

# avoid using 3d plots, and avoid too many significant digits.
# use options(digits = 3) or reduce num of digits using round() or signif()