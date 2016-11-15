# Phillies Baseball R&D Questionnaire
This markdown document includes answers to the following questions:
+ Required Question on **deciding the promotion of a Minor League prospect to the Major League**
+ Candidate's Choice Question on **predicting batting average**

## Required Question
**Q**.  
As a member of the Research and Development team, how would you decide whether a Minor League prospect is ready to be promoted to the Majors? (Please limit your response to 250 words)

**A**.  
Deciding the promotion of a Minor League player can be understood as **a process of predicting the prospect’s success** in the Major League. This process can be considered as **a classification problem** where the output is binary, meaning 1 is success. For this prediction, we can use **logistic regression**. The goal is to build a linear function, *i.e.* **hypothesis function**, so that the prospect would be classified to 1 when the hypothesis function returns greater than 0 (See Figure 1). For the hypothesis function, we can use **Wins Above Replacement (WAR)** [1] as a dependent variable, considering following reasons. First, WAR is **position-dependent**, so we can build a classifier per position. Second, WAR is **context-independent**, meaning this metric can be used to compare players across years, leagues, and teams. Finally, WAR is **continuous**, ranging from negative to positive in such that the output of the hypothesis function would be. In addition, **the 0 of WAR indicates no contribution; logistic regression returns 0.5 (meaning neither success nor failure) when the hypothesis function is 0**. Independent predictors correspond to variables used in each type of WAR. In order to train this model, we need to sample MLB players who have both WAR in the Majors and records in Triple-A (excluding players promoted directly from Rookie Class, Single-As, and Double-A). If some players have several years of records in the Major League or Triple-A, we can average values while weighting by at-bats/innings (**weighted average**). Then, we use Triple-A statistics as independent variables and WAR as a dependent variable for training. Physique and age can also be used as predictors. Finally, given **Triple-A statistics of prospects** (test set), this model calculates **estimated WAR to decide where to call them up**.  
![alt text][logistic-curve]  
*Figure 1. Logistic regression of MLB promotion*  
## Candidate's Choice Question
**Q**.  
Predict each player’s batting average at the end of the 2016 season given his batting statistics in March/April 2016.

**A**.  
### Initial Exploration of Data
Before building a predictive model, we need to understand the characteristics of data such as data distribution, missing values, and outliers. It helps to build a more generalizable model. First, we read in the data set as **batting**.
```r
# Read in data
batting <- read.csv('data/batting.csv')
```  
The result shows **batting** consists of 146 observations of 6 variables while 14 data points are corrupted. The last column **FullSeason_AVG** will be used a dependent variable. We will decide whether to ignore the corrupted observations, based on the exploration of data distribution. To investigate data further, we need to copy **batting** to a new data frame called **data** by only selecting rows without corrupted data.  
```r
# Select rows without corrupted data
data <- subset(batting, MarApr_AB != 0)
```  
### Predictor Scaling
Before examining the distribution of data, we need to rescale the data. The data set consists of two kinds of variables: 1) discrete variables and 2) continuous variables. **MarApr_AB**, **MarApr_PA**, and **MarApr_H** are **discrete** predictors counting up the frequency of measures whereas **MarApr_AVG** and **FullSeason_AVG** are **continuous** probabilities. If variables are on different scales, the power of a predictive model weakens, allowing high variance. To address this issue, we need to make the predictors get on a similar scale. The simplest way of variable rescaling is **to divide by range**.
```r
# Scale variables by dividing by range
data$MarApr_AB <- data$MarApr_AB / max(range(data$MarApr_AB))
data$MarApr_PA <- data$MarApr_PA / max(range(data$MarApr_PA))
data$MarApr_H  <- data$MarApr_H  / max(range(data$MarApr_H))
```
### Data Imputation
To impute corrupted data, we need to understand the distribution of data. If it is skewed, we can impute **median** to corrupted cells. If normally distributed, the **mean** imputation is the intuitive way. 
```r
# Histogram the distributions
hist(data$column_name, prob=T, xlab='column_name', ylab = 'Probatilty')
lines(density(data$column_name))
```  
![alt text][hist-ab]  
*Figure 2. Normal distribution of MarApr_AB*  
As shown in Figure 2, the variable **player's at bats in March and April 2016** is **normally distributed**. Other predictors also follow the normal distribution. Therefore, we impute means to corrupted values.
```r
# Convert corruted data to NA
batting[batting == 0] <- NA

# Scale variables
batting$MarApr_AB <- batting$MarApr_AB / 
  max(range(batting$MarApr_AB, na.rm = T)) 
batting$MarApr_PA <- batting$MarApr_PA / 
  max(range(batting$MarApr_PA, na.rm = T)) 
batting$MarApr_H  <- batting$MarApr_H  / 
  max(range(batting$MarApr_H , na.rm = T)) 

# Impute means to NA
batting$MarApr_AB[is.na(batting$MarApr_AB)] <- 
  mean(batting$MarApr_AB, na.rm = T)
batting$MarApr_PA[is.na(batting$MarApr_PA)] <- 
  mean(batting$MarApr_PA, na.rm = T)
batting$MarApr_H[is.na(batting$MarApr_H)] <- 
  mean(batting$MarApr_H, na.rm = T)
batting$MarApr_AVG[is.na(batting$MarApr_AVG)] <- 
  mean(batting$MarApr_AVG, na.rm = T)
```  
###


##References  
[1] What is WAR? (2016, November 14) Retrieved from [http://www.fangraphs.com/library/misc/war/](http://www.fangraphs.com/library/misc/war/)  
[logistic-curve]: https://github.com/liberaliscomputing/phillies-baseball-questionnaire/blob/master/figs/logistic-curve.png
[hist-ab]: https://github.com/liberaliscomputing/phillies-baseball-questionnaire/blob/master/figs/hist-ab.png

