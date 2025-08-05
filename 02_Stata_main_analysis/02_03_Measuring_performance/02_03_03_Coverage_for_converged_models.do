/*
Measuring coverage conditional on convergence after producing estimates datasets
*/

cd ""
version 18

* Package used:
// net from https://raw.githubusercontent.com/UCL/siman/dev/

* Use estimates dataset produced in the previous step
** Here, the one produced for scenario 1 is used
use simcheck_s1_base_postfile, clear

* Estimate coverage for converged identity-binomial models using 'siman' package 

** The following line will install the package
// net from https://raw.githubusercontent.com/UCL/siman/dev/

****************************
* Identity-binomial models *
****************************
preserve
drop if errors==430 
// Using only a subset of models that converged
siman setup, true(0.00) est(trt_a) se(se_a) rep(rep)
siman analyse
siman zipplot, bygr(note("")) ///
	coveropt(lcol("153 153 153")) noncoveropt(lcol("213 94 0")) ///
	xtitle(,size(medium)) ytitle(,size(medium)) ///
	xlabel(,labsize(medium)) ylabel(,labsize(medium)) ///
	legend(size(medium)) subtitle(,size(large)) ///
	xsize(7) ysize(5) subtitle(,just(center)) ///
	title(Identity-binomial models, size(medium))
restore

** Calculate confidence interval using outputs from siman, including point estimate for coverage, its Monte Carlo error, and number of models used
*** Lower bound ***
di 84.80885 - invttail(994-1,0.025)*1.138473
*** Upper bound ***
di 84.80885 + invttail(994-1,0.025)*1.138473

** How coverage is affected is visually shown in zip plot (Fig. S6)

 
* Estimate coverage for standardisation using the same repetitions

*******************
* Standardisation *
*******************
preserve
drop if errors==430 
// Using only a subset of repetitions with which identity-binomial models converged
siman setup, true(0.00) est(trt_stan) se(se_stan) rep(rep)
siman analyse
siman zipplot, bygr(note("")) ///
	coveropt(lcol("153 153 153")) noncoveropt(lcol("213 94 0")) ///
	xtitle(,size(medium)) ytitle(,size(medium)) ///
	xlabel(,labsize(medium)) ylabel(,labsize(medium)) ///
	legend(size(medium)) subtitle(,size(large)) ///
	xsize(7) ysize(5) subtitle(,just(center)) ///
	title(Standardisation, size(medium))
restore

** Calculate confidence interval using outputs from siman, including point estimate for coverage, its Monte Carlo error, and number of models used
*** Lower bound ***
di 95.17103 - invttail(994-1,0.025)*.679965
*** Upper bound ***
di 95.17103 + invttail(994-1,0.025)*.679965

