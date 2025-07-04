###################################################################
# Simulation for scenario 4 using 1,000 datasets created in Stata #
###################################################################

# Load relevant libraries
library(foreach) # for using foreach loop
library(dplyr) # To transform list of data frame in single data frame
library(rsimsum) # For computing performance measures with MCSE
library(margins)
library(ggplot2)

setwd("")

# Treat warning as error
options(warn = 2)

results <- foreach( i = 1:1000, .combine = rbind) %do% {  
    file_name <- paste0("simdata_s4_", i, ".csv")
    simdata <- read.csv(file_name)
    
    fit.bi<-try(glm(y~trt+cov, family=binomial(link="identity"), data=simdata, control = glm.control(maxit = 200)))
    if (!inherits(fit.bi, "try-error")) {
        predicted <- predict(fit.bi)
        res<-data.frame(
            rep = i,
            est = coef(fit.bi)["trt"],
            se = coef(summary(fit.bi))["trt",2],
            N = nobs(fit.bi),
            error = NA,
            method = "R",
            n_iter = fit.bi$iter,
            max = max(predicted),
            row.names = NULL)
    } else {
        res<-data.frame(
            rep = i,
            est = NA,
            se = NA,
            N = NA,
            error = attr(fit.bi, "condition")$message,
            method = "R",
            n_iter = NA,
            max = NA,
            row.names = NULL)
    }
    cat(".")
    if (i%%50==0) cat("\n")
                     
    colnames(res) <- c( "rep", "trt_a", "se_a", "N", "errors", "method", "n_iter", "max")
    res

}

# Tabulate error types
table(results$error, useNA = "always")
## Mostly convergence issues (similar to the results from Stata)

# Evaluate estimates dataset using simsum
s <- simsum(data = results, estvarname = "trt_a", true = 0, se = "se_a")
summary(s)
## Undercoverage of 73% is observed (similar to the results from Stata)