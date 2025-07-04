/* 
Evaluating conditional coverage for diagnostic negative and positive models using the proposed diagnostic, with standardisation as a benchmark (relevant to Figs. 5, S25, and S28)
This script uses an estimates dataset from a base DGM in scenario 3 as an example
*/

cd ""
version 18

* Package used:
// net from https://raw.githubusercontent.com/UCL/siman/dev/

use simcheck_s3_base_postfile, clear

****************************
* Identity-binomial models *
****************************
*** Diagnostic negatives ***
preserve
drop if errors==430 | max > 0.999 | (max <= 0.999 & max > 0.96 & n_iter > 10)
siman setup, true(0.08) est(trt_a) se(se_a) rep(rep)
siman analyse
siman zipplot, bygr(note("")) ///
	coveropt(lcol("153 153 153")) noncoveropt(lcol("213 94 0")) ///
	xtitle("",size(medium)) ytitle("",size(medium)) ///
	xlabel(0(0.04)0.18,labsize(3)) ylabel(,labsize(3)) ///
	xsize(7) ysize(5) subtitle(Negative (N = 593),just(center) size(3)) ///
	truegraphoptions(lcol("0 0 0"))  ///
	title(Identity-binomial, size(4))
restore

* Calculate confidence interval for diagnostic negatives using outputs from siman, including point estimate for coverage, its Monte Carlo error, and number of models
*** Lower bound ***
di 90.38786 - invttail(593-1,0.025)*1.210425
*** Upper bound ***
di 90.38786 + invttail(593-1,0.025)*1.210425

*** Diagnostic positives ***
preserve
drop if errors==430 | max <= 0.96 | (max <= 0.999 & max > 0.96 & n_iter <= 10)
siman setup, true(0.08) est(trt_a) se(se_a) rep(rep)
siman analyse
siman zipplot, bygr(note("")) ///
	coveropt(lcol("153 153 153")) noncoveropt(lcol("213 94 0")) ///
	xtitle("",size(medium)) ytitle("",size(medium)) ///
	xlabel(0(0.04)0.18,labsize(3)) ylabel(0 10 50 90 100,labsize(3)) ///
	xsize(7) ysize(5) subtitle(Positive (N = 401),just(center) size(3)) ///
	truegraphoptions(lcol("0 0 0"))  ///
	title(Identity-binomial, size(4))
restore

* Calculate confidence interval for diagnostic positives using outputs from siman, including point estimate for coverage, its Monte Carlo error, and number of models
*** Lower bound ***
di 93.51621 - invttail(401-1,0.025)*1.229662
*** Upper bound ***
di 93.51621 + invttail(401-1,0.025)*1.229662


*******************
* Standardisation *
*******************
*** Diagnostic negative repetitions ***
preserve
drop if errors==430 | max > 0.999 | (max <= 0.999 & max > 0.96 & n_iter > 10)
siman setup, true(0.08) est(trt_stan) se(se_stan) rep(rep)
siman analyse
siman zipplot, bygr(note("")) ///
	coveropt(lcol("153 153 153")) noncoveropt(lcol("213 94 0")) ///
	xtitle("",size(medium)) ytitle("",size(medium)) ///
	xlabel(0(0.04)0.18,labsize(3)) ylabel(,labsize(3)) ///
	xsize(7) ysize(5) subtitle(Negative (N = 593),just(center) size(3)) ///
	truegraphoptions(lcol("0 0 0"))  ///
	title(Standardisation, size(4))
restore

* Calculate confidence interval for diagnostic negative repetitions using outputs from siman, including point estimate for coverage, its Monte Carlo error, and number of models
*** Lower bound ***
di 90.89376 - invttail(593-1,0.025)*1.181433
*** Upper bound ***
di 90.89376 + invttail(593-1,0.025)*1.181433

*** Diagnostic positive repetitions ***
preserve
drop if errors==430 | max <= 0.96 | (max <= 0.999 & max > 0.96 & n_iter <= 10)
siman setup, true(0.08) est(trt_stan) se(se_stan) rep(rep)
siman analyse
siman zipplot, bygr(note("")) ///
	coveropt(lcol("153 153 153")) noncoveropt(lcol("213 94 0")) ///
	xtitle("",size(medium)) ytitle("",size(medium)) ///
	xlabel(0(0.04)0.18,labsize(3)) ylabel(,labsize(3)) ///
	xsize(7) ysize(5) subtitle(Positive (N = 401),just(center) size(3)) ///
	truegraphoptions(lcol("0 0 0"))  ///
	title(Standardisation, size(4))
restore

* Calculate confidence interval for diagnostic positive repetitions using outputs from siman, including point estimate for coverage, its Monte Carlo error, and number of models
*** Lower bound ***
di 95.01247 - invttail(401-1,0.025)*1.087079
*** Upper bound ***
di 95.01247 + invttail(401-1,0.025)*1.087079
