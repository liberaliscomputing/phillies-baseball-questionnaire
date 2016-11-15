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

**Reference**  
[1] What is WAR? (2016, November 14) Retrieved from [http://www.fangraphs.com/library/misc/war/](http://www.fangraphs.com/library/misc/war/)  
[logistic-curve]: https://github.com/liberaliscomputing/phillies-baseball-questionnaire/blob/master/figs/logistic-curve.png
## Candidate's Choice Question
**Q**.  
Predict each player’s batting average at the end of the 2016 season given his batting statistics in March/April 2016.

**A**.  
### Initial Exploration of Data
Before building a predictive model, we need to understand the characteristics of data such as data distribution, missing values, and outliers. It helps to build a more generalizable model. First, we read in the data set as batting.  
```r
# Read in data
batting <- read.csv('data/batting.csv')
```  
The result shows batting consists of 146 observations of 6 variables while 14 data points are corrupted (See Table 1). We can decide whether to ignore these observations, based on the exploration of data distribution.  
| Name | MarApr_AB | MarApr_PA | MarApr_H | MarApr_AVG | FullSeason_AVG |
| --- | ---: | ---: | ---: | ---: | ---: |
| Charlie Blackmon | 0 | 0 | 0 | NA | 0.324 |
| Jose Ramirez | 0 | 0 | 0 | NA | 0.312 |  
*Table 1. Example of corrupted data*

