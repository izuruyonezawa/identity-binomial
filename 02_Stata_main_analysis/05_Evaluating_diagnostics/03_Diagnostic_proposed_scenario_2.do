/* 
Evaluating conditional coverage for diagnostic negative and positive models using the proposed diagnostic, with standardisation as a benchmark (relevant to Figs. 5, S25, and S28)
This script uses an estimates dataset from a base DGM in scenario 2 as an example
*/

cd ""
version 18

* Package used:
// net from https://raw.githubusercontent.com/UCL/siman/dev/

use simcheck_s2_base_postfile, clear

****************************
* Identity-binomial models *
****************************
*** Diagnostic negatives ***
preserve
drop if errors==430 | max > 0.999 | (max <= 0.999 & max > 0.96 & n_iter > 10)
siman setup, true(0.00) est(trt_a) se(se_a) rep(rep)
siman analyse
siman zipplot, bygr(note("")) ///
	coveropt(lcol("153 153 153")) noncoveropt(lcol("213 94 0")) ///
	xtitle("",size(medium)) ytitle("",size(medium)) ///
	xlabel(-0.1(0.05)0.1,labsize(3)) ylabel(,labsize(3)) ///
	xsize(7) ysize(5) subtitle(Negative (N = 578),just(center) size(3)) ///
	truegraphoptions(lcol("0 0 0"))  ///
	title(Identity-binomial, size(4))
restore

* Confidence interval estimation for diagnostic negatives
** As coverage is very close to 1, normal approximation can be inaccurate
** In this case, the following strategy can be used

/*
** Program to analyse data at the simulation stage can include:
    capture noisily glm y trt cov, family(binomial) link(identity) irls asis nolog iter(200)
	local lci_ib = r(table)[5,1] // Lower bound of confidence interval
	local uci_ib = r(table)[6,1] // Upper bound of confidence interval

** Generate variables for true value and coverage:
	gen true = 0
	gen byte coverstrue_ib = inrange(true, lci_ib, uci_ib)

** Estimate coverage for diagnostic negatives using ci proportions:
	preserve
	drop if errors==430 | max > 0.999 | (max <= 0.999 & max > 0.96 & n_iter > 10)
	ci proportions coverstrue_ib
	restore
*/

*** Diagnostic positives ***
preserve
drop if errors==430 | max <= 0.96 | (max <= 0.999 & max > 0.96 & n_iter <= 10)
siman setup, true(0.00) est(trt_a) se(se_a) rep(rep)
siman analyse
siman zipplot, bygr(note("")) ///
	coveropt(lcol("153 153 153")) noncoveropt(lcol("213 94 0")) ///
	xtitle("",size(medium)) ytitle("",size(medium)) ///
	xlabel(-0.1(0.05)0.1,labsize(3)) ylabel(0 10 50 90 100,labsize(3)) ///
	xsize(7) ysize(5) subtitle(Positive (N = 418),just(center) size(3)) ///
	truegraphoptions(lcol("0 0 0"))  ///
	title(Identity-binomial, size(4))
restore

* Calculate confidence interval for diagnostic positives using outputs from siman, including point estimate for coverage, its Monte Carlo error, and number of models
*** Lower bound ***
di 67.94258 - invttail(418-1,0.025)*2.282691
*** Upper bound ***
di 67.94258 + invttail(418-1,0.025)*2.282691


*******************
* Standardisation *
*******************
*** Diagnostic negative repetitions ***
preserve
drop if errors==430 | max > 0.999 | (max <= 0.999 & max > 0.96 & n_iter > 10)
siman setup, true(0.00) est(trt_stan) se(se_stan) rep(rep)
siman analyse
siman zipplot, bygr(note("")) ///
	coveropt(lcol("153 153 153")) noncoveropt(lcol("213 94 0")) ///
	xtitle("",size(medium)) ytitle("",size(medium)) ///
	xlabel(-0.1(0.05)0.1,labsize(3)) ylabel(,labsize(3)) ///
	xsize(7) ysize(5) subtitle(Negative (N = 578),just(center) size(3)) ///
	truegraphoptions(lcol("0 0 0"))  ///
	title(Standardisation, size(4))
restore

* Confidence interval estimation for diagnostic negative repetitions
** As coverage is again very close to 1, normal approximation can be inaccurate
** Hence, the following strategy can similarly be used

/*
** Program to analyse data at the simulation stage can include:
  	capture noisily logistic y i.trt i.cov, asis 
	margins r.trt
	local lci_stan = r(table)[5,1]
	local uci_stan = r(table)[6,1]

** Generate variables for true value and coverage:
	gen true = 0
	gen byte coverstrue_stan = inrange(true, lci_stan, uci_stan)

** Estimate coverage for diagnostic negative repetitions using ci proportions:
	preserve
	drop if errors==430 | max > 0.999 | (max <= 0.999 & max > 0.96 & n_iter > 10)
	ci proportions coverstrue_stan
	restore
*/

*** Diagnostic positive repetitions ***
preserve
drop if errors==430 | max <= 0.96 | (max <= 0.999 & max > 0.96 & n_iter <= 10)
siman setup, true(0.00) est(trt_stan) se(se_stan) rep(rep)
siman analyse
siman zipplot, bygr(note("")) ///
	coveropt(lcol("153 153 153")) noncoveropt(lcol("213 94 0")) ///
	xtitle("",size(medium)) ytitle("",size(medium)) ///
	xlabel(-0.1(0.05)0.1,labsize(3)) ylabel(,labsize(3)) ///
	xsize(7) ysize(5) subtitle(Positive (N = 418),just(center) size(3)) ///
	truegraphoptions(lcol("0 0 0"))  ///
	title(Standardisation, size(4))
restore

* Calculate confidence interval for diagnostic positive repetitions using outputs from siman, including point estimate for coverage, its Monte Carlo error, and number of models
*** Lower bound ***
di 91.38756 - invttail(418-1,0.025)*1.372204
*** Upper bound ***
di 91.38756 + invttail(418-1,0.025)*1.372204
