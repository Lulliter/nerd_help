#Writing the data out
# Use the write.table() function to write the data into a text file


autism_data <- read_csv("practice/data/autism_data.csv")
#txt
write.table(x = autism_data,
            file = "practice/Rcode/out/autism_pids.txt",
            row.names = FALSE)

#Use the write.csv() function to make the datafile a csv (comma separated values) file

#csv
write.csv(x = autism_data,
          file = "practice/Rcode/out/autism_pids.csv",
          row.names = FALSE)

## write linelist.csv
#write.csv(x = linelist_cleaned,
#          file = "~/Documents/AAA_LAVORO_UNIPV/BIOSTATISTICS_UNIUD/TRAINING_4/linelist_df.csv",
#         row.names = FALSE)



# ESERCITAZIONE -----------------------------------------------------------
#linelist <- read.csv(here::here("~/Documents/AAA_LAVORO_UNIPV/BIOSTATISTICS_UNIUD/TRAINING_4/linelist.csv"))
linelist <- read.csv(here::here("practice", "data","linelist.csv"))

#Correlation covariance on continous variable
colnames(linelist)

#var(x, y = NULL, na.rm = FALSE, use)
# Examples wt and ht
var(linelist$wt_kg,y = NULL, na.rm=TRUE)
var(linelist$ht_cm,y = NULL, na.rm=TRUE)
colnames(linelist)
#cov(x, y = NULL, use = "everything", method = c("pearson", "kendall", "spearman"))

# cov(linelist$wt_kg, linelist$ht_cm, use = "pairwise.complete.obs",
#     method = "spearman")

cor(linelist$wt_kg, linelist$ht_cm, use = "pairwise.complete.obs", method = "spearman")

#cor(x, y = NULL, use = "everything", method = c("pearson", "kendall", "spearman"))

cor.test(linelist$wt_kg, linelist$ht_cm,
         alternative = "two.sided",
         method = "pearson",
         exact = NULL, conf.level = 0.95, continuity = FALSE)


cor.test(linelist$wt_kg, linelist$ht_cm,
         alternative = "greater",
         method = "pearson",
         exact = NULL, conf.level = 0.95, continuity = FALSE)



#Test for association
#cor.test(x, y,
#        alternative = c("two.sided", "less", "greater"),
#        method = c("pearson", "kendall", "spearman"),
#        exact = NULL, conf.level = 0.95, continuity = FALSE, ...)

cor.test(linelist$wt_kg, linelist$ht_cm,
         alternative = "two.sided",
         method = "kendall",
         exact = NULL, conf.level = 0.95, continuity = FALSE)

#scatter plot
library(ggplot2)
ggplot(linelist, aes(x = wt_kg, y = ht_cm)) + geom_point() + theme_bw()

#scatter plot + line
ggplot(data = linelist,
       mapping = aes(           # map aesthetics to columns
         x = wt_kg,
         y = ht_cm)) + 
  geom_point(                   # add points for each row of data
    size = 0.7,
    alpha = 0.5,
    colour = "darkblue") +  
  geom_smooth(                  # add a trend line 
    method = "lm",              # with linear method
    size = 1,
    colour = "red")                   # size (width of line) of 2

#We’re interested to see if there’s any correlation between any of the clinical variables in the dataset. Let’s explore this by generating a correlation plot.

# please install corrplot prior to running the below code by running: install.packages("corrplot")
library(corrplot)

#import dataset gait_clean
# gait <- read.csv("~/Documents/AAA_LAVORO_UNIPV/BIOSTATISTICS_UNIUD/TRAINING_4/gait.csv", na.strings="NaN")

gait <- read.csv(here::here("practice", "data","gait.csv"), na.strings="NaN")

gait_clin<-gait[,c("HoehnYahr","UPDRS","UPDRSM", 
                   "TUAG", "Speed_01..m.sec.","Speed_10")]

# create a correlation matrix of the clinical markers using Spearman correlation
correlations <- cor(gait_clin, method = "spearman" ,use="pairwise.complete.obs")

# create the correlation plot
library(corrplot)
corrplot(correlations, method = "color")


#PLOT CATEGORICAL VARIABLES

#myorderedfactor <- factor(responses, levels = c("low", "medium", "high"), 
#ordered = TRUE) 

#levels(myfactor) 
#[1] "low" "medium" "high" 

table(linelist$hospital, useNA = "always")

class(linelist$hospital)
linelist$ord_hosp <- factor(linelist$hospital, levels = c("Central Hospital", "Military Hospital", "Port Hospital", "St. Mark's Maternity Hospital (SMMH)", "Other", "Missing"), 
                          ordered = TRUE) 
class(linelist$ord_hosp) 
levels(linelist$ord_hosp)

# stat = “identity” to make barplots with variable value. Note that, 
#the default value of the argument stat is “bin”. In this case, 
#the height of the bar represents the count of cases in each category.
# Don't map a variable to y

ggplot(linelist, aes(y=ord_hosp, fill=outcome))+
  geom_bar(stat="count", width=0.7)+
  theme_minimal()

#Chi square test with Base R

table(linelist$gender, linelist$outcome)

table(linelist$gender, linelist$outcome, useNA = "ifany")
chisq.test(linelist$gender, linelist$outcome)

#Chi square test with gtsummary

#install (gtsummary with dependencies)
#install.packages("gtsummary")
library(gtsummary)

library(tidyverse)
linelist %>% 
  select(gender, outcome) %>%    # keep variables of interest
  tbl_summary(by = outcome) %>%  # produce summary table and specify grouping variable
  add_p()                        # specify what test to perform

# Difference regression vs ANOVA vs GLM
#generate 2 samples of random values following the normal distribution
gr1 = rnorm(10,10,1)
gr2 = rnorm(10,20,1)
hist(gr1)
hist(gr2)


#create a dataframe with a 2-level categorical variable
df=data.frame(nm = c(gr1,gr2), 
              gr = c(rep(0,length(gr1)),
                     rep(1,length(gr2))))

plot(df$gr,df$nm)

#ANOVA

summary(aov(nm~gr, data = df))

#Linear regression

summary(lm(nm~gr, data = df))

#t-test

tt=t.test(df$nm~df$gr);tt
(tt$statistic)^2

#ANOVA BY R
#The following code creates the data frame we’ll be working with:
  
  #make this example reproducible
  set.seed(0)

#create data frame
data <- data.frame(program = rep(c("A", "B", "C"), each = 30),
                   weight_loss = c(runif(30, 0, 3),
                                   runif(30, 0, 5),
                                   runif(30, 1, 7)))

#view first six rows of data frame


head(data)

#summarise by group with summarise()
data %>%
  group_by(program) %>%
  summarise(mean = mean(weight_loss), n = n())

#create boxplots
boxplot(weight_loss ~ program,
        data = data,
        main = "Weight Loss Distribution by Program",
        xlab = "Program",
        ylab = "Weight Loss",
        col = "steelblue",
        border = "black")

#fit the one-way ANOVA model
model <- aov(weight_loss ~ program, data = data)

#view the model output
summary(model)

#            Df Sum Sq Mean Sq F value   Pr(>F)    
#program      2  98.93   49.46   30.83 7.55e-11 ***
#Residuals   87 139.57    1.60                     
#---
#Signif. codes:  0 '***' 0.001 '**' 0.01 '*' 0.05 '.' 0.1 ' ' 1


plot(model)

#load car package
install.packages("car")
library(car)

#conduct Levene's Test for equality of variances
leveneTest(weight_loss ~ program, data = data)

#perform Tukey's Test for multiple comparisons
TukeyHSD(model, conf.level=.95) 

#  Tukey multiple comparisons of means
#    95% family-wise confidence level
#
#Fit: aov(formula = weight_loss ~ program, data = data)
#
#$program
#         diff       lwr      upr     p adj
#B-A 0.9777414 0.1979466 1.757536 0.0100545
#C-A 2.5454024 1.7656076 3.325197 0.0000000
#C-B 1.5676610 0.7878662 2.347456 0.0000199

#create confidence interval for each comparison
plot(TukeyHSD(model, conf.level=.95), las = 2)

