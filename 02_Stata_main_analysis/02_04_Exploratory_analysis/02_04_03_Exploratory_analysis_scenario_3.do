/*
Exploratory analysis for developing potential diagnostics for identity-binomial models with IRLS (scenario 3)
*/

cd ""
version 18
* Package used:
// net install grc1leg, from(http://www.stata.com/users/vwiggins/) 

use simcheck_s3_base_postfile, clear

* Associations between predicted values around the boundaries and SE estimation under scenario 3 (Fig. S16)
// This plot focuses on covariate effect estimates, instead of treatment effect estimates 

gen max_cat = 0 if t1b0  <= 0.999 & t1b1 <= 0.999
replace max_cat = 1 if t1b0  <=1 & t1b0  > 0.999 & t1b1 <= 0.999
replace max_cat = 2 if t1b1 <=1 & t1b1 > 0.999 & t1b0  <= 0.999
replace max_cat = 3 if t1b0  > 1 & t1b1 <= 0.999
replace max_cat = 4 if t1b1 > 1 & t1b0  <= 0.999 
replace max_cat = 5 if t1b0  <=1 & t1b0  > 0.999 & t1b1 <=1 & t1b1 > 0.999
replace max_cat = 6 if t1b1 <=1 & t1b1 > 0.999 & t1b0  > 1 | rep == 444
replace max_cat = 7 if t1b0  <=1 & t1b0  > 0.999 & t1b1 > 1 | rep == 79
tab max_cat, m

gen seratio_cov = se_cov_a / se_cov_u
scatter seratio_cov cov_a if max_cat==0, msymbol(O) msize(2.5) mcolor("153 153 153%60") ||  ///
scatter seratio_cov cov_a if max_cat==1, msymbol(D) msize(2.5)  mcolor("0 114 178%60") ||  ///
scatter seratio_cov cov_a if max_cat==2, msymbol(S) msize(2.5) mcolor("0 114 178%60") ||  ///
scatter seratio_cov cov_a if max_cat==3, msymbol(T) msize(2.5) mcolor("230 159 0%60") ||  ///
scatter seratio_cov cov_a if max_cat==4, msymbol(+) msize(2.5) mcolor("230 159 0") ||  ///
scatter seratio_cov cov_a if max_cat==5, msymbol(oh) msize(2.5) mcolor("213 94 0") || ///
scatter seratio_cov cov_a if max_cat==6, msymbol(v) msize(2.5) mcolor("213 94 0") ||  /// 
scatter seratio_cov cov_a if max_cat==7, msymbol(X) msize(2.5) mcolor("213 94 0") ///
    text(.0006533    .0381746 "N", size(2.5) color(black) place(c)) ///
	text(.5823411   -.0262186 "N", size(2.5) color(black) place(c)) ///
	text(.0006556   -.0294153 "N", size(2.5) color(black) place(c)) ///
	text(.4467339    .0254783 "N", size(2.5) color(black) place(c)) ///
	text(.4891086    .0252181 "N", size(2.5) color(black) place(c)) ///
	text(.5367283   -.0234741 "N", size(2.5) color(black) place(c)) ///
	text(0.25 0.03  "N: Not converged", size(3) color(black) place(e)) ///
	xlab(,labsize(3)) ylab(,labsize(3)) ///
	xtitle(Adjusted covariate effect estimates, size(3)) ytitle(SE ratios (adjusted/unadjusted), size(3)) ///
	legend(off)  title("{bf:B}",size(4) position(11))  graphregion(margin(1 2 0 2)) saving(theta_seratio_s3, replace)

scatter t1b1 t1b0 if max_cat==0, msymbol(O) msize(2.5) mcolor("153 153 153%60") ||  ///
scatter t1b1 t1b0 if max_cat==1, msymbol(D) msize(2.5) mcolor("0 114 178%60") ||  ///
scatter t1b1 t1b0 if max_cat==2, msymbol(S) msize(2.5) mcolor("0 114 178%60") ||  ///
scatter t1b1 t1b0 if max_cat==3, msymbol(T) msize(2.5) mcolor("230 159 0%60") ||  ///
scatter t1b1 t1b0 if max_cat==4, msymbol(+) msize(2.5) mcolor("230 159 0") || ///
scatter t1b1 t1b0 if max_cat==5, msymbol(oh) msize(2.5) mcolor("213 94 0") || ///
scatter t1b1 t1b0 if max_cat==6, msymbol(v) msize(2.5) mcolor("213 94 0") ||  ///
scatter t1b1 t1b0 if max_cat==7, msymbol(X) msize(2.5) mcolor("213 94 0") ///
title("{bf:A}",size(4) position(11)) ///
	legend(title(Predicted values for t1 group, size(3)) order(1 "t1b0 & t1b1≤0.999" 2 "t1b0≈1 & t1b1≤0.999 " 3 "t1b1≈1 & t1b0≤0.999" 4 "t1b0>1 & t1b1≤0.999" 5 "t1b1>1 & t1b0≤0.999" 6 "t1b0≈1 & t1b1≈1" 7 "t1b0>1 & t1b1≈1" 8 "t1b1>1 & t1b0≈1") size(small) cols(4)) ///
	text(1.038175   1.000001 "N", size(2.5) color(black) place(c)) ///
	text(.9879283   1.014147 "N", size(2.5) color(black) place(c)) ///
	text(1.000001   1.029416 "N", size(2.5) color(black) place(c)) ///
	text(1.016244   .9907653  "N", size(2.5) color(black) place(c)) ///
	text(1.015252  .9900343  "N", size(2.5) color(black) place(c)) ///
	text(.9892253   1.012699 "N", size(2.5) color(black) place(c)) ///
	text(1.015 1.012 "N: Not converged", place(e) size(3)) ///
	xlab(0.96(0.01)1.04,labsize(3)) ylab(0.96(0.01)1.04,labsize(3)) ///
	xtitle(t1b0,size(3)) ytitle(t1b1,size(3)) ///
	graphregion(margin(0 1 0 2))  ///
    jitter(0) saving(pred_t1_s3, replace)

** Combine graphs, using 'grc1leg' command
grc1leg pred_t1_s3.gph theta_seratio_s3.gph, position(6) iscale(0.8)  name(map3, replace) 
