library(dplyr)
library(stringr)
library(ggplot2)

# Loading the dataframes
df_1 <- read.csv("Mapping Police Violence.csv")
df_2 <- read.csv("2013-Data.csv")
df_3 <- read.csv("2018-Data.csv")

violence <- df_1
df_train_2013 <- df_2
df_train_2018 <- df_3
# These manipulations allow to clean up the 2018 training dataset, as it includes many rows full of NAs or otherwise missing/nonsensical values that make rows useless
df_train_2018 <- df_train_2018[!is.na(df_train_2018$BASIC_LGTH) & !is.na(df_train_2018$BASIC_TYPE) & !df_train_2018$BASIC_LGTH < 0 & !(df_train_2018$BASIC_TYPE == 5), ]

#Split the police violence dataset into two periods of equal length - 2013-2017, 2018-2022
incidents_df_2013 <- violence[str_detect(violence$date, "2013|2014|2015|2016|2017"), ]
incidents_df_2018 <- violence[str_detect(violence$date, "2018|2019|2020|2021|2022"), ]

### 2013 Data Wrangling ####

#Cleaning up missing or nonsensical values in the column corresponding to question 31
df_train_2013$Q31IHOURS[is.na(df_train_2013$Q31IHOURS)] <- 0
df_train_2013$Q31JHOURS[is.na(df_train_2013$Q31JHOURS)] <- 0
df_train_2013$Q31NHOURS[is.na(df_train_2013$Q31NHOURS)] <- 0
df_train_2013$Q31PHOURS[is.na(df_train_2013$Q31PHOURS)] <- 0
df_train_2013$Q31WHOURS[is.na(df_train_2013$Q31WHOURS)] <- 0
df_train_2013$Q31LLHOURS[is.na(df_train_2013$Q31LLHOURS)] <- 0
df_train_2013$Q39[is.na(df_train_2013$Q39)] <- 0
df_train_2013$Q13FULL[df_train_2013$Q13FULL == 88] <- 0
df_train_2013$Q31NHOURS[df_train_2013$Q31NHOURS == 888] <- 0
df_train_2013$Q31PHOURS[df_train_2013$Q31PHOURS == 888] <- 0

# Groupings that will help aggregate both the police incidents and training datasets by state,
# Relevant columns will be added one by one to the agg_df dataframe, produced by making full joins
# with intermediate dataframes
grouped_p_2013 <- group_by(incidents_df_2013, state)
grouped_t_2013 <- group_by(df_train_2013, STATECODE)

incidents_state_2013 <- summarise(grouped_p_2013, incidents_2013 = length(state))

# Use a histogram of the number of hours dedicated by academy to find the appropriate average to use (mean or median)
ggplot(data = grouped_t_2013, aes(x = Q9REVISED)) +
  geom_histogram(color = "darkseagreen4", fill = "darkseagreen3")
training_state_2013 <- summarise(grouped_t_2013, median_training_2013 = median(Q9REVISED))
agg_df <- merge(x = incidents_state_2013, y = training_state_2013, by.x = "state", by.y = "STATECODE", all = TRUE)

# Use a histogram of the number of hours dedicated by academy to firearm training to find the appropriate average to use (mean or median)
ggplot(data = grouped_t_2013, aes(x = Q31IHOURS)) +
  geom_histogram(color = "darkseagreen4", fill = "darkseagreen3")
firearm_state_2013 <- summarise(grouped_t_2013, mean_firearm_2013 = mean(Q31IHOURS))
agg_df <- merge(x = agg_df, y = firearm_state_2013, by.x = "state", by.y = "STATECODE", all = TRUE)

# Use a histogram of the number of hours dedicated by academy to nonlethal weapon training to find the appropriate average to use (mean or median)
ggplot(data = grouped_t_2013, aes(x = Q31JHOURS)) +
  geom_histogram(color = "darkseagreen4", fill = "darkseagreen3")
nonlethal_df_2013 <- summarise(grouped_t_2013, median_nonlethal_2013 = median(Q31JHOURS))
agg_df <- merge(x = agg_df, y = nonlethal_df_2013, by.x = "state", by.y = "STATECODE", all = TRUE)

# Mean measure of how stress-oriented the academy is (multiplied by 5/7 for consistent scaling with the 2018 dataframe) 
stress_df_2013 <- summarise(grouped_t_2013, mean_stress_2013 = mean(na.omit(5/7 * Q30)))
agg_df <- merge(x = agg_df, y = stress_df_2013, by.x = "state", by.y = "STATECODE", all = TRUE)

# Use a histogram  for the minimum training experience required to be an instructor to find the appropriate average to use (mean or median)
ggplot(data = grouped_t_2013, aes(x = Q13FULL)) +
  geom_histogram(color = "darkseagreen4", fill = "darkseagreen3")
ins_exp_df_2013 <- summarise(grouped_t_2013, median_min_ins_exp_2013 = median(Q13FULL))
agg_df <- merge(x = agg_df, y = ins_exp_df_2013, by.x = "state", by.y = "STATECODE", all = TRUE)

# Use a histogram of the number of hours dedicated by academy to community participation training to find the appropriate average to use (mean or median)
ggplot(data = grouped_t_2013, aes(x = Q31NHOURS)) +
  geom_histogram(color = "darkseagreen4", fill = "darkseagreen3")
community_df_2013 <- summarise(grouped_t_2013, median_community_2013 = median(Q31NHOURS))
agg_df <- merge(x = agg_df, y = community_df_2013, by.x = "state", by.y = "STATECODE", all = TRUE)

# Use a histogram of the number of hours dedicated by academy to mediation training to find the appropriate average to use (mean or median)
ggplot(data = grouped_t_2013, aes(x = Q31PHOURS)) +
  geom_histogram(color = "darkseagreen4", fill = "darkseagreen3")
mediation_df_2013 <- summarise(grouped_t_2013, median_mediation_2013 = median(Q31PHOURS))
agg_df <- merge(x = agg_df, y = mediation_df_2013, by.x = "state", by.y = "STATECODE", all = TRUE)

# Use a histogram of the number of hours dedicated by academy to stress management training to find the appropriate average to use (mean or median)
ggplot(data = grouped_t_2013, aes(x = Q31WHOURS)) +
  geom_histogram(color = "darkseagreen4", fill = "darkseagreen3")
stress_man_df_2013 <- summarise(grouped_t_2013, median_stress_man_2013 = median(Q31WHOURS))
agg_df <- merge(x = agg_df, y = stress_man_df_2013, by.x = "state", by.y = "STATECODE", all = TRUE)

# A measure of preparedness for responding to excessive use of force by another officer
force_id_df_2013 <- summarise(grouped_t_2013, mean_force_id_2013 = mean(Q39))
agg_df <- merge(x = agg_df, y = force_id_df_2013, by.x = "state", by.y = "STATECODE", all = TRUE)

### ####

### 2018 Data Wrangling ####

#Keep expanding agg_df
grouped_p_2018 <- group_by(incidents_df_2018, state)
incidents_state_2018 <- summarise(grouped_p_2018, incidents_2018 = length(state))
agg_df <- merge(x = agg_df, y = incidents_state_2018, by = "state", all = TRUE)


#Cleaning up missing or nonsensical values in the column corresponding to question 31
df_train_2018$FIRE_SKILL[is.na(df_train_2018$FIRE_SKILL)] <- 0
df_train_2018$NONL[is.na(df_train_2018$NONL)] <- 0
df_train_2018$MIN_EXP[is.na(df_train_2018$MIN_EXP)] <- 0
df_train_2018$COM_PART[is.na(df_train_2018$COM_PART)] <- 0
df_train_2018$COM_PART[df_train_2018$COM_PART == -8] <- 0
df_train_2018$MEDI[is.na(df_train_2018$MEDI)] <- 0
df_train_2018$MEDI[df_train_2018$MEDI == -8] <- 0
df_train_2018$STRESS[is.na(df_train_2018$STRESS)] <- 0
df_train_2018$STRESS[df_train_2018$STRESS == -8] <- 0

# These last two manipulations are based on the assumption that respondents' responses on the excessive 
# use of force equal to 0 referred to a negative answer, while those equal to 2 revealed a positive answer.
# This is due to the fact that throughout the entire questionnaire 0 represented negative answers an 1 
# positive ones, while in this question it changed to 2 and 1 respectively

df_train_2018$XSFORCE[df_train_2018$XSFORCE == -8] <- 0
df_train_2018$XSFORCE[df_train_2018$XSFORCE == 2] <- 0

# In the 2013 dataset, despite respondents' ability to respond using different increments of time (regarding length of training),
# there was a column that converted them all to the same unit (hours). This is not present in this year's dataset, but
# the same conversion factors  (1 week = 40 hours, 1 month = 160 hours, 1 semester = 480 hours)
df_train_2018$BASIC_LGTH[df_train_2018$BASIC_TYPE == 2] <- 40 * df_train_2018[df_train_2018$BASIC_TYPE == 2, "BASIC_LGTH"]
df_train_2018$BASIC_LGTH[df_train_2018$BASIC_TYPE == 3] <- 160 * df_train_2018[df_train_2018$BASIC_TYPE == 3, "BASIC_LGTH"]
df_train_2018$BASIC_LGTH[df_train_2018$BASIC_TYPE == 4] <- 480 * df_train_2018[df_train_2018$BASIC_TYPE == 4, "BASIC_LGTH"]

# All time increments are then reassigned to 1 (hours)
df_train_2018$BASIC_TYPE <- 1

grouped_t_2018 <- group_by(df_train_2018, STATECODE)

#Use a histogram of the number of hours dedicated by academy to find the appropriate average to use (mean or median)
ggplot(data = grouped_t_2018, aes(x = BASIC_LGTH)) +
  geom_histogram(color = "darkseagreen4", fill = "darkseagreen3")
training_state_2018 <- summarise(grouped_t_2018, mean_training_2018 = mean(na.omit(BASIC_LGTH)))
agg_df <- merge(x = agg_df, y = training_state_2018, by.x = "state", by.y = "STATECODE", all = TRUE)

# The West Virginia Academy decided not to participate in this census
NO_WV <- grouped_t_2018[str_detect(grouped_t_2018$STATECODE, "WV"), ]

# Use a histogram of the number of hours dedicated by academy to firearm training to find the appropriate average to use (mean or median)
ggplot(data = grouped_t_2018, aes(x = FIRE_SKILL)) +
  geom_histogram(color = "darkseagreen4", fill = "darkseagreen3")
firearm_state_2018 <- summarise(grouped_t_2018, median_firearm_2018 = median(FIRE_SKILL))
agg_df <- merge(x = agg_df, y = firearm_state_2018, by.x = "state", by.y = "STATECODE", all = TRUE)

# Use a histogram of the number of hours dedicated by academy to nonlethal weapon training to find the appropriate average to use (mean or median)
ggplot(data = grouped_t_2018, aes(x = NONL)) +
  geom_histogram(color = "darkseagreen4", fill = "darkseagreen3")
nonlethal_df_2018 <- summarise(grouped_t_2018, median_nonlethal_2018 = median(NONL))
agg_df <- merge(x = agg_df, y = nonlethal_df_2018, by.x = "state", by.y = "STATECODE", all = TRUE)

# Mean measure of how stress-oriented the academy is
stress_df_2018 <- summarise(grouped_t_2018, mean_stress_2018 = mean(na.omit(ENVIRONMENT)))
agg_df <- merge(x = agg_df, y = stress_df_2018, by.x = "state", by.y = "STATECODE", all = TRUE)

# Use a histogram  for the minimum training experience required to be an instructor to find the appropriate average to use (mean or median)
ggplot(data = grouped_t_2018, aes(x = MIN_EXP)) +
  geom_histogram(color = "darkseagreen4", fill = "darkseagreen3")
ins_exp_df_2018 <- summarise(grouped_t_2018, median_min_ins_exp_2018 = median(MIN_EXP))
agg_df <- merge(x = agg_df, y = ins_exp_df_2018, by.x = "state", by.y = "STATECODE", all = TRUE)

# Use a histogram of the number of hours dedicated by academy to mediation training to find the appropriate average to use (mean or median)
ggplot(data = grouped_t_2018, aes(x = COM_PART)) +
  geom_histogram(color = "darkseagreen4", fill = "darkseagreen3")
community_df_2018 <- summarise(grouped_t_2018, median_community_2018 = median(COM_PART))
agg_df <- merge(x = agg_df, y = community_df_2018, by.x = "state", by.y = "STATECODE", all = TRUE)

# Use a histogram of the number of hours dedicated by academy to mediation training to find the appropriate average to use (mean or median)
ggplot(data = grouped_t_2018, aes(x = MEDI)) +
  geom_histogram(color = "darkseagreen4", fill = "darkseagreen3")
mediation_df_2018 <- summarise(grouped_t_2018, median_mediation_2018 = median(MEDI))
agg_df <- merge(x = agg_df, y = mediation_df_2018, by.x = "state", by.y = "STATECODE", all = TRUE)

# Use a histogram of the number of hours dedicated by academy to stress management training to find the appropriate average to use (mean or median)
ggplot(data = grouped_t_2018, aes(x = STRESS)) +
  geom_histogram(color = "darkseagreen4", fill = "darkseagreen3")
stress_man_df_2018 <- summarise(grouped_t_2018, median_stress_man_2018 = median(STRESS))
agg_df <- merge(x = agg_df, y = stress_man_df_2018, by.x = "state", by.y = "STATECODE", all = TRUE)

# A measure of preparedness for responding to excessive use of force by another officer
force_id_df_2018 <- summarise(grouped_t_2018, mean_force_id_2018 = mean(na.omit(XSFORCE)))
agg_df <- merge(x = agg_df, y = force_id_df_2018, by.x = "state", by.y = "STATECODE", all = TRUE)

### ####