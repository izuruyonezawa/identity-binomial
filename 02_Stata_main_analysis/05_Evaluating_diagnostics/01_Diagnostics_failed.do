/* 
Presenting example zip plots for diagnostic-negative models with potential diagnostic criteria, showing low negative predictive values (Fig. S21–S24) 
*/

cd ""
version 18
* Package used:
// net from https://raw.githubusercontent.com/UCL/siman/dev/
// net install grc1leg, from(http://www.stata.com/users/vwiggins/) 

* Diagnostic-negative models with `the maximum predicted value more than 1' in scenario 4 (Fig. S21)
// The following zip plots are based on models with a single binary covariate under the base DGM with the largest interaction

use simcheck_s4_base_08_postfile, clear

** Draw Zip plots for diagnostic negatives after applying the diagnostic
****************************
* Identity-binomial models *
****************************
preserve
drop if errors==430 | max > 1 
siman setup, true(0.00) est(trt_a) se(se_a) rep(rep)
siman analyse
siman zipplot, bygr(note("") legend(rows(1) size(4))  ) ///
	coveropt(lcol("153 153 153")) noncoveropt(lcol("213 94 0")) ///
	xtitle("",size(medium)) ytitle("",size(medium)) ///
	xlabel(-0.1(0.05)0.1,labsize(5)) ylabel(,labsize(5)) ///
	xsize(7) ysize(4) subtitle(N = 890, just(center) size(5)) /// 
	truegraphoptions(lcol("0 0 0"))  ///
	title(Identity-binomial, size(6)) ///
	graphregion(margin(-2 -2 -2 -2)) ///
	saving(ib1, replace)
restore

*******************
* Standardisation *
*******************
preserve
drop if errors==430 | max > 1 
siman setup, true(0.00) est(trt_stan) se(se_stan) rep(rep)
siman analyse
siman zipplot, bygr(note("") legend(off)) ///
	coveropt(lcol("153 153 153")) noncoveropt(lcol("213 94 0")) ///
	xtitle("",size(medium)) ytitle("",size(medium)) ///
	xlabel(-0.1(0.05)0.1,labsize(5)) ylabel(,labsize(5)) ///
	xsize(7) ysize(5) subtitle(N = 890, just(center) size(5)) /// 
	truegraphoptions(lcol("0 0 0"))  ///
	title(Standardisation, size(6)) ///
	graphregion(margin(-2 -2 -2 -2)) ///
	saving(stan1, replace)
restore

grc1leg ib1.gph stan1.gph, cols(2) rows(1) xsize(1.5) ysize(2.2) l1title("Centile of |z{subscript:i}|", size(4) margin(1 0 0 0)) b1title(95% confidence intervals, size(4)) imargin(0 0 0 0) position(6) ring(2) 

* Diagnostic-negative models with `the maximum predicted value more than 0.999' under scenario 4 (Fig. S22)
// The following zip plots are based on models with a single binary covariate under the base DGM with the largest interaction

** Draw Zip plots for diagnostic negatives after applying the diagnostic
****************************
* Identity-binomial models *
****************************
preserve
drop if errors==430 | max > 0.999 
siman setup, true(0.00) est(trt_a) se(se_a) rep(rep)
siman analyse
siman zipplot, bygr(note("") legend(rows(1) size(4))  ) ///
	coveropt(lcol("153 153 153")) noncoveropt(lcol("213 94 0")) ///
	xtitle("",size(medium)) ytitle("",size(medium)) ///
	xlabel(-0.1(0.05)0.1,labsize(5)) ylabel(,labsize(5)) ///
	xsize(7) ysize(4) subtitle(N = 731, just(center) size(5)) /// 
	truegraphoptions(lcol("0 0 0"))  ///
	title(Identity-binomial, size(6)) ///
	graphregion(margin(-2 -2 -2 -2)) ///
	saving(ib999, replace)
restore

*******************
* Standardisation *
*******************
preserve
drop if errors==430 | max > 0.999
siman setup, true(0.00) est(trt_stan) se(se_stan) rep(rep)
siman analyse
siman zipplot, bygr(note("") legend(off)) ///
	coveropt(lcol("153 153 153")) noncoveropt(lcol("213 94 0")) ///
	xtitle("",size(medium)) ytitle("",size(medium)) ///
	xlabel(-0.1(0.05)0.1,labsize(5)) ylabel(,labsize(5)) ///
	xsize(7) ysize(5) subtitle(N = 731, just(center) size(5)) /// 
	truegraphoptions(lcol("0 0 0"))  ///
	title(Standardisation, size(6)) ///
	graphregion(margin(-2 -2 -2 -2)) ///
	saving(stan999, replace)
restore

grc1leg ib999.gph stan999.gph, cols(2) rows(1) xsize(1.5) ysize(2.2) l1title("Centile of |z{subscript:i}|", size(4) margin(1 0 0 0)) b1title(95% confidence intervals, size(4)) imargin(0 0 0 0) position(6) ring(2)


* Diagnostic-negative models with `the SE ratio less than 0.99' under scenario 4 (Fig. S23)
// SE ratio: Adjusted SE ⁄ Unadjusted SE (treatment effect)
// The following zip plots are based on models with a single binary covariate under the DGM with the largest interaction and a sample size of 1,248

use simcheck_s4_n1248_postfile, clear

gen seratio = se_a / se_u

** Draw Zip plots for diagnostic negatives after applying the diagnostic
****************************
* Identity-binomial models *
****************************
preserve
drop if errors==430 | seratio < 0.99
siman setup, true(0.00) est(trt_a) se(se_a) rep(rep)
siman analyse
siman zipplot, bygr(note("") legend(rows(1) size(4)) ) ///
	coveropt(lcol("153 153 153")) noncoveropt(lcol("213 94 0")) ///
	xtitle("",size(medium)) ytitle("",size(medium)) ///
	xlabel(-0.1(0.05)0.1,labsize(5)) ylabel(,labsize(5)) ///
	xsize(7) ysize(4) subtitle(N = 542, just(center) size(5)) /// 
	truegraphoptions(lcol("0 0 0"))  ///
	title(Identity-binomial, size(6)) ///
	graphregion(margin(-2 -2 -2 -2)) ///
	saving(ib_ser, replace)
restore

*******************
* Standardisation *
*******************
preserve
drop if errors==430 | seratio < 0.99
siman setup, true(0.00) est(trt_stan) se(se_stan) rep(rep)
siman analyse
siman zipplot, bygr(note("") legend(off)) ///
	coveropt(lcol("153 153 153")) noncoveropt(lcol("213 94 0")) ///
	xtitle("",size(medium)) ytitle("",size(medium)) ///
	xlabel(-0.1(0.05)0.1,labsize(5)) ylabel(,labsize(5)) ///
	xsize(7) ysize(5) subtitle(N = 542, just(center) size(5)) /// 
	truegraphoptions(lcol("0 0 0"))  ///
	title(Standardisation, size(6)) ///
	graphregion(margin(-2 -2 -2 -2)) ///
	saving(stan_ser, replace)
restore

grc1leg ib_ser.gph stan_ser.gph, cols(2) rows(1) xsize(2) ysize(1) l1title("Centile of |z{subscript:i}|", size(4) margin(1 0 0 0)) b1title(95% confidence intervals, size(4)) imargin(0 0 0 0) position(6) ring(2)

* Diagnostic-negative models with `the number of iterations more than ten' under scenario 2 (Fig. S24) 
// The following zip plots are based on models with a single binary covariate under the base DGM with the largest covariate effect

use simcheck_s2_base_postfile, clear

** Draw Zip plots for diagnostic negatives after applying the diagnostic
****************************
* Identity-binomial models *
****************************
preserve
drop if errors==430 | n_iter > 10
siman setup, true(0.00) est(trt_a) se(se_a) rep(rep)
siman analyse
siman zipplot, bygr(note("") legend(rows(1) size(4)) ) ///
	coveropt(lcol("153 153 153")) noncoveropt(lcol("213 94 0")) ///
	xtitle("",size(medium)) ytitle("",size(medium)) ///
	xlabel(-0.1(0.05)0.1,labsize(5)) ylabel(0 10 50 90 100,labsize(5)) ///
	xsize(7) ysize(4) subtitle(N = 880, just(center) size(5)) /// 
	truegraphoptions(lcol("0 0 0"))  ///
	title(Identity-binomial, size(6)) ///
	graphregion(margin(-2 -2 -2 -2)) ///
	saving(ib_iter, replace)
restore

*******************
* Standardisation *
*******************
preserve
drop if errors==430 | n_iter > 10
siman setup, true(0.00) est(trt_stan) se(se_stan) rep(rep)
siman analyse
siman zipplot, bygr(note("") legend(off)) ///
	coveropt(lcol("153 153 153")) noncoveropt(lcol("213 94 0")) ///
	xtitle("",size(medium)) ytitle("",size(medium)) ///
	xlabel(-0.1(0.05)0.1,labsize(5)) ylabel(0 10 50 90 100,labsize(5)) ///
	xsize(7) ysize(5) subtitle(N = 880, just(center) size(5)) /// 
	truegraphoptions(lcol("0 0 0"))  ///
	title(Standardisation, size(6)) ///
	graphregion(margin(-2 -2 -2 -2)) ///
	saving(stan_iter, replace)
restore

grc1leg ib_iter.gph stan_iter.gph, cols(2) rows(1) xsize(2) ysize(1) l1title("Centile of |z{subscript:i}|", size(4) margin(1 0 0 0)) b1title(95% confidence intervals, size(4)) imargin(0 0 0 0) position(6) ring(2)
