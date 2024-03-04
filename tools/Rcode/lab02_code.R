library(here)
library(readxl)

Genes <- read_excel(here("practice","data","Genes.xlsx"))
#View(Genes)

summary(Genes)

head(Genes)

library(tidyverse)
Genes %>%
  ggplot(aes(x = Gene_Length_bp, y = 1)) + 
  geom_point(alpha = 0.06, position = "jitter" ) +  
  xlab("Gene lentgh (bp)") + 
  ylab("") + theme_bw() + scale_color_grey()  


Genes %>%
  ggplot(aes(x = Gene_Length_bp) ) + 
  geom_density(color = "gray", fill = "gray", alpha = 0.75) + 
  xlab("Gene lentgh (bp)") + ylab("Density (1/bp)")


Genes %>%
  ggplot(aes(x = Gene_Length_bp) ) + 
  geom_density(color = "gray", fill = "gray", alpha = 0.75) + 
  xlab("Gene lentgh (bp)") + ylab("Density (1/bp)")+xlim(-1000,400000)

#Violin plot
ggplot(Genes, aes(x= Chromosome,y = Gene_Length_bp)) +
  geom_violin() + theme_bw()

#Extract X chromosome
X_genes <- Genes[Genes$Chromosome == "X", ] 

ggplot(X_genes, aes(x= Chromosome,y = Gene_Length_bp)) +
  geom_violin() + theme_bw()

#QQ plot
ggplot(mtcars, aes(sample = mpg)) +
  stat_qq() +
  stat_qq_line()


ggplot(X_genes, aes(sample = Gene_Length_bp)) +
  stat_qq() +
  stat_qq_line()

#create Q-Q plot
#qqnorm(data)

#add straight diagonal line to plot
#qqline(data)

qqnorm(X_genes$Gene_Length_bp)
qqline(X_genes$Gene_Length_bp)

mean(X_genes$Gene_Length_bp)
qpois(X_genes$Gene_Length_bp, lambda=60512)

#Import Gait dataset
gait <- read_csv(url("https://raw.githubusercontent.com/Sydney-Informatics-Hub/lessonbmc/gh-pages/_episodes_rmd/data/gait_clean.csv"), na = "NaN") 
names(gait) <- make.names(names(gait), unique=TRUE) 
summary(gait)


#Fixing Height Study Ju

#Return only the rows (patients) Study==Ju
gait_ju<-gait[gait$Study == "Ju", ] 
gait_non_ju<-gait[gait$Study !="Ju", ] 
gait_ju$Height..meters.<-gait_ju$Height..meters./100
summary(gait_ju$Height..meters.)

gait_cor <- rbind(gait_non_ju, gait_ju)
summary(gait_cor)

#Normality of clinical measures

  normality<-function(variable){
    library(moments)
    variabile=na.omit(variable)  
    cat("Skewness value is ", skewness(variabile), "(normal if = 0)","\n")
    t_skwe<-skewness(variabile)/sqrt(6/length(variabile))
    p_skwe<-2*(1-pt(abs(t_skwe),length(variabile)-2))
    cat("The skewness t-score is ", t_skwe, "(simmetric if < |2|)","\n") 
    cat("The skewness p-value in T test two tail is", p_skwe,"(H0: skewness=0)","\n\n")
    cat("Kurtosis value is ", kurtosis(variabile)-3, "(normal if = 0)","\n")
    t_kurt<-(kurtosis(variabile)-3)/sqrt(24/length(variabile))
    p_kurt<-2*(1-pt(abs(t_kurt),length(variabile)-2))
    cat("The kurtosis t-score is ", t_kurt, "(normal if < |2|)","\n") 
    cat("The kurtosis p-value in T test two tail is", p_kurt,"(H0: kurtosis=0)","\n\n")
    print(shapiro.test(variabile)) # Shapiro-Wilk test 
    cat("Shapiro-Wilk H0: φ(X)= N(μ,σ2); H1: φ(X) ≠ N(μ,σ2 )","\n")
    print(ks.test(variabile, "pnorm", mean = mean(variabile), sd = sd(variabile))) #Kolmogorov-Smirnov test
    cat("Kolmogorov-Smirnov H0: φ(X)= N(μ,σ2); H1: φ(X) ≠ N(μ,σ2))","\n")
    cat("Relative frequencies histogram plot","\n") 
    cat("and its smoothing function (in red)","\n\n\n")
    hist(variabile, main="",ylim=c(min(c(density(variabile)$y,hist(variabile,prob=T)$density)),max(c(density(variabile)$y))),prob=T) 
    lines(density(variabile), col = 2)
  }
  
normality(gait$TUAG)
normality(gait$Speed_01..m.sec.)
normality(gait$Speed_10)


#Normality of of clinical measures by groups
gait_PD <- gait[gait$Group=="PD",]
gait_CO <- gait[gait$Group=="CO",]

normality(gait_PD$TUAG)
normality(gait_CO$TUAG)
normality(gait_PD$Speed_10)
normality(gait_CO$Speed_10)
normality(gait_PD$Speed_01..m.sec.)
normality(gait_CO$Speed_01..m.sec.)

#Independence of observations

#install.packages("lawstat") 

library(lawstat) 
runs.test(gait$TUAG, alternative = "two.sided") 
runs.test(gait$Speed_01..m.sec., alternative = "two.sided") 
runs.test(gait$Speed_10, alternative = "two.sided") 

#Independence of observations by groups
library(lawstat) 
runs.test(gait_PD$TUAG, alternative = "two.sided") 
runs.test(gait_CO$TUAG, alternative = "two.sided") 
runs.test(gait_PD$Speed_01..m.sec., alternative = "two.sided") 
runs.test(gait_CO$Speed_01..m.sec., alternative = "two.sided") 
runs.test(gait_PD$Speed_10, alternative = "two.sided") 
runs.test(gait_CO$Speed_10, alternative = "two.sided") 

#Homogeneity of variance in clinical measures by groups

var.test(gait$TUAG~gait$Group, ratio = 1, alternative = "two.sided")
var.test(gait$Speed_01..m.sec.~gait$Group, ratio = 1, alternative = "two.sided")
var.test(gait$Speed_10~gait$Group, ratio = 1, alternative = "two.sided")

#Non parametric test
wilcox.test(TUAG ~ Group, data = gait)
wilcox.test(Speed_01..m.sec. ~ Group, data = gait)
wilcox.test(Speed_10 ~ Group, data = gait)

#Parametric test
t.test(TUAG ~ Group, data = gait)
t.test(Speed_01..m.sec. ~ Group, data = gait)
t.test(Speed_10 ~ Group, data = gait)

t.test(TUAG ~ Group, data = gait, alternative ="less")
t.test(Speed_01..m.sec. ~ Group, data = gait, alternative ="greater")
t.test(Speed_10 ~ Group, data = gait, alternative ="greater")

# Let's visualise this data
ggplot(gait, aes(y=TUAG, x = Group)) +
  geom_violin() + theme_bw()
# Let's visualise this data
ggplot(gait, aes(y=TUAG, x = Group)) +
  geom_boxplot() + theme_bw()

