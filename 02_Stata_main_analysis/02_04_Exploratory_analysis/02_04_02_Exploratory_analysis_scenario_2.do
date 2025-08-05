/*
Exploratory analysis for developing potential diagnostics for identity-binomial models with IRLS (scenario 2)
*/

cd ""
version 18
* Package used:
// net install grc1leg, from(http://www.stata.com/users/vwiggins/) 

use simcheck_s2_base_postfile, clear

* Associations between predicted values around the boundaries and SE estimation under scenario 2 (Fig. S15)
gen max_cat = 0 if t0b1 <= 0.999 & t1b1 <= 0.999
replace max_cat = 1 if t0b1 <=1 & t0b1 > 0.999 & t1b1 <= 0.999
replace max_cat = 2 if t1b1 <=1 & t1b1 > 0.999 & t0b1 <= 0.999
replace max_cat = 3 if t0b1 > 1 & t1b1 <= 0.999
replace max_cat = 4 if t1b1 > 1 & t0b1 <= 0.999
replace max_cat = 5 if t0b1 <=1 & t0b1 > 0.999 & t1b1 <=1 & t1b1 > 0.999
replace max_cat = 6 if t1b1 <=1 & t1b1 > 0.999 & t0b1 > 1
replace max_cat = 7 if t0b1 <=1 & t0b1 > 0.999 & t1b1 > 1
tab max_cat,m

gen seratio = se_a / se_u 
scatter seratio trt_a if max_cat==0, msize(2.5) msymbol(O) mcolor("153 153 153%60") ||  ///
scatter seratio trt_a if max_cat==1, msize(2.5) msymbol(D) mcolor("0 114 178%60") ||  ///
scatter seratio trt_a if max_cat==2, msize(2.5) msymbol(S) mcolor("0 114 178%60") ||  ///
scatter seratio trt_a if max_cat==3, msize(2.5) msymbol(T) mcolor("230 159 0%60") ||  ///
scatter seratio trt_a if max_cat==4, msize(2.5) msymbol(+) mcolor("230 159 0") ||  ///
scatter seratio trt_a if max_cat==6, msize(2.5) msymbol(v) mcolor("213 94 0") ||  /// 
scatter seratio trt_a if max_cat==7, msize(2.5) msymbol(X) mcolor("213 94 0") ///
    text( .4846247    .0287021 "N", size(2.5) color(black) place(c)) ///
	text( .4447506   -.0240101 "N", size(2.5) color(black) place(c)) ///
	text( .6372012   -.0291308  "N", size(2.5) color(black) place(c)) ///
	text( .4553568   -.0264329 "N", size(2.5) color(black) place(c)) ///
	text(0.30 -0.035  "N: Not converged", size(3) color(black) place(e)) ///
	legend(off)  title("{bf:B}", size(4) position(11)) ///
	xtitle(Adjusted treatment effect estimates, size(3))  /// 
	ytitle(SE ratio (adjusted/unadjusted), size(3)) ///
	graphregion(margin(1 2 0 2)) ///
	xlab(-0.04(0.01)0.04,labsize(3)) ylab(,labsize(3)) ///
saving(theta_seratio_s2, replace)
 
scatter t1b1 t0b1 if max_cat==0, msize(2.5) msymbol(O) mcolor("153 153 153%60") ||  ///
scatter t1b1 t0b1 if max_cat==1, msize(2.5) msymbol(D) mcolor("0 114 178%60") ||  ///
scatter t1b1 t0b1 if max_cat==2, msize(2.5) msymbol(S) mcolor("0 114 178%60") ||  ///
scatter t1b1 t0b1 if max_cat==3, msize(2.5) msymbol(T) mcolor("230 159 0%60") ||  ///
scatter t1b1 t0b1 if max_cat==4, msize(2.5) msymbol(+) mcolor("230 159 0") || ///
scatter t1b1 t0b1 if max_cat==6, msize(2.5) msymbol(v) mcolor("213 94 0") ||  ///
scatter t1b1 t0b1 if max_cat==7, msize(2.5) msymbol(X) mcolor("213 94 0") ///
  text(1.018482 .9897804 "N", size(2.5) color(black) place(c)) ///
	text(.990405  1.014415 "N", size(2.5) color(black) place(c)) ///
	text(.9837664 1.012897  "N", size(2.5) color(black) place(c)) ///
	text(.9902518 1.016685  "N", size(2.5) color(black) place(c)) ///
	text(1.015 1.0125 "N: Not converged", place(c) size(3)) ///
    legend(title(Predicted values for b1 subgroup , size(3)) order(1 "t0b1 & t1b1≤0.999" 2 "t0b1≈1 & t1b1≤0.999 " 3 "t1b1≈1 & t0b1≤0.999" 4 "t0b1>1 & t1b1≤0.999" 5 "t1b1>1 & t0b1≤0.999" 6 "t0b1>1 & t1b1≈1" 7 "t1b1>1 & t0b1≈1") size(small) cols(4) holes(4)) ///
	xtitle(t0b1, size(3)) ytitle(t1b1,size(3)) ///
	xlab(0.96(0.01)1.02, labsize(3)) ///
	ylab(0.96(0.01)1.02, labsize(3)) ///
	 title("{bf:A}", size(4) position(11)) ///
	 graphregion(margin(0 1 0 2)) ///
	jitter(0) saving(pred_b1_s2, replace)


** Combine graphs, using 'grc1leg' command 
grc1leg pred_b1_s2.gph theta_seratio_s2.gph, position(6) iscale(0.8)


