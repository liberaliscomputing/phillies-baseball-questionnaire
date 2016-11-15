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
cols <- c('MarApr_AB', 'MarApr_PA', 'MarApr_H')
for (col in cols) {
  data[[col]] <- data[[col]] / max(range(data[[col]]))  
}
```
### Data Imputation
To fix corrupted data, we need to understand the distribution of data. If it is skewed, we can impute **median** to corrupted cells. If normally distributed, the **mean** imputation is the most intuitive way. 
```r
# Histogram the distributions
hist(data$MarApr_AB, prob=T, xlim=c(1, 3), 
     xlab='Scaled predictors', ylab = 'Probatilty', main='',
     col=rgb(1, 0, 0, .25))
lines(density(data$MarApr_AB))
hist(data$MarApr_PA, add=T, prob=T, col=rgb(0, 1, 0, .25))
lines(density(data$MarApr_PA))
```  
![alt text][hist-ab]  
*Figure 2. Normal distribution of MarApr_AB and MarApr_PA*  
As shown in Figure 2, the variable **player's at bats in March and April 2016** is **normally distributed**. Other predictors also follow the normal distribution. Therefore, we impute means to corrupted values.
```r
# Convert corruted data to NA
batting[batting == 0] <- NA

# Scale variables
for (col in cols) {
  batting[[col]] <- batting[[col]] / 
    diff(range(batting[[col]], na.rm = T))
}

# Impute means to NA
for (col in cols) {
  batting[[col]][is.na(batting[[col]])] <- 
    mean(batting[[col]], na.rm = T)
}

# Manual imputation for MarApr_AVG
batting$MarApr_AVG[is.na(batting$MarApr_AVG)] <- 
  mean(batting$MarApr_AVG, na.rm = T)
```  
### Multivariate Linear Regression
Now, we build a predictive model with rescaled and imputed data points. Multivariate linear regression is used as follows.  
```r  
# Multivariate linear regression  
model.1 <- lm(FullSeason_AVG ~ 
            MarApr_AB + 
            MarApr_PA + 
            MarApr_H + 
            MarApr_AVG, 
          data)
# Results  
Coefficients:
            Estimate Std. Error t value Pr(>|t|)  
(Intercept) 1.70e-01   9.83e-02    1.73    0.086 .
MarApr_AB   3.38e-04   1.29e-03    0.26    0.794  
MarApr_PA   6.94e-05   4.33e-04    0.16    0.873  
MarApr_H    6.83e-04   4.47e-03    0.15    0.879  
MarApr_AVG  1.94e-01   3.67e-01    0.53    0.597  
---
Signif. codes:  0 ‘***’ 0.001 ‘**’ 0.01 ‘*’ 0.05 ‘.’ 0.1 ‘ ’ 1

Residual standard error: 0.0237 on 127 degrees of freedom
Multiple R-squared:  0.249,	Adjusted R-squared:  0.226 
F-statistic: 10.5 on 4 and 127 DF,  p-value: 2.08e-07

```  

##References  
[1] What is WAR? (2016, November 14) Retrieved from [http://www.fangraphs.com/library/misc/war/](http://www.fangraphs.com/library/misc/war/)  
[logistic-curve]: https://github.com/liberaliscomputing/phillies-baseball-questionnaire/blob/master/figs/logistic-curve.png
[hist-ab]: https://github.com/liberaliscomputing/phillies-baseball-questionnaire/blob/master/figs/hist-ab.png

