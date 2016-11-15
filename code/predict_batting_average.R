# Candidate’s Choice Question 
#   for the Senior Quantitative Analyst Position at Philadelphia Phillies
# Submission: November 15, 2016
# Candidate: Meen Chul Kim

# Read in data
batting <- read.csv('data/batting.csv')

# Select rows without corrupted data
data <- subset(batting, MarApr_AB != 0)

# Histogram the distributions
hist(data$MarApr_AB, prob=T, 
     xlab='MarApr_AB', ylab = 'Probatilty')
lines(density(data$MarApr_AB))


data <- subset(batting, MarApr_AB != 0)

MarApr.AB <- data[2] / max(range(data[2]))
MarApr.PA <- data[3] / max(range(data[3]))
MarApr.H <- data[4] / max(range(data[4]))
new <- data.frame(data[1], MarApr.AB, MarApr.PA, MarApr.H, data[5], data[6])
plot(new[2:6])
