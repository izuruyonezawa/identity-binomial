/*
Exploratory analysis for developing potential diagnostics for identity-binomial models with IRLS (scenario 1)
*/

cd ""
version 18
* Package used:
// net install grc1leg, from(http://www.stata.com/users/vwiggins/) 

use simcheck_s1_base_postfile, clear

* Predicted values for the two strata in b1 group, t0b1 and t1b1, comparing the two methods (Fig. S12) 
scatter t1b1 t0b1 if errors == 0, mcolor("0 114 178%50") msymbol(O) || ///
scatter t1b1 t0b1 if errors == 430, mcolor("213 94 0%60") msymbol(D) jitter(0) title(Identity-binomial, size(6)) xtitle("",size(5)) ytitle("",size(5)) xlabel(0.7(0.1)1.1,labsize(5)) ylabel(0.7(0.1)1.1,labsize(5)) subtitle(,size(vsmall)) legend(position(0) bplacement(east) order( 2 "Not converged") size(4.5))  xline(1.0) yline(1.0) graphregion(margin(0 1 1 0)) saving(pred_ib_s1, replace)

scatter t1b1_s t0b1_s, mcolor("0 114 178%50") msymbol(O) jitter(0) title(Standardisation, size(6)) xtitle("",size(5)) ytitle("",size(5)) xlabel(0.7(0.1)1.1,labsize(5)) ylabel(0.7(0.1)1.1,labsize(5)) subtitle(,size(vsmall))  legend(order(1 "Converged" 2 "Not converged") size(4))  xline(1.0) yline(1.0) saving(pred_stan_s1, replace) graphregion(margin(0 2 1 0)) 

graph combine pred_ib_s1.gph pred_stan_s1.gph, title("", size(medium)) cols(2) rows(1) xsize(3) ysize(1.5) l1title(t1b1,size(4)) b1title(t0b1, size(4))

* Predicted values for the two strata in b1 group from identity-binomial models under scenario 1, categorised by the number of iterations (Fig. S13)
gen n_iter_cat = 0 if n_iter <= 10
replace n_iter_cat = 1 if n_iter > 10 & n_iter <= 20
replace n_iter_cat = 2 if n_iter > 20 & n_iter < 200
replace n_iter_cat = 3 if n_iter == 200

scatter t1b1 t0b1 if n_iter_cat==0, msymbol(O) mcolor("153 153 153%60") || ///
scatter t1b1 t0b1 if n_iter_cat==1, msymbol(D) mcolor("0 114 178%60") || ///
scatter t1b1 t0b1 if n_iter_cat==2, msymbol(T) mcolor("230 159 0%60") || ///
scatter t1b1 t0b1 if n_iter_cat==3, msymbol(X) mcolor("213 94 0") title("", size(medium)) legend(title(Number of iterations, size(3)) order(1 "≤ 10" 2 "10-20" 3 "20-200" 4 "Not converged") size(3) rows(1) position(6)) ///
fxsize(100) /// 
ylab(0.7(0.05)1.05) ///
xlab(0.7(0.05)1.05) ///
title("", size(4) position(11)) ///
xline(1, lcolor("153 153 153%60")) yline(1, lcolor("153 153 153%60")) ///
graphregion(margin(0 0 0 2)) ///
xtitle(t0b1) ytitle(t1b1) 

* Associations between predicted values around the boundaries and SE estimation under scenario 1 (Fig. S14)
gen max_cat = 0 if t0b1 <= 0.999 & t1b1 <= 0.999
replace max_cat = 1 if t0b1 <=1 & t0b1 > 0.999 & t1b1 <= 0.999
replace max_cat = 2 if t1b1 <=1 & t1b1 > 0.999 & t0b1 <= 0.999
replace max_cat = 3 if t0b1 > 1 & t1b1 <= 0.999
replace max_cat = 4 if t1b1 > 1 & t0b1 <= 0.999
replace max_cat = 5 if t0b1 <=1 & t0b1 > 0.999 & t1b1 <=1 & t1b1 > 0.999
replace max_cat = 6 if t1b1 <=1 & t1b1 > 0.999 & t0b1 > 1
replace max_cat = 7 if t0b1 <=1 & t0b1 > 0.999 & t1b1 > 1

gen seratio = se_a / se_u
hist seratio

list seratio trt_a  if errors == 430
preserve 
drop if t1b1 < 0.95 | t0b1 < 0.95 
scatter seratio trt_a if max_cat==0, msymbol(O) msize(2.5) mcolor("153 153 153%60") ||  ///
scatter seratio trt_a if max_cat==1, msymbol(D) msize(2.5) mcolor("0 114 178%60") ||  ///
scatter seratio trt_a if max_cat==2, msymbol(S) msize(2.5) mcolor("0 114 178%60") ||  ///
scatter seratio trt_a if max_cat==3, msymbol(T) msize(2.5) mcolor("230 159 0%60") ||  ///
scatter seratio trt_a if max_cat==4, msymbol(+) msize(2.5) mcolor("230 159 0") ||  ///
scatter seratio trt_a if max_cat==6, msymbol(v) msize(2.5) mcolor("213 94 0") ||  /// 
scatter seratio trt_a if max_cat==7, msymbol(X) msize(2.5) mcolor("213 94 0") ///
    text(.7996073  -.0344384 "N", size(2.5) color(black) place(c)) ///
	text(.7961394   .0326456 "N", size(2.5) color(black) place(c)) ///
	text(.5757667   -.0209449  "N", size(2.5) color(black) place(c)) ///
	text(.6116157   -.0232593 "N", size(2.5) color(black) place(c)) ///
	text(.8148097   -.0250402 "N", size(2.5) color(black) place(c)) ///
	text(.5969827   -.0189747 "N", size(2.5) color(black) place(c)) ///
	text(0.70 -0.020  "N: Not converged", size(3) color(black) place(w)) ///
	legend(off)  title("{bf:B}", size(4) position(11)) ///
	xtitle(Adjusted treatment effect estimates, size(3)) ytitle(SE ratio (adjusted/unadjusted), size(3)) xlab(-0.05(0.01)0.05,labsize(3)) ylab(,labsize(3)) graphregion(margin(1 2 0 2)) saving(theta_seratio_s1, replace)
restore

preserve 
drop if t1b1 < 0.95 | t0b1 < 0.95 
twoway scatter t1b1 t0b1 if max_cat==0, msymbol(O) msize(2.5)  mcolor("153 153 153%60") ||  ///
scatter t1b1 t0b1 if max_cat==1, msymbol(D) msize(2.5) mcolor("0 114 178%60") ||  ///
scatter t1b1 t0b1 if max_cat==2, msymbol(S) msize(2.5) mcolor("0 114 178%60") ||  ///
scatter t1b1 t0b1 if max_cat==3, msymbol(T) msize(2.5) mcolor("230 159 0%60") ||  ///
scatter t1b1 t0b1 if max_cat==4, msymbol(+) msize(2.5) mcolor("230 159 0") || ///
scatter t1b1 t0b1 if max_cat==6, msymbol(v) msize(2.5) mcolor("213 94 0") ||  ///
scatter t1b1 t0b1 if max_cat==7, msymbol(X) msize(2.5) mcolor("213 94 0") || ///
pcarrowi 1.018 1.007 1.022 0.9925 1.011 1.015 1 1.018, lwidth(vthin) mlwidth(vthin) ///
title("", size(medium)) ///
    text(0.988881 1.023319 "N", size(2.5) color(black) place(c)) ///
	text(1.022137 0.9894918 "N", size(2.5) color(black) place(c)) ///
	text(.9972764 1.018221 "N", size(2.5) color(black) place(c)) ///
	text(.9960791 1.019338  "N", size(2.5) color(black) place(c)) ///
	text(.9931004 1.018141 "N", size(2.5) color(black) place(c)) ///
	text(.9971546 1.016129 "N", size(2.5) color(black) place(c)) ///
	text(1.015 1.015 "N: Not converged", place(c) size(3)) ///
    legend(title(Predicted values for b1 subgroup, size(3)) order(1 "t0b1 & t1b1≤0.999" 2 "t0b1≈1 & t1b1≤0.999 " 3 "t1b1≈1 & t0b1≤0.999" 4 "t0b1>1 & t1b1≤0.999" 5 "t1b1>1 & t0b1≤0.999" 6 "t0b1>1 & t1b1≈1" 7 "t1b1>1 & t0b1≈1") size(small) cols(4) holes(4)) ///
	xtitle(t0b1, size(3)) ytitle(t1b1, size(3)) ///
	xlab(,labsize(3)) ylab(,labsize(3)) ///
	xline(1.0, lcolor("153 153 153%60")) yline(1.0, lcolor("153 153 153%60"))  title("{bf:A}",size(4) position(11))    graphregion(margin(0 1 0 2)) saving(pred_b1_s1, replace)
restore

** Combine graphs, using 'grc1leg' command
grc1leg pred_b1_s1.gph theta_seratio_s1.gph, position(6) iscale(0.8)  title(, size(3) margin(t+3)) 
