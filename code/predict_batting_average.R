# Candidate’s Choice Question 
#   for the Senior Quantitative Analyst Position at Philadelphia Phillies
# Submission: November 15, 2016
# Candidate: Meen Chul Kim

library('ggplot2')
library('caret')

# Read in data
batting <- read.csv('data/batting.csv')

# Select rows without corrupted data
data <- subset(batting, MarApr_AB != 0)

# Scale variables by dividing by range
cols <- c('MarApr_AB', 'MarApr_PA', 'MarApr_H')
for (col in cols) {
  data[[col]] <- data[[col]] / diff(range(data[[col]]))  
}


# Histogram the distributions of MarApr_AB and MarApr_PA
hist(data$MarApr_AB, prob=T, xlim=c(1, 3), 
     xlab='Scaled predictors', ylab = 'Probatilty', main='',
     col=rgb(1, 0, 0, .25))
lines(density(data$MarApr_AB))
hist(data$MarApr_PA, add=T, prob=T, col=rgb(0, 1, 0, .25))
lines(density(data$MarApr_PA))

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

# Multivariate linear regression
model.1 <- lm(FullSeason_AVG ~ 
            MarApr_AB + 
            MarApr_PA + 
            MarApr_H + 
            MarApr_AVG,
          batting)
summary(model.1)

# Diagnostic plots 
layout(matrix(c(1, 2, 3, 4), 2, 2)) 
plot(model.1)
# Plot correlation
plot(batting[2:6])

# Remodel linear regression
model.2 <- lm(FullSeason_AVG ~ MarApr_H + MarApr_AVG, batting)
summary(model.2)

