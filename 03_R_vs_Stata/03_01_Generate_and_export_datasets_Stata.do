/* 
1. Generating and exporting 1,000 simulated datasets from the base DGM with the largest interaction in scenario 4 for analysis in R
2. Exporting the estimates dataset from Stata for later comparison with results from R
*/

cd ""
version 18

* 1. Generating and exporting 1,000 simulated datasets
************************************************
* Program to generate data for each repetition *
************************************************

prog drop _all

program define gendata, rclass
version 18 
syntax [ , ///
        obs(int 624) ///
        rd(real 0.00) ///
		rep(int 1) ///
		post(string)]
    clear
    set obs `obs'
	
    * Non-prognostic binary covariate `cov' has a 0.5/0.5 split
	generate byte cov = rbinomial(1, 0.5)  
    assert inlist(cov,0,1) 
	
    /*
	The following covariates are not used in this simulation
	
	* Non-prognostic categorical variable `cov2' with four equally-sized subgroups
	gen double shuffle = runiform()
	gen cov2 = 0 if shuffle <0.25
	replace cov2  = 1 if shuffle >=0.25 & shuffle < 0.5
	replace cov2  = 2 if shuffle >=0.5 & shuffle < 0.75
	replace cov2  = 3 if shuffle >=0.75 
	assert inlist(cov2,0,1,2,3)
	
	* Non-prognostic categorical variable `cov3' with six equally-sized subgroups
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
	
	* Treatment effects are specified for each stratum to specify interactions
    generate byte y = rbinomial(1, 0.91) if trt==1 & cov == 0
    replace y = rbinomial(1, 0.99) if trt==1 & cov == 1 
	replace y = rbinomial(1, 0.99) if trt==0 & cov == 0
	replace y = rbinomial(1, 0.91) if trt==0 & cov == 1
    assert inlist(y,0,1)
	
	* Each observation needs to be posted later
	local reps `obs'
    local repsplus1 = `reps'+1
	forvalues i=1/`repsplus1' {
	if !mi("`post'") post `post' (`i') (cov) (trt) (y)
	if `i'>`reps' continue, break
	}
end

*************************************************
* Program to generate data for 1,000 repetition *
*************************************************
// Embed the previous program within this program

* Set seed 
set rngstream 1
set seed 7567405

local reps 1000
local repsplus1 = `reps'+1

forvalues i=1/`repsplus1' {
capture postclose simcheck_simdata_s4_`i'
capture postclose rngstates_simdata_s4_`i'

postfile simcheck_simdata_s4_`i' int(obs) byte(cov trt y) using simcheck_simdata_s4_`i'_postfile, replace

postfile rngstates_simdata_s4_`i' int(rep) str2000(rngstate1 rngstate2 rngstate3)  ///
	using rngstates_simdata_s4_`i'_postfile, replace

	if `i'==1 _dots 0 , title("Simulation running (`reps' repetitions)")
	_dots `i' 0
	
	local rngstate1 = substr(c(rngstate),1,2000)
	local rngstate2 = substr(c(rngstate),2001,2000)
	local rngstate3 = substr(c(rngstate),4001,.)
	post rngstates_simdata_s4_`i' (`i') ("`rngstate1'") ("`rngstate2'") ("`rngstate3'")
	
	if `i'>`reps' continue, break
	
	di as input "Generating data..."
	gendata, obs(624) rd(0.00) rep(`i') 
	
	forvalues j = 1/624 {
        post simcheck_simdata_s4_`i' (`j') (cov[`j']) (trt[`j']) (y[`j'])
    }


postclose simcheck_simdata_s4_`i'
postclose rngstates_simdata_s4_`i'
}

*************************************
* Export 1,000 datasets as csv file *
*************************************
forvalues i = 1/1000 {
	use simcheck_simdata_s4_`i'_postfile.dta, replace
	export delimited using simdata_s4_`i'.csv, replace
}


* 2. Exporting estimates dataset from Stata
use simcheck_s4_base_08_postfile, clear

* Export estimates dataset to combine estimates datasets in R
// Only results from models without errors are used for later comparisons
drop if errors == 430
gen method = "Stata"
export delimited rep trt_a se_a N errors method n_iter max using Stata_results_s4.csv, replace
