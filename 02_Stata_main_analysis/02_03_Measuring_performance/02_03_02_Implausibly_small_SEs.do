/*
Measuring rates of implausibly small standard errors after producing estimates datasets
*/

cd ""
version 18

* Package used:
// net from https://raw.githubusercontent.com/UCL/siman/dev/

* Use estimates dataset produced in the previous step
** Here, the one produced for scenario 1 is used
use simcheck_s1_base_postfile, clear

* Firstly, estimate empirical SE using 'siman' package 

** Use siman
*** estimate empirical SE and draw zip plot to visually check small SEs
preserve
siman setup, true(0.00) est(trt_a) se(se_a) rep(rep)
siman analyse
siman zipplot, bygr(note("")) ///
    coveropt(lcol("153 153 153")) noncoveropt(lcol("213 94 0")) ///
	xtitle(,size(medium)) ytitle(,size(medium)) ///
	xlabel(,labsize(medium)) ylabel(,labsize(medium)) ///
	legend(size(medium)) subtitle(,size(large)) ///
	xsize(7) ysize(5) subtitle(,just(center)) ///
	title(, size(medium))
restore

// Empirical SE, empse, is estimated using all repetitions
// Here, empse is .0173119
// We can visually check if there are unreasonably small SEs in zip plot


* Secondly, create a variable for the model SE relative to empirical SE
gen m_to_e = se_a/.0173119

** Create a histogram to visually check the distribution among converged models (equivalent to Fig. S2)
preserve
drop if errors != 0
hist m_to_e, xlab(0(0.1)1.5, angle(45)) bins(40) freq bcolor("0 114 178") xline(0.1, lcolor("213 94 0") lpattern(dash)) xtitle(Model SE relative to empirical SE)
restore

* Thirdly, produce a variable for implausibly small SEs, defined as model SE relative to empirical SE < 0.1
gen iss = 1 if m_to_e < 0.1
replace iss = 0 if iss ==.
** Tabulate
tab iss,m

* Finally, estimate rate of implausibly small SEs with confidence interval among converged models
ci proportions iss if errors == 0  
