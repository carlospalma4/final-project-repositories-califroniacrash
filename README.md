# Final Project - Project Proposal
##### Jeremy Tan, Marie Kang, Carlos Alejandros Palma Bernal 

Story Pitch: 

	In recent years, police brutality and unjust police killings have gained mass attention and have raised events such petitions, strikes, and more. Police brutality has been prevalent in the United States since the late 1900s, particularly in black minority demographic pools. Thousands are unjustly killed each year, thus also affecting their close family members and friends. In light of this matter, we wondered whether police brutality rates differed by each state as each state in the United States has varying requirements for police training. Therefore, with the datasets that we found, we will be examining the intersection of police training and police brutality incidents from 2015 to 2023 in the United States in means to reveal the correlation and changes that have occurred throughout this period. Our main objective is to reveal whether insufficient police training is a leading factor in the disproportionate amount of violent encounters between law enforcement and civilians. 
Through our research, we discovered that the current FBI datasets actually undercounted fatal police shootings by more than half. Therefore, our team found a dataset that is transparently and accurately compiled of exact incidents which can then be filtered by state, city, police department, and more. We will utilize this dataset to track the deaths per state and further compare it with a second dataset that lists the required police training by state. This second dataset will be a combined dataset from the Census of State and Local Law Enforcement Training Academies from the time frame of 2013 to 2022. The second dataset lists the hours of training and even types of training required to execute their line of work. This second dataset goes further into detail with the types of police training required by state which will be compared to the first dataset in order to determine if the specific kind of training may also affect police brutality rates. We plan to specifically locate certain years in which there was a change in police training requirements and how that may have altered the results of police brutality. Our data analysis will reveal a closer look into the details in police training requirements in order to gauge a deeper understanding of why police brutality incidents have risen over the years. 
Our team believes that police brutality is a severe issue that is often overlooked, and hence needs further attention and analysis. 0.5% of encounters between police forces and civilians result in violence, and although that numeric percentage is seemingly miniscule, that results in thousands of deaths and incidents that could have been avoided. More importantly, it is an urgent issue that impacts those in minority communities and of color. Although factors such as racism are clear reasons for police brutality, we are specifically focusing on police training requirements because changing the police training curriculum is far more productive and realistic in comparison to “ending” racism. With our deeper understanding and analysis, we hope to find results that prompt and inspire a positive change within our society and police academies. 



Does lack of police training affect police brutality? 
Current: peak interest rise of police brutality 
Other points to consider besides lack of police training: racism, mental issues, entitlement 
Can a change in police enforcement/training alter police behavior? 
Has there been a decline in police training requirements? If so, has there been a correlating rise in police brutality as officers are less trained? 

Section A: General demographic of victims of police brutality? 
Age 
Race
Neighborhood

Section B: Calculations of police training by location (state/county) 
What state has the most rigorous police training? 
Is training harder for women or for men? Based on the findings (if applicable) is police brutality more prevalent in female or male officers? 

Section B: Police brutality on the general public
Is there a correspondence between police training and victims? 
Is there a correspondence between female and male officers? Does their training affect this? 

Background Research: 
https://www.washingtonpost.com/graphics/investigations/police-shootings-database/ 
Shows that the FBI databases UNDERCOUNT police shootings. As a result, the Post started their own dataset collection by year that is more accurate. This can be compared to our proposal as we are utilizing a dataset that is not from the FBI as we found that they undercount the deaths per capita in their dataset. 
This is a database of every person shot and killed by an on-duty police officer in the United States ranging back to 2015. Shows four sets; “How 2023 compares with previous calendar years” (a line graph comparing the previous years of killings), “Black American are killed at a much higher rate than White Americans” (shows a bar chart comparing different races killed), “Most victims are young” (another bar chart that graphs the number of people shot and killed between 15 to 84 years old), and a general database that shows every person shot by an on-duty police officer since Jan 1, 2015. Results can be filtered by state, city, police department, and more. We can use this dataset to track deaths and the police department responsible for the situation, but this contrasts as we are looking more into brutality, less deaths. 
https://www.pnas.org/doi/10.1073/pnas.1920671117
This article identifies inadequacy of police training as a major cause for the disproportionate number of violent interactions between police forces and civilians. This coincides with our approach as we will examine how differences in police training (and more specifically, related to time requirements) may be correlated with increased police brutality.
However, the article describes how an alternative form of police training (procedural justice) brings benefits to communities which include greater trust in police forces and reduced violent incidents. This contrasts with the approach of our datasets, as they are mostly focused on the causes for police brutality and the incidents themselves while not necessarily seeking for better alternatives for police training. 
https://iop.harvard.edu/get-involved/harvard-political-review/why-police-training-must-be-reformed
This article highlights the importance of addressing the problem of police brutality, because despite mentioning that only 0.5% of encounters between police forces and civilians result in violence, it still treats it as an issue that demands urgent attention by mentioning how significant its impacts are in minority communities. This is related to our approach because a percentage as low as that one translates to thousands of incidents in which people lose their lives regularly, demonstrating that this is not an issue to be ignored.
The article also criticizes police training as it presents excessive dedication towards the use of guns and other violent means to address policing situations while dedicating very little time for other methods such as the use of non-deadly instruments or de-escalation/verbal tactics. The police training dataset contains precisely a column related to the time allocated for the use of weapons and another one for de-escalation/verbal methods, as well as other possibly relevant factors.
https://www.npr.org/2020/05/30/866204394/how-police-training-has-evolved
The problem of policing is due to the overall structural problems within law enforcement agencies. Officers who show behavioral problems are hard to get rid of. Chiefs also don’t have the right mechanisms to hold officers accountable for repeat violations of abuse. This relates to the datasets as it sets a general basis of violations that officers commit. 
The article also states how cultural sensitivity training can help to minimize police violence. This contrasts to our dataset that we are working on as we are not covering the different races that police officers are. 
https://www.justice.gov/hatecrimes/hate-crime-statistics
This is a 2021 Hate Crime Statistic that serves as the national repository for crime data that is collected and submitted by law enforcement. These statistics include information about the types of offenses committed, the victims of these offenses, and the locations where they occured. This survey includes data submitted by 11,834 law enforcement agencies. Of the data submitted, there were  7,262 hate crime incidents involving 8,673 offenses. Some of these offenses may be committed by former police officers, but it’s hard to tell as the data is so large and broad. 
This website also shows an increase in reported hate crimes against individuals based on their race, ethnicity, religion, gender identity, and disability. This may relate to our approach as we may question that the behavior of police officers that commit these violent behaviors towards civilians maybe be racially driven. 






(New) Dataframes:
https://www.icpsr.umich.edu/web/NACJD/studies/36764 (2013) 
This dataset contains information from the Census of State and Local Law Enforcement Training Academies, a survey conducted by the United States Department of Justice and sent to all state and local law enforcement academies in the US that provide basic training for police officers. It reports information about the activities in their academies and the training methods utilized. It excludes any on-the-job training that recruits may have received after completion of the one received at the academy. The 89 percent response rate of the 2013 survey is reflected in the presence of 591 observations (representing each academy) and 526 variables, while the 90 percent response rate of the 2018 survey, affected by the higher number of police academies but with some others added that in the end were deemed ineligible, translates to the presence of 769 observations and 428 variables.
https://www.icpsr.umich.edu/web/NACJD/studies/38250 (2018)
Being an updated version of the 2013 set, this one takes 681 state and law enforcement training academies that provided basic training instruction to 59,511 recruits. This set includes general information about each academies’ facility resources, programs, staff, and training regiment. Unlike the 2013 dataset, nothing is stated whether if all 681 academies completed the survey itself. 
https://mappingpoliceviolence.org/   
Mapping Police Violence sources data from a number of sources. These sources come from both local and state agencies, with also some coming from public-accessible media sources. A primary method of detecting news media mentions of police violence comes from Google News according to the website. The dataset grabs any note of police violence ranging from 2013 to 2023.  The data is accessible by the website and downloadable files. The website shows multiple graphics of plots in order to visualize the data. Within the file, there are 11,354 rows that show all victims from 2013 to 2023. It also includes 68 columns like; name, gender, race, date, street address, city, state, agency responsible, cause of death, if the officer was charged, and much more. 


Additional data sources: 
https://www.washingtonpost.com/graphics/investigations/police-shootings-database/ 
https://www.trainingreform.org/state-police-training-requirements (we can use this dataset as it gives good information about police training requirements for all states) 
https://www.trainingreform.org/the-data (more state data) 


Design of app: 
https://policeviolencereport.org/ (this works for the victims of police brutality) 


Questions: 
Are we focusing on a national scale or Washington state? 
Is our sole focus on police training -> police brutality or should we look into other factors such as racism or entitlement? 

In another direction, we can look at the race of police officers in a state vs the race of the victims. 
Is there a clear correspondence that may lead us to believe that there may be a racially biased-motive?
https://bjs.ojp.gov/topics/crime/hate-crime
https://www.justice.gov/hatecrimes/hate-crime-statistics
