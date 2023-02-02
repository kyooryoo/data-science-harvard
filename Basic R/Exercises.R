library(dslabs)
data(heights)

# filter out the heights of male and female
male <- heights$height[heights$sex=="Male"]
female <- heights$height[heights$sex=="Female"]

# get the quantile (.1,.3,.5,.7,.9) of male and female hights
male_percentiles <- quantile(male, seq(.1, .9, .2))
female_percentiles <- quantile(female, seq(.1, .9, .2))

# create a data frame with the male and female quantiles
df <- data.frame(female = female_percentiles, male = male_percentiles)
df