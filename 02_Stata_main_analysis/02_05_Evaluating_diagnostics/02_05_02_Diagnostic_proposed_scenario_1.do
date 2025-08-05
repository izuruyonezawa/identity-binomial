/* 
Evaluating conditional coverage for diagnostic negative and positive models using the proposed diagnostic, with standardisation as a benchmark (relevant to Figs. 5, S25, and S28)
This script uses an estimates dataset from a base DGM in scenario 1 as an example
*/

cd ""
version 18

* Package used:
// net from https://raw.githubusercontent.com/UCL/siman/dev/

use simcheck_s1_base_postfile, clear

****************************
* Identity-binomial models *
****************************
*** Diagnostic negatives ***
preserve
drop if errors==430 | max > 0.999 | (max <= 0.999 & max > 0.96 & n_iter > 10)
siman setup, true(0.00) est(trt_a) se(se_a) rep(rep)
siman analyse
siman zipplot, bygr(note("") ) ///
	coveropt(lcol("153 153 153")) noncoveropt(lcol("213 94 0")) ///
	xtitle("",size(medium)) ytitle("",size(medium)) ///
	xlabel(,labsize(3)) ylabel(,labsize(3)) ///
	xsize(7) ysize(5) subtitle(Negative (N = 681),just(center) size(3)) ///
	truegraphoptions(lcol("0 0 0"))  ///
	title(Identity-binomial, size(4))
restore

* Calculate confidence interval for diagnostic negatives using outputs from siman, including point estimate for coverage, its Monte Carlo error, and number of models
*** Lower bound ***
di 97.06314 - invttail(681-1,0.025)*.6469864
*** Upper bound ***
di 97.06314 + invttail(681-1,0.025)*.6469864

*** Diagnostic positives ***
preserve
drop if errors==430 | max <= 0.96 | (max <= 0.999 & max > 0.96 & n_iter <= 10)
siman setup, true(0.00) est(trt_a) se(se_a) rep(rep)
siman analyse
siman zipplot, bygr(note("")) ///
	coveropt(lcol("153 153 153")) noncoveropt(lcol("213 94 0")) ///
	xtitle("",size(medium)) ytitle("",size(medium)) ///
	xlabel(,labsize(3)) ylabel(0 10 50 90 100,labsize(3)) ///
	xsize(7) ysize(5) subtitle(Positive (N = 313),just(center) size(3)) ///
	truegraphoptions(lcol("0 0 0"))  ///
	title(Identity-binomial, size(4))
restore

* Calculate confidence interval for diagnostic positives using outputs from siman, including point estimate for coverage, its Monte Carlo error, and number of models
*** Lower bound ***
di 58.14697 - invttail(313-1,0.025)*2.788399
*** Upper bound ***
di 58.14697 + invttail(313-1,0.025)*2.788399


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
	xlabel(,labsize(3)) ylabel(,labsize(3)) ///
	xsize(7) ysize(5) subtitle(Negative (N = 681),just(center) size(3)) ///
	truegraphoptions(lcol("0 0 0"))  ///
	title(Standardisation, size(4))
restore

* Calculate confidence interval for diagnostic negative repetitions using outputs from siman, including point estimate for coverage, its Monte Carlo error, and number of models
*** Lower bound ***
di 97.35683 - invttail(681-1,0.025)*.6147131
*** Upper bound ***
di 97.35683 + invttail(681-1,0.025)*.6147131

*** Diagnostic positive repetitions ***
preserve
drop if errors==430 | max <= 0.96 | (max <= 0.999 & max > 0.96 & n_iter <= 10)
siman setup, true(0.00) est(trt_stan) se(se_stan) rep(rep)
siman analyse
siman zipplot, bygr(note("")) ///
	coveropt(lcol("153 153 153")) noncoveropt(lcol("213 94 0")) ///
	xtitle("",size(medium)) ytitle("",size(medium)) ///
	xlabel(,labsize(3)) ylabel(,labsize(3)) ///
	xsize(7) ysize(5) subtitle(Positive (N = 313),just(center) size(3)) ///
	truegraphoptions(lcol("0 0 0"))  ///
	title(Standardisation, size(4)) 
restore

* Calculate confidence interval for diagnostic positive repetitions using outputs from siman, including point estimate for coverage, its Monte Carlo error, and number of models
*** Lower bound ***
di 90.41534 - invttail(313-1,0.025)*1.663939
*** Upper bound ***
di 90.41534 + invttail(313-1,0.025)*1.663939
