/*
Compare results from R and Stata, using combined dataset
*/

cd ""
version 18

* Package used:
// net from https://raw.githubusercontent.com/UCL/siman/dev/

* Import combined dataset generated in R
import delimited "combined_s4.csv", delimiters(",") varnames(1) clear 

** Apply scatter compare methods plot (comparemethodsscatter) and zipplot in siman package
siman setup, true(0.00) est(trt_a) se(se_a) method(method) rep(rep)
siman comparemethodsscatter, title("Scenario 4")
// This output corresponds to Fig. S9
// Point and standard error estimates are identical
siman zipplot, bygr(note("") ) ///
	coveropt(lcol("153 153 153")) noncoveropt(lcol("213 94 0")) ///
	xtitle("",size(medium)) ytitle("",size(medium)) ///
	xlabel(-0.1(0.05)0.1,labsize(3)) ylabel(,labsize(3)) ///
	xsize(7) ysize(5) subtitle(,just(center) size(3)) ///
	truegraphoptions(lcol("0 0 0"))   
// This output corresponds to Fig. S10
// Looks very similar
