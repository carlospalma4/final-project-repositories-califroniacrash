library(dplyr)
library(stringr)
library(ggplot2)
library(ggstatsplot)
library(rstatix)
library(tibble)

# Loading the dataframes
df_1 <- read.csv("Mapping Police Violence.csv")
df_2 <- read.csv("2013-Data.csv")
df_3 <- read.csv("2018-Data.csv")
df_4 <- read.csv("USAregions.csv")
df_5 <- read.csv("2013 Population.csv")
df_6 <- read.csv("2018 Population.csv")

violence <- df_1
df_train_2013 <- df_2
df_train_2018 <- df_3
regions_df <- df_4
pop_2013 <- df_5
pop_2018 <- df_6

pop_2013 <- tail(pop_2013, 58)
pop_2013 <- head(pop_2013, 51)
colnames(pop_2013)[1] <- "State"
pop_2013$State <- substring(pop_2013$State, 2, length(pop_2013$State))
pop_2017 <- select(pop_2013, State, X.9)
pop_2017$State <- state.abb[match(pop_2017$State, state.name)]
colnames(pop_2017)[1] <- "state"
pop_2017[is.na(pop_2017$state), "state"] <- "DC"


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
incidents_state_2013 <- merge(x = incidents_state_2013, y = pop_2017, by = "state", all = TRUE)
colnames(incidents_state_2013)[3] <- "Population_2017"
incidents_state_2013$Population_2017 <- str_remove_all(incidents_state_2013$Population_2017, ",")
incidents_state_2013$incidents_2013_per_1000000 <- 1000000*incidents_state_2013$incidents_2013/as.numeric(incidents_state_2013$Population_2017)

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
#colnames(agg_df)[3] <- "2017 Population"
### ####

### 2018 Data Wrangling ####

pop_2018 <- tail(pop_2018, 58)
pop_2018 <- head(pop_2018, 51)
colnames(pop_2018)[1] <- "State"
pop_2018$State <- substring(pop_2018$State, 2, length(pop_2018$State))
pop_2022 <- select(pop_2018, State, X.3)
pop_2022$State <- state.abb[match(pop_2022$State, state.name)]
colnames(pop_2022)[1] <- "state"
pop_2022[is.na(pop_2022$state), "state"] <- "DC"



#Keep expanding agg_df
grouped_p_2018 <- group_by(incidents_df_2018, state)
incidents_state_2018 <- summarise(grouped_p_2018, incidents_2018 = length(state))
incidents_state_2018 <- merge(x = incidents_state_2018, y = pop_2022, by = "state", all = TRUE)
colnames(incidents_state_2018)[3] <- "Population_2022"
incidents_state_2018$Population_2022 <- str_remove_all(incidents_state_2018$Population_2022, ",")
incidents_state_2018$incidents_2018_per_1000000 <- 1000000*incidents_state_2018$incidents_2018/as.numeric(incidents_state_2018$Population_2022)
agg_df <- merge(x = agg_df, y = incidents_state_2018, by = "state", all = TRUE)
#colnames(agg_df)[14] <- "2022 Population"

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

states_reg_df <- regions_df[order(regions_df$Postal.Code), ]
states_reg_df <- states_reg_df[!states_reg_df$Postal.Code == "US", ]

agg_df$Region <- states_reg_df$Region.Name

training_vs_incidents_2013 <- ggplot(data = agg_df, aes(x = (median_training_2013), y = incidents_2013_per_1000000)) +
  geom_point() +
  labs(x = "Training duration (in hours)", y = "Incidents per million (2013-2017)")
plot(training_vs_incidents_2013)

training_vs_incidents_2018 <- ggplot(data = agg_df, aes(x = (mean_training_2018), y = incidents_2018_per_1000000)) +
  geom_point() + 
  labs(x = "Training duration (in hours)", y = "Incidents per million (2018-2022)")
plot(training_vs_incidents_2018)

mys <- agg_df[agg_df$incidents_2013_per_1000000 > 15 & agg_df$Region == "North East", ]

incidents_region_2013 <- ggplot(data = agg_df, aes(x = Region, y = incidents_2013_per_1000000)) +
  geom_boxplot() + 
  labs(y = "Incidents per million (2013-2017)")
plot(incidents_region_2013)

df_1n <- select(agg_df, state, Region, incidents_2013, Population_2017, incidents_2013_per_1000000, median_training_2013, mean_firearm_2013, median_nonlethal_2013, mean_stress_2013, median_min_ins_exp_2013, median_community_2013, median_mediation_2013, median_stress_man_2013, mean_force_id_2013)
colnames(df_1n) <- c("state", "Region", "incidents", "Population", "incidents_per_1000000", "median_training", "mean_firearm", "median_nonlethal", "mean_stress", "median_min_ins_exp", "median_community", "median_mediation", "median_stress_man", "mean_force_id")
df_1n$Year <- 2013
df_1n <- df_1n[, c("state", "Region", "Year", "incidents", "Population", "incidents_per_1000000", "median_training", "mean_firearm", "median_nonlethal", "mean_stress", "median_min_ins_exp", "median_community", "median_mediation", "median_stress_man", "mean_force_id")]

df_2n <- select(agg_df, state, Region, incidents_2018, Population_2022, incidents_2018_per_1000000, mean_training_2018, median_firearm_2018, median_nonlethal_2018, mean_stress_2018, median_min_ins_exp_2018, median_community_2018, median_mediation_2018, median_stress_man_2018, mean_force_id_2018)
colnames(df_2n) <- c("state", "Region", "incidents", "Population", "incidents_per_1000000", "median_training", "mean_firearm", "median_nonlethal", "mean_stress", "median_min_ins_exp", "median_community", "median_mediation", "median_stress_man", "mean_force_id")
df_2n$Year <- 2018
df_2n <- df_2n[, c("state", "Region", "Year", "incidents", "Population", "incidents_per_1000000", "median_training", "mean_firearm", "median_nonlethal", "mean_stress", "median_min_ins_exp", "median_community", "median_mediation", "median_stress_man", "mean_force_id")]

df_new <- rbind(df_1n, df_2n)

us_incidents_per_1m <- summarise(group_by(df_new, Year), total_1m = sum(incidents_per_1000000))
us_total_perc_change <- round(pull((us_incidents_per_1m[us_incidents_per_1m$Year == 2018, "total_1m"] - us_incidents_per_1m[us_incidents_per_1m$Year == 2013, "total_1m"])/us_incidents_per_1m[us_incidents_per_1m$Year == 2013, "total_1m"]))

incidents_region_change_df <- summarise(group_by(df_new, Region, Year), incidents_region = mean(incidents_per_1000000))
ok8ca <- summarise(group_by(df_new, Region, Year), incidents_region = mean(incidents_per_1000000))
incidents_region_change <- ggplot(data = incidents_region_change_df, aes(x = Year, y = incidents_region)) +
  geom_line(aes(col = Region)) +
  labs(y = "Average incidents (per million)", col = "Region")
plot(incidents_region_change)

rockies_df <- df_new[df_new$Region == "Rockies", ]
incidents_rockies_change <- ggplot(data = rockies_df, aes(x = Year, y = incidents_per_1000000)) +
  geom_line(aes(col = state)) +
  labs(y = "Average incidents (per million)", col = "State")
plot(incidents_rockies_change)
perc_change_rockies <- round(100 * as.numeric(c((rockies_df[rockies_df$state == "CO" & rockies_df$Year == 2018, "incidents_per_1000000"] - rockies_df[rockies_df$state == "CO" & rockies_df$Year == 2013, "incidents_per_1000000"])/rockies_df[rockies_df$state == "CO" & rockies_df$Year == 2013, "incidents_per_1000000"], (rockies_df[rockies_df$state == "ID" & rockies_df$Year == 2018, "incidents_per_1000000"] - rockies_df[rockies_df$state == "ID" & rockies_df$Year == 2013, "incidents_per_1000000"])/rockies_df[rockies_df$state == "ID" & rockies_df$Year == 2013, "incidents_per_1000000"], (rockies_df[rockies_df$state == "MT" & rockies_df$Year == 2018, "incidents_per_1000000"] - rockies_df[rockies_df$state == "MT" & rockies_df$Year == 2013, "incidents_per_1000000"])/rockies_df[rockies_df$state == "MT" & rockies_df$Year == 2013, "incidents_per_1000000"], (rockies_df[rockies_df$state == "UT" & rockies_df$Year == 2018, "incidents_per_1000000"] - rockies_df[rockies_df$state == "UT" & rockies_df$Year == 2013, "incidents_per_1000000"])/rockies_df[rockies_df$state == "UT" & rockies_df$Year == 2013, "incidents_per_1000000"], (rockies_df[rockies_df$state == "WY" & rockies_df$Year == 2018, "incidents_per_1000000"] - rockies_df[rockies_df$state == "WY" & rockies_df$Year == 2013, "incidents_per_1000000"])/rockies_df[rockies_df$state == "WY" & rockies_df$Year == 2013, "incidents_per_1000000"])))

perc_change <- round(100 * as.numeric(c((incidents_region_change_df[incidents_region_change_df$Region =="Far West" & incidents_region_change_df$Year == 2018, "incidents_region"] - incidents_region_change_df[incidents_region_change_df$Region =="Far West" & incidents_region_change_df$Year == 2013, "incidents_region"])/incidents_region_change_df[incidents_region_change_df$Region =="Far West" & incidents_region_change_df$Year == 2013, "incidents_region"], (incidents_region_change_df[incidents_region_change_df$Region == "Great Lakes" & incidents_region_change_df$Year == 2018, "incidents_region"] - incidents_region_change_df[incidents_region_change_df$Region =="Great Lakes" & incidents_region_change_df$Year == 2013, "incidents_region"])/incidents_region_change_df[incidents_region_change_df$Region =="Great Lakes" & incidents_region_change_df$Year == 2013, "incidents_region"], (incidents_region_change_df[incidents_region_change_df$Region =="Mid-Atlantic" & incidents_region_change_df$Year == 2018, "incidents_region"] - incidents_region_change_df[incidents_region_change_df$Region =="Mid-Atlantic" & incidents_region_change_df$Year == 2013, "incidents_region"])/incidents_region_change_df[incidents_region_change_df$Region =="Mid-Atlantic" & incidents_region_change_df$Year == 2013, "incidents_region"], (incidents_region_change_df[incidents_region_change_df$Region =="North East" & incidents_region_change_df$Year == 2018, "incidents_region"] - incidents_region_change_df[incidents_region_change_df$Region =="North East" & incidents_region_change_df$Year == 2013, "incidents_region"])/incidents_region_change_df[incidents_region_change_df$Region =="North East" & incidents_region_change_df$Year == 2013, "incidents_region"], (incidents_region_change_df[incidents_region_change_df$Region =="Plains" & incidents_region_change_df$Year == 2018, "incidents_region"] - incidents_region_change_df[incidents_region_change_df$Region =="Plains" & incidents_region_change_df$Year == 2013, "incidents_region"])/incidents_region_change_df[incidents_region_change_df$Region =="Plains" & incidents_region_change_df$Year == 2013, "incidents_region"], (incidents_region_change_df[incidents_region_change_df$Region =="Rockies" & incidents_region_change_df$Year == 2018, "incidents_region"] - incidents_region_change_df[incidents_region_change_df$Region =="Rockies" & incidents_region_change_df$Year == 2013, "incidents_region"])/incidents_region_change_df[incidents_region_change_df$Region =="Rockies" & incidents_region_change_df$Year == 2013, "incidents_region"], (incidents_region_change_df[incidents_region_change_df$Region =="South East" & incidents_region_change_df$Year == 2018, "incidents_region"] - incidents_region_change_df[incidents_region_change_df$Region =="South East" & incidents_region_change_df$Year == 2013, "incidents_region"])/incidents_region_change_df[incidents_region_change_df$Region =="South East" & incidents_region_change_df$Year == 2013, "incidents_region"], (incidents_region_change_df[incidents_region_change_df$Region =="South West" & incidents_region_change_df$Year == 2018, "incidents_region"] - incidents_region_change_df[incidents_region_change_df$Region =="South West" & incidents_region_change_df$Year == 2013, "incidents_region"])/incidents_region_change_df[incidents_region_change_df$Region =="South West" & incidents_region_change_df$Year == 2013, "incidents_region"])))
### ####

mid_atl_df <- df_new[df_new$Region == "Mid-Atlantic", ]
incidents_mid_change <- ggplot(data = mid_atl_df, aes(x = Year, y = incidents_per_1000000)) +
  geom_line(aes(col = state)) +
  labs(y = "Average incidents (per million)", col = "State")
plot(incidents_mid_change)
perc_change_rockies <- round(100 * as.numeric(c((mid_atl_df[mid_atl_df$state == "DC" & mid_atl_df$Year == 2018, "incidents_per_1000000"] - mid_atl_df[mid_atl_df$state == "DC" & mid_atl_df$Year == 2013, "incidents_per_1000000"])/mid_atl_df[mid_atl_df$state == "DC" & mid_atl_df$Year == 2013, "incidents_per_1000000"], (mid_atl_df[mid_atl_df$state == "DE" & mid_atl_df$Year == 2018, "incidents_per_1000000"] - mid_atl_df[mid_atl_df$state == "DE" & mid_atl_df$Year == 2013, "incidents_per_1000000"])/mid_atl_df[mid_atl_df$state == "DE" & mid_atl_df$Year == 2013, "incidents_per_1000000"], (mid_atl_df[mid_atl_df$state == "MD" & mid_atl_df$Year == 2018, "incidents_per_1000000"] - mid_atl_df[mid_atl_df$state == "MD" & mid_atl_df$Year == 2013, "incidents_per_1000000"])/mid_atl_df[mid_atl_df$state == "MD" & mid_atl_df$Year == 2013, "incidents_per_1000000"], (mid_atl_df[mid_atl_df$state == "PA" & mid_atl_df$Year == 2018, "incidents_per_1000000"] - mid_atl_df[mid_atl_df$state == "PA" & mid_atl_df$Year == 2013, "incidents_per_1000000"])/mid_atl_df[mid_atl_df$state == "PA" & mid_atl_df$Year == 2013, "incidents_per_1000000"], (mid_atl_df[mid_atl_df$state == "VA" & mid_atl_df$Year == 2018, "incidents_per_1000000"] - mid_atl_df[mid_atl_df$state == "VA" & mid_atl_df$Year == 2013, "incidents_per_1000000"])/mid_atl_df[mid_atl_df$state == "VA" & mid_atl_df$Year == 2013, "incidents_per_1000000"], (mid_atl_df[mid_atl_df$state == "WV" & mid_atl_df$Year == 2018, "incidents_per_1000000"] - mid_atl_df[mid_atl_df$state == "WV" & mid_atl_df$Year == 2013, "incidents_per_1000000"])/mid_atl_df[mid_atl_df$state == "WV" & mid_atl_df$Year == 2013, "incidents_per_1000000"])))

incidents_region_2018 <- ggplot(data = agg_df, aes(x = Region, y = incidents_2018_per_1000000)) +
  geom_boxplot() +
  labs(y = "Incidents per million (2018-2022)")
plot(incidents_region_2018)

mys_2018 <- agg_df[agg_df$incidents_2018_per_1000000 > 40 & agg_df$Region == "South West", ]

ME_change <- round(100*(mys$incidents_2018_per_1000000 - mys$incidents_2013_per_1000000)/mys$incidents_2013_per_1000000)
ME_stress_change <- round(100*(mys$mean_stress_2018 - mys$mean_stress_2013)/mys$mean_stress_2013)
ME_stress_man_change <- round(100*(mys$median_stress_man_2018 - mys$median_stress_man_2013)/mys$median_stress_man_2013)

NM_change <- round(100*(mys_2018$incidents_2018_per_1000000 - mys_2018$incidents_2013_per_1000000)/mys_2018$incidents_2013_per_1000000)
NM_stress_change <- round(100*(mys_2018$mean_stress_2018 - mys_2018$mean_stress_2013)/mys_2018$mean_stress_2013)

change <- round(100*(agg_df$incidents_2018_per_1000000 - agg_df$incidents_2013_per_1000000)/agg_df$incidents_2013_per_1000000)
change_CT <- min(change)
change_NE <- (agg_df[agg_df$Region == "North East", "incidents_2013_per_1000000"] - agg_df[agg_df$Region == "North East", "incidents_2018_per_1000000"])/agg_df[agg_df$Region == "North East", "incidents_2013_per_1000000"]
mean_change_NE <- mean(change_NE)

mean_change <- mean(change)

CT_df <- agg_df[agg_df$state == "CT", ]
mean_nat_training <- mean(agg_df$mean_training_2018, na.rm = TRUE)
mean_fire_training <- mean(agg_df$median_firearm_2018, na.rm = TRUE)
mean_nat_stress_training <- mean(agg_df$mean_stress_2018, na.rm = TRUE)

mean_nat_community_training <- mean(agg_df$median_community_2018, na.rm = TRUE)
mean_nat_mediation_training <- mean(agg_df$median_mediation_2018, na.rm = TRUE)
mean_nat_stress_man_training <- mean(agg_df$median_stress_man_2018, na.rm = TRUE)
mean_nat_forceid_training <- mean(agg_df$mean_force_id_2018, na.rm = TRUE)

agg_grouped <- group_by(agg_df, Region)
mean_reg_stress_training <- summarise(agg_grouped, stress = mean(mean_stress_2018, na.rm = TRUE))
mean_reg_community_training <- summarise(agg_grouped, community = mean(median_community_2018 - median_community_2013, na.rm = TRUE))
mean_reg_stress_man_training <- summarise(agg_grouped, stress_man = mean(median_stress_man_2018, na.rm = TRUE))
mean_reg_force_id_training <- summarise(agg_grouped, force_id = mean(mean_force_id_2018, na.rm = TRUE))

states_vec <- agg_df$state
change_incidents_us_df <- data.frame(states_vec, change)

force_id_state <- agg_df[agg_df$mean_force_id_2018 == 1, ]
force_id_state_NE <- agg_df[agg_df$mean_force_id_2018 == 1 & agg_df$Region == "North East", ]

NE_df <- agg_df[agg_df$Region == "North East", ]

change_barplot <- ggplot(data = change_incidents_us_df, aes(x = change, y = reorder(states_vec, change))) +
  geom_bar(stat = 'identity') +
  labs(x = "Percent change in incidents per million (2013-2017 - 2018-2022)", y = "State")

stress_man_barplot <- ggplot(data = agg_df, aes(x = median_stress_man_2018 - median_stress_man_2013, y = reorder(state, median_stress_man_2018 - median_stress_man_2013))) +
  geom_bar(stat = 'identity') +
  labs(x = "Change in training dedicated to stress management skills (in hours)", y = "state")

force_id_barplot <- ggplot(data = agg_df, aes(x = mean_force_id_2018 - mean_force_id_2013, y = reorder(state, mean_force_id_2018))) +
  geom_bar(stat = 'identity') +
  labs(x = "Change in proportion of academies that offer training in identification of excessive use of force", y = "State")

training_barplot <- ggplot(data = agg_df, aes(x = mean_training_2018 - median_training_2013, y = reorder(state, mean_training_2018 - median_training_2013)))+
  geom_bar(stat = 'identity') +
  labs(x = "Change of total duration of training (in hours)", y = "State")
plot(training_barplot)

stress_barplot <- ggplot(data = agg_df, aes(x = mean_stress_2018 - mean_stress_2013, y = reorder(state, mean_stress_2018 - mean_stress_2013)))+
  geom_bar(stat = 'identity') + 
  labs(x = "Change in stress levels experienced by recruits in training (1-5 scale)", y = "state")

train_diff <- agg_df$mean_training_2018 - agg_df$median_training_2013
train_diff_df <- data.frame(states_vec, train_diff)
train_diff_reg_df <- merge(x = train_diff_df, y = select(agg_df, state, Region), by.x = "states_vec", by.y = "state", all = TRUE)
train_diff_sorted <- arrange(train_diff_df, train_diff)

train_reg <- summarise(group_by(train_diff_reg_df, Region), mean_training = mean(train_diff, na.rm = TRUE))

incidents_barplot <- ggplot(data = agg_df, aes(x = incidents_2018_per_1000000, y = reorder(state, incidents_2018_per_1000000)))+
   geom_bar(stat = 'identity') +
  labs(x = "Total incidents per million (2018-2022)", y = "State")
 
training_change_barplot <- ggplot(data = train_diff_df, aes(x = train_diff, y = reorder(states_vec, train_diff)))+
  geom_bar(stat = 'identity') + 
  labs(x = "Change in total duration of training (in hours)", y = "State")

training_change_region_barplot <- ggplot(data = train_reg, aes(x = mean_training, y = reorder(Region, mean_training)))+
  geom_bar(stat = 'identity') +
  labs(x = "Change in total duration of training (in hours)", y = "Region")

agg_sorted <- arrange(agg_df, -mean_training_2018)
plot(change_barplot)
plot(stress_man_barplot)
plot(force_id_barplot)
plot(incidents_barplot)
plot(training_change_barplot)
plot(training_change_region_barplot)
plot(stress_barplot)