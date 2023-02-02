library(dslabs)
data(heights)

# check some samples of the heights data set
head(heights)

# check the proportion of the sex in heights
prop.table(table(heights$sex))

# for non categorical data, a better way to discribe the data is:
# Cumulative Distribution Function (CDF)
my_data <- heights %>% filter(sex == 'Male') %>% .$height
a <- seq(min(my_data), max(my_data), length = 100)    # define range of values spanning the dataset
cdf_function <- function(x) {    # computes prob. for a single value
  mean(my_data <= x)
}
cdf_values <- sapply(a, cdf_function)
plot(a, cdf_values)

# Smooth density plots 
# 平滑密度图可以被认为是箱宽度极小或无限小的直方图。
# 平滑函数在给定可用数据点样本的情况下估计数据的真实连续趋势。
# 平滑度可以通过绘图函数中的参数来控制。
# 虽然直方图是无假设的摘要，但平滑密度图是由数据分析师所做的假设和选择决定的。
# 缩放 y 轴，使密度曲线下的面积总和为 1。这意味着解释 y 轴上的值并不简单。
# 要确定两个值之间的数据比例，请计算平滑密度曲线下这两个值之间区域的面积。
# 平滑密度相对于直方图的一个优点是密度更容易在视觉上进行比较。
# 直方图的的箱宽度选择决定了图形形状，需要通过试验不同箱宽度来深入了解数据。

# define x as vector of male heights
x <- filter(heights, sex=="Male") %>% .$height
head(x)

# calculate the mean and standard deviation manually
average <- sum(x)/length(x)
SD <- sqrt(sum((x - average)^2)/length(x))
c(average = average, SD = SD)
# built-in mean and sd functions
average <- mean(x)
SD <- sd(x)
c(average = average, SD = SD)

# calculate standard units 即一个标准差
z <- scale(x)
# calculate proportion of values within 2 SD of mean
mean(abs(z) < 2) # 0.95
# 正态分布的 Z 值有一个 68-95-99.7 的规则，即：
# 68% 分布在一个 Z 值内，95% 和 99.7% 分别分布在 2 个或 3 个 Z 值内

# estimate the probability that a male is taller than 70.5 inches
x <- heights %>% filter(sex=="Male") %>% pull(height)
1 - pnorm(70.5, mean(x), sd(x))

# plot distribution of exact heights in data
plot(prop.table(table(x)), xlab = "a = Height in inches", ylab = "Pr(x = a)")

# if you have the actual data, you can use the  mean function
# to compute the proportion of entries of a logical vector that are TRUE
# probabilities in ACTUAL data over length 1 ranges containing an integer
mean(x <= 68.5) - mean(x <= 67.5) # covers 68
mean(x <= 69.5) - mean(x <= 68.5) # covers 69
mean(x <= 70.5) - mean(x <= 69.5) # covers 70
# if you only have mean and standard deviation of the data set
# you can use pnorm function to get probabilities in normal APPROXIMATION
pnorm(68.5, mean(x), sd(x)) - pnorm(67.5, mean(x), sd(x))
pnorm(69.5, mean(x), sd(x)) - pnorm(68.5, mean(x), sd(x))
pnorm(70.5, mean(x), sd(x)) - pnorm(69.5, mean(x), sd(x))

# sometimes, probabilities in actual may NOT match normal approximation
mean(x <= 70.9) - mean(x <= 70.1) # NOT covers 70 or 71
pnorm(70.9, mean(x), sd(x)) - pnorm(70.1, mean(x), sd(x))
# another example
exact <- mean(x > 79 & x <= 81)
approx <- pnorm(81, mean(x), sd(x)) - pnorm(79, mean(x), sd(x))
exact / approx # notice the exact value is 1.6 times of the approx