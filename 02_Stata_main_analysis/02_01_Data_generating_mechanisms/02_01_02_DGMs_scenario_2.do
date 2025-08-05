/* 
Presenting programs for data-generating mechanism (DGMs) with varying parameters in scenario 2 as presented in Table 3 in the main paper
*/

cd ""
version 18

******************************************
* DGMs in scenario 2 (covariate effects) *
******************************************

prog drop _all

program define gendata, rclass
version 18 
syntax [ , ///
        obs(int 624) ///
        rd(real 0.00) ] 
		// obs and rd are sample size and treatment effect, respectively, specified later in simulations
    clear
	
	* Set sample size
    set obs `obs'
	// `obs' is either 624 or 1248
	
	* Prognostic binary covariate `cov' has a 0.5/0.5 split
	generate byte cov = rbinomial(1, 0.5)  
    assert inlist(cov,0,1) 
	
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
	
	* Treatment allocation is 1:1
    generate byte trt = rbinomial(1, 0.5)  
    assert inlist(trt,0,1)  
	
	* No treatment effect; outcome probability is the same in both arms
	** Prognostic binary covariate cov has effect size q on risk difference scale
	** Outcome probability in each arm: π - q/2 if cov = 0, π + q/2 if cov = 1
	** As cov is balanced 0.5/0.5, overall outcome probability is π
    generate byte y = rbinomial(1, (π-q/2)+q*cov) if trt==0 
    replace y = rbinomial(1, (π-q/2)+q*cov) if trt==1 
    assert inlist(y,0,1) 
	// π is either 0.95 or 0.80
	// q is varied from 0 to 0.08 in 0.02 increments
	
end
