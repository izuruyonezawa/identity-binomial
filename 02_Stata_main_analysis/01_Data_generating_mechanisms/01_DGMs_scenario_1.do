/* 
Presenting programs for data-generating mechanism (DGMs) with varying parameters in scenario 1 as presented in Table 3 in the main paper
*/

cd ""
version 18

**************************************
* DGMs in scenario 1 (data sparsity) *
**************************************

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
	// `obs' either 624 or 1248
	
	* Non-prognostic binary covariate `cov' has a (1-p)/p split, where p is the smaller group
	generate byte cov = rbinomial(1, p)  
	assert inlist(cov,0,1) 
	// p is varied from 0.05 to 0.5 in 0.05 increments
	
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
	
	* Treatment allocation is 1:1
    generate byte trt = rbinomial(1, 0.5)  
    assert inlist(trt,0,1)  
	
	* No treatment effect; outcome probability π is the same in both arms
    generate byte y = rbinomial(1, π) if trt==0 
    replace y = rbinomial(1, π) if trt==1 
    assert inlist(y,0,1) 
	// π is either 0.95 or 0.80
	
end
