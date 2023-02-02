# data component of a graph
# geometry component of a graph
# aesthetic mapping component of a graph
# scale component of a graph

library(tidyverse) # load ggplot from tidyverse library
# library(ggplot2) # or load the ggplot alone

library(dslabs)
data(murders)

# first step is creating a ggplot object
# ggplot(data = murders)
# murders %>% ggplot()

p <- ggplot(data = murders)
class(p)
print(p)    # this is equivalent to simply typing p
p

# add points layer to predefined ggplot object
murders %>% ggplot() +
  geom_point(aes(x = population/10^6, y = total))

# assign ggplot object to a variable makes it easy to add more layers
p <- ggplot(data = murders)
p + geom_point(aes(population/10^6, total))

# add text layer to scatterplot
p + geom_point(aes(population/10^6, total)) +
  geom_text(aes(population/10^6, total, label = abb))
# use label instead of the points for the plot
murders %>% ggplot(aes(population, total, label = abb, color = region)) +
  geom_label() + scale_x_log10() + scale_y_log10()

# no error from this call - this is a correct call
p_test <- p + geom_text(aes(population/10^6, total, label = abb))
# "abb" is not a globally defined variable and cannot be found outside of aes
p_test <- p + geom_text(aes(population/10^6, total), label = abb)

# change the point size and move text labels slightly to the right
p + geom_point(aes(population/10^6, total), size = 3) +
  geom_text(aes(population/10^6, total, label = abb), nudge_x = 1)

# simplify code by adding global aesthetic
p <- murders %>% ggplot(aes(population/10^6, total, label = abb))
p + geom_point(size = 3) + geom_text(nudge_x = 1.5)
# local aesthetics override global aesthetics
p + geom_point(size = 3) +
  geom_text(aes(x = 10, y = 800, label = "Hello there!"))

# now we will try to adjust the scale and add labels, titles, and colors
p <- murders %>% ggplot(aes(population/10^6, total, label = abb))
# change scale to log base with the default function
p + geom_point(size = 3) +
  geom_text(nudge_x = 0.05) +
  scale_x_continuous(trans = "log10") +
  scale_y_continuous(trans = "log10")
# use another more efficient log scaling function for the axes
p <- p + geom_point(size = 3) +
  geom_text(nudge_x = 0.075) +
  scale_x_log10() +
  scale_y_log10() +
  xlab("Population in millions (log scale)") +
  ylab("Total number of murders (log scale)") +
  ggtitle("US Gun Murders in 2010")

# make all points blue
p + geom_point(size = 3, color = "blue")
# or color the points by region
p + geom_point(aes(col = region), size = 3)
# capitalize legend title
p + scale_color_discrete(name = "Region")

# define average murder rate
r <- murders %>%
  summarize(rate = sum(total) / sum(population) * 10^6) %>%
  pull(rate)
# draw dashed and dark grey line for the avg murder rate, under points
p + geom_abline(intercept = log10(r), lty = 2, color = "darkgrey") +
  geom_point(aes(col = region), size = 3)

# apply theme to the plots
ds_theme_set() # the default function


# install.packages("ggrepel") # install the package if not yet
# install.packages("ggtheme") # install the package if not yet
library(ggthemes)
library(ggrepel)
p + theme_economist() # use pre defined theme

# put the code all together:
r <- murders %>%
  summarize(rate = sum(total) / sum(population) * 10^6) %>%
  .$rate

murders %>%
  ggplot(aes(population/10^6, total, label = abb)) +
  geom_abline(intercept = log10(r), lty = 2, color = "darkgrey") +
  geom_point(aes(col = region), size = 3) +
  geom_text_repel() + # ensure labels do not lay on top of each other
  scale_x_log10() +
  scale_y_log10() +
  xlab("Population in millions (log scale)") +
  ylab("Total number of murders (log scale)") +
  ggtitle("US Gun Murders in 2010") +
  scale_color_discrete(name = "Region") +
  theme_economist() # apply the theme from economist


p <- heights %>%
  filter(sex == "Male") %>%
  ggplot(aes(x = height))
# histogram with ggplot
p + geom_histogram(binwidth = 1, fill = "blue", col = "black") +
  xlab("Male heights in inches") +
  ggtitle("Histogram")
# from exercise
p <- heights %>% 
  ggplot(aes(height))
p + geom_histogram(binwidth = 1)
# or
heights %>% 
  ggplot(aes(height)) +
  geom_histogram(binwidth = 1)

# density plot in ggplot
p + geom_density(fill = "blue")
# from exercise
heights %>% 
  ggplot(aes(height, group = sex)) +
  geom_density()
# or even better with grouping by color
heights %>% 
  ggplot(aes(height, color = sex)) +
  geom_density()
# or filling the shape with colors and transparency
heights %>% 
  ggplot(aes(height, fill = sex)) + 
  geom_density(alpha = 0.2) 

# QQ-plot in ggplot from sample data
p <- heights %>% filter(sex == "Male") %>%
  ggplot(aes(sample = height))
p + geom_qq()
# QQ-plot against a normal distribution with same mean/sd as data
params <- heights %>%
  filter(sex == "Male") %>%
  summarize(mean = mean(height), sd = sd(height))
p + geom_qq(dparams = params) +
  geom_abline()
# QQ-plot of scaled data against the standard normal distribution
heights %>%
  ggplot(aes(sample = scale(height))) +
  geom_qq() +
  geom_abline()

# arrange plots next to each other in 1 row, 3 columns
p <- heights %>% filter(sex == "Male") %>% ggplot(aes(x = height))
p1 <- p + geom_histogram(binwidth = 1, fill = "blue", col = "black")
p2 <- p + geom_histogram(binwidth = 2, fill = "blue", col = "black")
p3 <- p + geom_histogram(binwidth = 3, fill = "blue", col = "black")
#install.packages("gridExtra")
library(gridExtra)
grid.arrange(p1, p2, p3, ncol = 3)

# from exercise

data(us_contagious_diseases)
dat <- us_contagious_diseases %>% 
  filter(year == 1967 & disease=="Measles" & count>0 & !is.na(population)) %>%
  mutate(rate = count / population * 10000 * 52 / weeks_reporting)
# modify the x axis text to be vertical
dat %>% mutate(state = reorder(state, rate)) %>%
  ggplot(aes(state, rate)) +
  geom_bar(stat="identity") +
  theme(axis.text.x = element_text(angle = 90, hjust = 1)) # change axis text
# modify the plot layout to be horizontal
dat %>% mutate(state = reorder(state, rate)) %>%
  ggplot(aes(state, rate)) +
  geom_bar(stat="identity") +
  coord_flip() # flip plot layout

data("murders")
# the following plot does not show detail of the data
murders %>% mutate(rate = total/population*100000) %>%
  group_by(region) %>%
  summarize(avg = mean(rate)) %>%
  mutate(region = factor(region)) %>%
  ggplot(aes(region, avg)) +
  geom_bar(stat="identity") +
  ylab("Murder Rate Average")
# use box plot and point plot to reveal the detail
murders %>% mutate(rate = total/population*100000) %>%
  mutate(region = reorder(region, rate, FUN = median)) %>%
  ggplot(aes(region, rate)) + 
  geom_boxplot() + 
  scale_y_continuous(trans = "log2") + 
  geom_jitter(width = 0.1, alpha = 0.3)

# import this lib for using advanced color features
library(RColorBrewer)
# check the available disease in the data set
levels(us_contagious_diseases$disease)
the_disease = "Smallpox"
dat <- us_contagious_diseases %>% 
  filter(!state%in%c("Hawaii","Alaska") & disease == the_disease 
         & weeks_reporting >= 10) %>% 
  mutate(rate = count / population * 10000) %>% 
  mutate(state = reorder(state, rate))

# the first plot
dat %>% ggplot(aes(year, state, fill = rate)) + 
  geom_tile(color = "grey50") + ggtitle(the_disease) + 
  scale_x_continuous(expand=c(0,0)) + 
  scale_fill_gradientn(colors = brewer.pal(9, "Reds"), trans = "sqrt") + 
  theme_minimal() + theme(panel.grid = element_blank()) + 
  ylab("") + xlab("")
# the second plot
avg <- us_contagious_diseases %>%
  filter(disease==the_disease) %>% group_by(year) %>%
  summarize(us_rate = sum(count, na.rm=TRUE)/sum(population, na.rm=TRUE)*10000)

dat %>% ggplot() +
  geom_line(aes(year, rate, group = state),  color = "grey50", 
            show.legend = FALSE, alpha = 0.2, size = 1) +
  geom_line(mapping = aes(year, us_rate),  data = avg, size = 1, color = "black") +
  scale_y_continuous(trans = "sqrt", breaks = c(5,25,125,300)) + 
  ggtitle("Cases per 10,000 by state") + 
  xlab("") + ylab("") +
  geom_text(data = data.frame(x=1955, y=50), 
            mapping = aes(x, y, label="US average"), 
            color="black") + 
  geom_vline(xintercept=1963, col = "blue")

# the third plot
us_contagious_diseases %>% 
  filter(state=="California" & weeks_reporting >= 10) %>% 
  group_by(year, disease) %>%
  summarize(rate = sum(count)/sum(population)*10000) %>%
  ggplot(aes(year, rate, color = disease)) + geom_line() +
  scale_y_continuous(trans = "log2", breaks = c(1, 10, 100))

# the forth plot
us_contagious_diseases %>% 
  filter(!is.na(population)) %>% 
  group_by(year, disease) %>%
  summarize(rate = sum(count)/sum(population)*10000) %>%
  ggplot(aes(year, rate, color = disease)) + geom_line() +
  scale_y_continuous(trans = "log2", breaks = c(1, 10, 100))