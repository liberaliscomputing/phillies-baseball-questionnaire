# Candidate’s Choice Question 
#   for the Senior Quantitative Analyst Position at Philadelphia Phillies
# Submission: November 15, 2016
# Candidate: Meen Chul Kim

# Read in data
batting <- read.csv('data/batting.csv')

# Select rows without corrupted data
data <- subset(batting, MarApr_AB != 0)

# Scale variables by dividing by range
data$MarApr_AB <- data$MarApr_AB / max(range(data$MarApr_AB))
data$MarApr_PA <- data$MarApr_PA / max(range(data$MarApr_PA))
data$MarApr_H  <- data$MarApr_H  / max(range(data$MarApr_H))

# Histogram the distributions
hist(data$MarApr_AB, prob=T, 
     xlab='MarApr_AB', ylab = 'Probatilty', main='')
lines(density(data$MarApr_AB))

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
