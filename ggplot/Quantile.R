library(dslabs)
data(heights)

# Quartiles divide a dataset into 4 parts each with 25% probability. 
# the 1st quartile (25%), the median, and the 3rd quartile (75%).
summary(heights$height)

# Percentiles are the quantiles obtained when defining p as 0.01, 0.02 ... 0.99. 
# They summarize the values at which a certain percent <= that value.
# The 50th percentile is also known as the median.
# The quartiles are the 25th, 50th and 75th percentiles.
p <- seq(0.01, 0.99, 0.01)
percentiles <- quantile(heights$height, p)
percentiles[names(percentiles) == "25%"]
percentiles[names(percentiles) == "75%"]

# pnorm() gives the probability from a standard normal distribution
# with a specified value be less than or equal to a z-score
pnorm(1) - pnorm(-1) # 0.683
pnorm(2) - pnorm(-2) # 0.954
pnorm(3) - pnorm(-3) # 0.997

# qnorm(p, mu, sigma) with mean mu and standard deviation sigma
# By default, mu=0 and sigma=1 as standard normal distribution.
pnorm(-1.96)
qnorm(0.025) # returns the z-score for a given probability
pnorm(qnorm(0.025)) # qnorm() and pnorm() are inverse functions

# determine the theoretical quantiles of a dataset:
# the theoretical quantiles assuming the dataset follows a normal distribution.
p <- seq(0.01, 0.99, 0.01)
theoretical_quantiles <- qnorm(p, 69, 3)
theoretical_quantiles

index <- heights$sex=="Male"
x <- heights$height[index] # filter the data set with sex of male
z <- scale(x) # calculate the z scale from the filtered data

# get a statistical summary of x
summary(x)
# proportion of data below 69.5
mean(x <= 69.5)

# calculate observed and theoretical quantiles
p <- seq(0.05, 0.95, 0.05)
observed_quantiles <- quantile(x, p)
theoretical_quantiles <- qnorm(p, mean = mean(x), sd = sd(x))

# make quantile-quantiel plot (QQ-plot)
plot(theoretical_quantiles, observed_quantiles)
abline(0,1)

# make QQ-plot with scaled values
observed_quantiles <- quantile(z, p)
theoretical_quantiles <- qnorm(p)
plot(theoretical_quantiles, observed_quantiles)
abline(0,1)

# data not follow a normal distribution cannot be summarized mean and sd
# for them we provide a histogram, smooth density or boxplot instead.
# boxplot uses a five-number summary:
# range (ignoring outliers) and the quartiles (25th, 50th, 75th percentile).
# boxplot uses a box to define the 25th, 50th, and 75th percentiles 
# whiskers show the range while outliers are plotted as individual points.
# the interquartile range is the distance between the 25th and 75th percentiles.
# boxplots are particularly useful when comparing multiple distributions.

# a plot shows unexpected results questions the data quality or implications
index <- heights$sex=="Female"
x <- heights$height[index]
z <- scale(x)
p <- seq(0.05, 0.95, 0.05)

# QQ plot with actual data
observed_quantiles <- quantile(x, p)
theoretical_quantiles <- qnorm(p, mean = mean(x), sd = sd(x))
plot(theoretical_quantiles, observed_quantiles)
abline(0,1)

# QQ plot with Z scale
observed_quantiles <- quantile(z, p)
theoretical_quantiles <- qnorm(p)
plot(theoretical_quantiles, observed_quantiles)
abline(0,1)

# in either plot above, you can see some samples are taller than expected.
# one possible reason is some female students are from the basket ball team
# another is some male students used the female default form value by mistake

# from exercise
library(HistData)
data(Galton)

x <- Galton$child
sd(x) # standard deviation
mad(x) # median absolute deviation (MAD)

# imitate an error of input mistake
x_with_error <- x
x_with_error[1] <- x_with_error[1]*10
# check the impact of this mistake
mean(x_with_error) - mean(x) # 2.46
sd(x_with_error) - sd(x) # 34.4
# check how robust the median summaries are
median(x_with_error) - median(x) # 0
mad(x_with_error) - mad(x) # 0.0233