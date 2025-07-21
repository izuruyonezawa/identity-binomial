/* 
Presenting code for the descriptive analysis, modelling, and applying the diagnostic using the VIETNARMS dataset. This script reproduces Table 4 in the main paper.

The VIETNARMS trial data is publicly available. For details on access to the data, see:
Cooke GS, Hung LM, Flower B, McCabe L, Hang VTK, Thu VT, et al. Treatment options to support the elimination of hepatitis C: an open-label, factorial, randomised controlled non-inferiority trial. Lancet. 2025;405(10491):1769-80.
*/

cd ""
version 18

// use vietnarms.dta, clear

* Of 624 observations, screening HCV viral load and fibroscan result were missing for 62 and 9 cases, to which we applied mean imputation
sum fibroresult
replace fibroresult = r(mean) if fibroresult ==.
sum logscreenvl
replace logscreenvl = r(mean) if logscreenvl ==.

* The outcome was missing for 15 cases (2.4%); all the results presented were based on the 609 cases with outcome (cure 12 week after end of treatment) 
drop if svr12 ==.

************************
* Descriptive analysis *
************************
* Basic structure to generate a table
table () (reg) (),  stat(median fibroresult logscreenvl) stat(q1 fibroresult logscreenvl) stat(q3 fibroresult logscreenvl) stat(fvfrequency geno diabemell) stat(fvpercent geno diabemell)

    ** Re-coding columns
	collect recode result `"median"' = `"1"' `"q1"' = `"2"' `"q3"' = `"3"' ///
				`"fvfrequency"' = `"1"' `"fvpercent"' = `"2"' 
	collect layout (var) (reg#result[1 2 3])
		
	** Formatting contents
	collect style row stack, nobinder indent // get rid of the = signs
	collect style header result, level(hide) // hide the level results for results
	collect style header reg, title(hide) // hide 'reg'
	
	collect style cell var[geno diabemell]#result[2], nformat(%9.2f) sformat("(%s%%)")
	collect style cell var[geno diabemell]#result[3], nformat(%9.2f) sformat("(%s%%)")
	collect style cell var[fibroresult logscreenvl], nformat(%9.2fc)
	// put brackets and format decimal places

	collect style cell var[fibroresult logscreenvl]#result[2], sformat("(%s)")
	collect style cell var[fibroresult logscreenvl]#result[3], sformat("(%s)")
	// put brackets and format decimal places

	** Adding tabulations to header
	count if reg == 0
	global reg0 `: display %9.0fc `r(N)''
	display "$reg0"

	count if reg == 1
	global reg1 `: display %9.0fc `r(N)''
	display "$reg1"

	preserve
	contract reg, percent(p)
	global reg0_p = `:display %9.2fc p[1]'
	display "$reg0_p"

	global reg1_p = `:display %9.2fc p[2]'
	display "$reg1_p"
	restore

	** Generating a table for descriptive analysis
	collect label levels reg 0 "DCV [n=$reg0 ($reg0_p%)]" ///
	1 "VEL [n=$reg1 ($reg1_p%)]" , modify
	collect title "Table of Baseline Characteristics"
	collect preview
	
****************************************
* Modelling and applying the diagnostic *
****************************************
* Identity-binomial model with IRLS
capture noisily glm svr12 reg i.geno fibroresult logscreenvl diabemell, family(binomial) link(identity) irls asis iter(200) nolog
// Convergence not achieved

** Checking the diagnostic
local n_iter = e(ic)
di `n_iter'
// The number of iterations is 200 due to non-convergence
predict pv
sum pv
// The maximum predicted value is 1.038696 (> 0.999), which is diagnostic-positive


* Identity-binomial model with NR
capture noisily glm svr12 reg i.geno fibroresult logscreenvl diabemell, family(binomial) link(identity) asis iter(200) nolog
// Convergence not achieved
