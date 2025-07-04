/* 
Presenting example simulation code to produce an estimates dataset for scenario 1 (data sparsity) 
DGM: base DGM with the most extreme parameter value (the binary covariate with 0.95/0.05 split)
Model: Identity-binomial model with IRLS, adjusted for one binary covariate
*/

cd ""
version 18

****************************
* Program to generate data *
****************************
prog drop _all

program define gendata, rclass
version 18 
syntax [ , ///
        obs(int 624) ///
        rd(real 0.00) ] 

    clear
    set obs `obs'
	
	* Non-prognostic binary covariate `cov' has a 0.95/0.05 split
	generate byte cov = rbinomial(1, 0.05)  
    assert inlist(cov,0,1) 
	
    /*
	The following covariates are not used in this simulation
	
	* Non-prognostic categorical variables `cov2' with four equally-sized subgroups
	gen double shuffle = runiform()
	gen cov2 = 0 if shuffle <0.25
	replace cov2  = 1 if shuffle >=0.25 & shuffle < 0.5
	replace cov2  = 2 if shuffle >=0.5 & shuffle < 0.75
	replace cov2  = 3 if shuffle >=0.75 
	assert inlist(cov2,0,1,2,3)
	
	* Non-prognostic categorical variables `cov3' with six equally-sized subgroups
	gen double shuffle2 = runiform()
	gen cov3 = 0 if shuffle2 < 0.167
	replace cov3  = 1 if shuffle2 >=0.167 & shuffle2 < 0.333
	replace cov3  = 2 if shuffle2 >= 0.333 & shuffle2 < 0.5
	replace cov3  = 3 if shuffle2 >=0.5 & shuffle2 < 0.667
	replace cov3  = 4 if shuffle2 >= 0.667 & shuffle2 < 0.833
	replace cov3  = 5 if shuffle2 >= 0.833 
	assert inlist(cov3,0,1,2,3,4,5)
	
	* Non-prognostic beta-distributed continuous variable, mimicking age
	generate int age = 18 + 62*rbeta(4,4)
	assert age >= 18 & age <= 80
	
	* Non-prognostic beta-distributed continuous variable, mimicking BMI
	generate float bmi = 16 + 24*rbeta(4,10)
	assert bmi >= 16 & bmi <= 40
   	*/
	
	* Treatment allocation is 1:1
    generate byte trt = rbinomial(1, 0.5)  
    assert inlist(trt,0,1) 
	
	* No treatment effect; outcome probability 0.95 is the same in both arms
    generate byte y = rbinomial(1, 0.95) if trt==0 
    replace y = rbinomial(1, 0.95) if trt==1 
    assert inlist(y,0,1) 
	
end


***************************
* Program to analyse data * 
***************************
// This program returns estimates, including predicted values, and number of iterations to evaluate model performance and develop diagnostics

program define anadata, rclass
	version 18
	syntax, [rep(int 1) post(string)]
		
    * Identity-binomial model without covariate adjustment
	capture noisily glm y trt, family(binomial) link(identity) irls asis nolog
	local trt_u = _b[trt] // treatment effect
	local se_u = _se[trt] // SE for treatment effect
	
	* Identity-binomial model, adjusting for a binary covariate
	capture noisily glm y trt cov, family(binomial) link(identity) irls asis nolog iter(200)
	// For optimisation method, 'ml' was also used instead of 'irls'
	// Additional covariates were also added stepwise, as specified in the main paper	
	** Error and parameters
	local errors = _rc // error type
	local N = e(N) // sample size
	local n_iter = e(ic) // Number of iterations
	** Estimates
	local trt_a = _b[trt] // treatment effect
	local se_a = _se[trt] // SE for treatment effect
	** Predicted values for each stratum
	predict lp
    sum lp if trt == 0 & cov==0
	local t0b0 = r(mean)
    sum lp if trt == 1 & cov==0
	local t1b0 = r(mean)
    sum lp if trt == 0 & cov==1
	local t0b1 = r(mean)
    sum lp if trt == 1 & cov==1 
	local t1b1 = r(mean)
	** Maximum predicted value
	sum lp
	local max = r(max)
	
	* Standardisation (used as a benchmark)
	logistic y i.trt i.cov, asis // logistic regression with the same covariate adjustment
	margins r.trt // standardisation
	** Estimates
	local trt_stan = r(table)[1,1] // treatment effect estimate
	local se_stan = r(table)[2,1] // SE for treatment effect
	** Predicted values for each stratum
	predict lp_2
    sum lp_2 if trt == 0 & cov==0
	local t0b0_s = r(mean)
    sum lp_2 if trt == 1 & cov==0
	local t1b0_s = r(mean)
    sum lp_2 if trt == 0 & cov==1
	local t0b1_s = r(mean)
    sum lp_2 if trt == 1 & cov==1 
	local t1b1_s = r(mean)

	* Post everything 
	if !mi("`post'") post `post' (`rep') (`trt_u') (`se_u') (`errors') (`N') (`n_iter') (`trt_a') (`se_a') (`t0b0') (`t1b0') (`t0b1') (`t1b1') (`max') (`trt_stan') (`se_stan') (`t0b0_s') (`t1b0_s') (`t0b1_s') (`t1b1_s')
end
   
************
* Set seed *
************
set rngstream 1
set seed 7567405
capture postclose simcheck_s1_base
capture postclose rngstates_s1_base

*******************************
* Run simulations (1000 reps) *
*******************************
local reps 1000
local repsplus1 = `reps'+1
postfile simcheck_s1_base int(rep) float(trt_u se_u) int(errors N n_iter) float(trt_a se_a t0b0 t1b0 t0b1 t1b1 max trt_stan se_stan t0b0_s t1b0_s t0b1_s t1b1_s) using simcheck_s1_base_postfile, replace
postfile rngstates_s1_base int(rep) str2000(rngstate1 rngstate2 rngstate3)  ///
	using rngstates_s1_base_postfile, replace

forvalues i=1/`repsplus1' {
	if `i'==1 _dots 0 , title("Simulation running (`reps' repetitions)")
	_dots `i' 0
	
	local rngstate1 = substr(c(rngstate),1,2000)
	local rngstate2 = substr(c(rngstate),2001,2000)
	local rngstate3 = substr(c(rngstate),4001,.)
	post rngstates_s1_base (`i') ("`rngstate1'") ("`rngstate2'") ("`rngstate3'")
	
	if `i'>`reps' continue, break
	
	di as input "Generating data..."
	gendata, obs(624) rd(0.00)
	
	di as input "Analysing data..."
	anadata, rep(`i') post(simcheck_s1_base)
}

postclose simcheck_s1_base
postclose rngstates_s1_base
