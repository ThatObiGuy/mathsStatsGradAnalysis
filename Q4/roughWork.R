# Rough work - data exploration

library(tidyverse)
load("gradMS.Rdata")

# Data cleaning / pre-processing 
gradMS[,1] # statistic
gradMS[,2] # year
gradMS[,3] # gender
gradMS[,4] # field of study
gradMS[,5] # NFQ Level
gradMS[,6] # years since graduation
gradMS[,7] # measure of statistic

# field of study and NFQ are irrelevant since they're always the same. We can remove them
gradMS <- gradMS[,-c(4,5)]
gradMS[,1] # statistic
gradMS[,2] # year
gradMS[,3] # gender
gradMS[,4] # years since graduation
gradMS[,5] # measure of statistic

gradMS %>%
  filter(Gender == "Other gender")
# there only exists one observations
# we can't make any meaningful analysis off of one point.
# I am hence deciding to omit this data

gradMS <- gradMS %>%
  filter(Gender != "Other gender") # this removes 300 rows

# I think it'd also make sense to pivot this table wider
# Increases readability and will make ggplots easier

gradMS_wider <- gradMS |> # I use a base pipe here because magrittr pipes play weird with '.'
  pivot_wider(names_from = Statistic, values_from = .)

# Looking at 'gradMS_wider', now a lot more of the NA's make sense
# logically, if this data is from 2019, they can only have earnings of observations 1 year from gradudation,
# and two years from graduation for those from 2018, and so on backwards. . .

gradMS_wider_lighter <- na.omit(gradMS_wider)

# very elegant solution to this ^
# I think now we have our data in forms well suited for answering our questions.

# Let's look at all genders, first year
gradMS_wider_lighter %>%
  filter(Gender == "All genders") %>%
  filter(Years.Since.Graduation == 1) %>%
  ggplot(aes(x = Graduation.Year, y = `P25 Earnings of Graduates`)) +
  geom_point()
# there's a clear positive trend

# what about across all 3 levels of pay?
gradMS %>%
  filter(Gender == "All genders") %>%
  filter(Years.Since.Graduation == 1) |>
  ggplot(aes(x = Graduation.Year, y = ., colour = Statistic)) +
  geom_point()
# pretty damn consistent

# what about across genders?
gradMS %>%
  filter(Gender %in% c("Male", "Female")) %>%
  filter(Years.Since.Graduation == 1) |>
  ggplot(aes(x = Graduation.Year, y = ., colour = Statistic)) +
  facet_wrap(~Gender) +
  geom_point() +
  geom_line()
# male appear to be making more than female
