/*
Applying proposed diagnostics to results from R
*/

cd ""
version 18

* Package used:
// net from https://raw.githubusercontent.com/UCL/siman/dev/

* Import estimates dataset generated in R
import delimited "R_results_s4", delimiters(",") varnames(1) clear 

drop errors method 
// Only results without errors are imported

*** Diagnostic negatives ***
preserve
drop if max > 0.999 | (max <= 0.999 & max > 0.96 & n_iter > 10)
siman setup, true(0.00) est(trt_a) se(se_a) rep(rep)
siman analyse
siman zipplot, bygr(note("") ) ///
	coveropt(lcol("153 153 153")) noncoveropt(lcol("213 94 0")) ///
	xtitle("",size(medium)) ytitle("",size(medium)) ///
	xlabel(-0.1(0.05)0.1,labsize(3)) ylabel(,labsize(3)) ///
	xsize(7) ysize(5) subtitle(Negative (N = 239),just(center) size(3)) ///
	truegraphoptions(lcol("0 0 0"))  ///
	title(Identity-binomial, size(4)) 
restore

*** Diagnostic positives ***
preserve
drop if max <= 0.96 | (max <= 0.999 & max > 0.96 & n_iter <= 10)
siman setup, true(0.00) est(trt_a) se(se_a) rep(rep)
siman analyse
siman zipplot, bygr(note("")) ///
	coveropt(lcol("153 153 153")) noncoveropt(lcol("213 94 0")) ///
	xtitle("",size(medium)) ytitle("",size(medium)) ///
	xlabel(-0.1(0.05)0.1,labsize(3)) ylabel(,labsize(3)) ///
	xsize(7) ysize(5) subtitle(Positive (N = 664),just(center) size(3)) ///
	truegraphoptions(lcol("0 0 0"))  ///
	title(Identity-binomial, size(4)) 
restore

// The diagnostic works similarly for results from R
// These zip plots correspond to Fig. S29
