# ho cambiato qlc xche non capivo 

library(tidyverse)


autism_data <- read.csv(file = "practice/data/autism_data.csv", 
                        header = TRUE, 
                        sep = ",", 
                        na.strings = "?") 
colnames(autism_data)


autism_pids <- read.csv(file = "practice/data/autism_pids.csv",
                        header = TRUE,
                        sep = ",",
                        na.strings = "?")

autism_pids$pids <- paste( "PatientID_" , autism_data$id, sep = "")

#write.csv(x = autism_pids, file = "autism_pids.csv", row.names = FALSE) 



class(autism_data$age)

#histogram age
ggplot(autism_data, aes(x=age)) + geom_histogram() + theme_bw()
#or
autism_data %>% ggplot(aes(x = age )) + geom_histogram() + theme_bw()

autism_data %>% ggplot(aes(x = age, fill = gender )) + geom_histogram() + theme_bw()

class(autism_data$result)

autism_data %>% ggplot(aes(x = result )) + geom_bar() + theme_bw()

#Box plot

autism_data %>% ggplot(aes(x=ethnicity,y=result)) + geom_boxplot() + theme_bw()
#fix axis text
autism_data %>% ggplot(aes(x=ethnicity,y=result)) + geom_boxplot() + theme_bw()+
theme(axis.text.x = element_text(angle = 90, size=8, vjust = 0.5, hjust=1))


#Violin plot
ggplot(autism_data, aes(x=ethnicity,y=result)) +
  geom_violin() + theme_bw()
#fix axis text
ggplot(autism_data, aes(x=ethnicity,y=result)) +
  geom_violin() + theme_bw()+ theme(axis.text.x = element_text(angle = 90, size=8, vjust = 0.5, hjust=1))







#Figure 15.3: A density distribution plot. The scale of the y axis may seem odd; 
#it has units of "inverse bp" This scale is arranged so that the area under
#the entire density curve is 1. This convention facilitates densities for different
#groups, e.g. male versus female. It also means that narrow distributions tend to
#have high density.


