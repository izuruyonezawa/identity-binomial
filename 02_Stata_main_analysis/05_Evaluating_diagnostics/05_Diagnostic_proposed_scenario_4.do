/* 
Evaluating conditional coverage for diagnostic negative and positive models using the proposed diagnostic, with standardisation as a benchmark (relevant to Figs. 5, S25, and S28)
This script uses an estimates dataset from a base DGM with the largest interaction in scenario 4 as an example
*/

cd ""
version 18

* Package used:
// net from https://raw.githubusercontent.com/UCL/siman/dev/

use simcheck_s4_base_08_postfile, clear

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
	xlabel(-0.1(0.05)0.1,labsize(3)) ylabel(,labsize(3)) ///
	xsize(7) ysize(5) subtitle(Negative (N = 237),just(center) size(3)) ///
	truegraphoptions(lcol("0 0 0"))  ///
	title(Identity-binomial, size(4)) 
restore

* Confidence interval estimation for diagnostic negatives
** As coverage is very close to 1, normal approximation can be inaccurate
** It can be estimated as shown in 'Diagnostic_proposed_scenario_2.do'

*** Diagnostic positives ***
preserve
drop if errors==430 | max <= 0.96 | (max <= 0.999 & max > 0.96 & n_iter <= 10)
siman setup, true(0.00) est(trt_a) se(se_a) rep(rep)
siman analyse
siman zipplot, bygr(note("")) ///
	coveropt(lcol("153 153 153")) noncoveropt(lcol("213 94 0")) ///
	xtitle("",size(medium)) ytitle("",size(medium)) ///
	xlabel(-0.1(0.05)0.1,labsize(3)) ylabel(,labsize(3)) ///
	xsize(7) ysize(5) subtitle(Positive (N = 654),just(center) size(3)) ///
	truegraphoptions(lcol("0 0 0"))  ///
	title(Identity-binomial, size(4)) 
restore

* Calculate confidence interval for diagnostic positives using outputs from siman, including point estimate for coverage, its Monte Carlo error, and number of models
*** Lower bound ***
di 64.98471 - invttail(654-1,0.025)*1.865287
*** Upper bound ***
di 64.98471 + invttail(654-1,0.025)*1.865287


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
	xsize(7) ysize(5) subtitle(Negative (N = 237),just(center) size(3)) ///
	truegraphoptions(lcol("0 0 0"))  ///
	title(Standardisation, size(4))
restore

* Confidence interval estimation for diagnostic negative repetitions
** As coverage is very close to 1, normal approximation can be inaccurate
** It can be estimated as shown in 'Diagnostic_proposed_scenario_2.do'

*** Diagnostic positive repetitions ***
preserve
drop if errors==430 | max <= 0.96 | (max <= 0.999 & max > 0.96 & n_iter <= 10)
siman setup, true(0.00) est(trt_stan) se(se_stan) rep(rep)
siman analyse
siman zipplot, bygr(note("")) ///
	coveropt(lcol("153 153 153")) noncoveropt(lcol("213 94 0")) ///
	xtitle("",size(medium)) ytitle("",size(medium)) ///
	xlabel(-0.1(0.05)0.1,labsize(3)) ylabel(,labsize(3)) ///
	xsize(7) ysize(5) subtitle(Positive (N = 654),just(center) size(3)) ///
	truegraphoptions(lcol("0 0 0"))  ///
	title(Standardisation, size(4))
restore

* Calculate confidence interval for diagnostic positive repetitions using outputs from siman, including point estimate for coverage, its Monte Carlo error, and number of models
*** Lower bound ***
di 93.11926 - invttail(654-1,0.025)*.9898021
*** Upper bound ***
di 93.11926 + invttail(654-1,0.025)*.9898021
