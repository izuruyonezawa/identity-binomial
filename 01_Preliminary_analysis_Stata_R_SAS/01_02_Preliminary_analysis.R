#######################################################
# Preliminary analysis using two simple datasets in R #
#######################################################

##################
# 1. Dataset (a) #
##################
arm <- c(rep("A", 100), rep("B", 100))         
outcome <- c(rep(1, 100), c(rep(1, 90), rep(0, 10)))  
data <- data.frame(Arm = arm, Outcome = outcome)

# Inspect the dataset
table(data$Arm, data$Outcome)
## 100% for arm A, 90% for arm B

# Fit a GLM with binomial distribution and identity link
model <- glm(Outcome ~ Arm, family = binomial(link = "identity"), data = data)

# Summary of the model
summary(model)
## Correct estimation of treatment effect (-0.1)

##################
# 2. Dataset (b) #
##################
data <- data.frame(
  cov = c(0, 0, 1, 1),
  randtrt = c(0, 1, 0, 1),
  ntot = c(100, 100, 100, 100),
  n1 = c(90, 94, 100, 100)
)

# Generate `n0` and drop `ntot`
data$n0 <- data$ntot - data$n1
data$ntot <- NULL  # Drop `ntot`

## install.packages("tidyr")
library(tidyr)

# Reshape the dataset to long format
data_long <- pivot_longer(
  data,
  cols = c(n1, n0),
  names_to = "outcome",
  names_prefix = "n",
  values_to = "n"
)

# Convert `outcome` to numeric
data_long$outcome <- as.numeric(data_long$outcome)

# Fit GLM with binomial distribution and identity link
model <- glm(outcome ~ randtrt + cov, 
             family = binomial(link = "identity"), 
             data = data_long, 
             weights = n)  

# Summary of the model
summary(model)
## It gives "Error: no valid set of coefficients has been found: please supply starting values"
