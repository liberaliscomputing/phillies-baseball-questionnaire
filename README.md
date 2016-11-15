# Phillies Baseball R&D Questionnaire
This markdown document includes answers to the following questions:
+ Required Question on **deciding the promotion of a Minor League prospect to the Major League**
+ Candidate's Choice Question on **predicting batting average**

## Required Question
Q. 
As a member of the Research and Development team, how would you decide whether a Minor League prospect is ready to be promoted to the Majors? (Please limit your response to 250 words)
A.
Deciding the promotion of a Minor League player can be understood as a process of predicting the prospect’s success in the Major League. This process can be considered as a classification problem where the output is binary, meaning 1 is success. For this prediction, we can use logistic regression. The goal is to build a linear function, i.e. hypothesis function, so that the prospect would be classified to 1 when the hypothesis function returns greater than 0. For the hypothesis function, we can use Wins Above Replacement (WAR) as a dependent variable, considering following reasons. First, WAR is position-dependent, so we can build a classifier per position. Second, WAR is context-independent, meaning this metric can be used to compare players across years, leagues, and teams. Finally, WAR is continuous, ranging from negative to positive in such that the output of the hypothesis function would be. In addition, the 0 of WAR indicates no contribution; logistic regression returns 0.5 (meaning neither success nor failure) when the hypothesis function is 0. Independent variables would be corresponding variables in each type of WAR. In order to train this model, we need to sample those who have both WAR in the Majors and records in Triple-A (I exclude players promoted directly from Rookie Class, Single-As, and Double-A). If some players have several years of records in the Major League or Triple-A, we can average values while weighting by at-bats/innings (weighted average). Then, we use Triple-A statistics as independent variables and WAR as a dependent variable for training. Physique and age can also be used as predictors. Finally, this model is tested with a group of prospects to decide where to call them up.
## Candidate's Choice Question
Q. 
Predict each player’s batting average at the end of the 2016 season given his batting statistics in March/April 2016.
A.
TBA
