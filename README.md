# A Data Science Course from Edx
https://www.edx.org/professional-certificate/harvardx-data-science

## R
安装资源包，导入资源包，导入（资源包中的）数据：
```
> install.packages("dslabs")
> library(dslabs)
> data(movielens)
```

苹果电脑上有用的快捷操作：
* 保存脚本 Command + S
* 运行整个脚本:  Command + Shift + Enter
* 运行一行脚本: Command + Return
* 新建脚本: Command + Shift + N

一个用于练习导入资源包和脚本操作的练习：
```
library(tidyverse)
library(dslabs)
data(murders)

murders %>%
    ggplot(aes(population, total, label=abb, color=region)) +
    geom_label()
```
## Data Visualization
* understand the importance of data visualization for communicating data-driven findings.
* be able to use distributions to summarize data.
* be able to use the average and the standard deviation to understand the normal distribution.
* be able to assess how well a normal distribution fits the data using a quantile-quantile plot.
* be able to interpret data from a boxplot.

* Plots of data easily communicate information that is difficult to extract from tables of raw values.
* Data visualization is a key component of exploratory data analysis (EDA)
* EDA expores the properties of data through visualization and summarization techniques.
* Discover biases, systematic errors, and mistakes before data are incorporated into flawed analysis.
