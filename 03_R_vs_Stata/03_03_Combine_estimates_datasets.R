###############################################
# Combine estimates datasets from Stata and R #
###############################################

setwd("")

# Only results from models without errors are used for comparisons
R_results_s4 <- results %>%
  filter(!is.na(trt_a), !is.na(se_a))

# Export R estimates dataset for later analysis
write.csv(R_results_s4, "R_results_s4.csv", row.names = F)

# Import Stata dataset
Stata_results_s4 <- read.csv("Stata_results_s4.csv")

# Combine two datasets 
combined_s4 <- rbind(R_results_s4, Stata_results_s4)

# Export combined dataset
write.csv(combined_s4, "combined_s4.csv", row.names = F)