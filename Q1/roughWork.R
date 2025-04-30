# Rough work - data exploration

library(tidyverse)
library(paletteer)
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

glimpse(gradMS)

gradMS %>%
  filter(Gender == "Other gender")
# there only exists one observations
# we can't make any meaningful analysis off of one point.
# we are hence deciding to omit this data

gradMS <- gradMS %>%
  filter(Gender != "Other gender") # this removes 300 rows

# I think it'd also make sense to pivot this table wider
# Increases readability and will make ggplots easier

gradMS_wider <- gradMS |> # I use a base pipe here because magrittr pipes play weird with '.'
  pivot_wider(names_from = Statistic, values_from = .)

# Some of these names are awkward, so we'll simplify them.
gradMS_wider <- gradMS_wider %>%
  rename(
    p25 = `P25 Earnings of Graduates`,
    p50 = `P50 Earnings of Graduates`,
    p75 = `P75 Earnings of Graduates`
  )

# Looking at 'gradMS_wider', now a lot more of the NA's make sense
# logically, if this data is from 2019, they can only have earnings of observations 1 year from gradudation,
# and two years from graduation for those from 2018, and so on backwards. . .

# If we desired to remove these we could:
# gradMS_wider_lighter <- na.omit(gradMS_wider)

# Now we'll make adjustments to prepare our data specifically for our question.
# We first filter out all genders because we're specifically interested in the differences between male and female.
# We are also only interested in new grads, filter(Years.Since.Graduation == 1) is appropriate for this.
# Now that we've filtered to the data of interest, Years.Since.Graduation becomes redundant.
# Pivoting wider can be helpful for plotting and allows us to append the pay.diff with ease.
gradMS_Q3 <- gradMS_wider %>%
  filter(Gender != "All genders") %>%
  filter(Years.Since.Graduation == 1) %>%
  select(!Years.Since.Graduation) %>%
  pivot_wider(names_from = Gender, values_from = c(p25, p50, p75)) %>%
  mutate(
    Pay.dif.p25 = (p25_Male / p25_Female) - 1,
    Pay.dif.p50 = (p50_Male / p50_Female) - 1,
    Pay.dif.p75 = (p75_Male / p75_Female) - 1
  )

# We shall use the RColorBrewer::Dark2 colour package
paletteer_d("RColorBrewer::Dark2")

# This plot gives an idea of how we would like our final plot to appear.
gradMS_Q3 %>%
  ggplot(aes(x = Graduation.Year, y = Pay.dif.p25, fill = Pay.dif.p25 > 0)) +
  geom_bar(stat = "identity") +
  scale_fill_manual(values = c("#E7298AFF", "#7570B3FF"), 
                    name = "Bias", 
                    labels = c("Female", "Male")) +
  theme_minimal() +
  labs(title = "New grad pay diff @ 25th percentile earnings",
       y = "Pay difference (Male/Female - 1)",
       x = "Graduation Year")

# We're bringing it back to a long format and again only keeping the crucial information.
gradMS_Q3_final <- gradMS_Q3 %>%
  pivot_longer(
    cols = c(Pay.dif.p25, Pay.dif.p50, Pay.dif.p75),
    names_to = "Percentile",
    values_to = "Pay_Ratio"
  ) %>%
  # Create factor with levels in desired order (p75 at top, p25 at bottom)
  mutate(Percentile = factor(Percentile, 
                             levels = c("Pay.dif.p25", "Pay.dif.p50", "Pay.dif.p75"),
                             labels = c("75th Percentile", "50th Percentile", "25th Percentile"))) %>%
  select(Graduation.Year, Percentile, Pay_Ratio)

# Create the faceted plot
gradMS_Q3_final %>%
  ggplot(aes(x = Graduation.Year, y = Pay_Ratio, fill = Pay_Ratio > 0)) +
  geom_bar(stat = "identity") +
  facet_grid(Percentile ~ ., switch = "y") +
  scale_fill_manual(values = c("#E7298AFF", "#7570B3FF"), 
                    name = "Bias", 
                    labels = c("Female", "Male")) +
  theme_minimal() +
  labs(title = "New grad pay diff @ 25th/50th/75th percentile earnings",
       subtitle = "For new maths/stats graduates",
       y = "Percentiles",
       x = "Graduation Year")
