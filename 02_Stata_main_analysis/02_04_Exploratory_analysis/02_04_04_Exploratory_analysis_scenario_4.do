/*
Exploratory analysis for developing potential diagnostics for identity-binomial models with IRLS (scenario 4)
*/

cd ""
version 18
* Package used:
// ssc install blandaltman

use simcheck_s4_base_08_postfile, clear

* Predicted values for t0b0 and t1b1 strata under scenario 4, comparing the two methods (Fig. S17) 
scatter t0b0 t1b1 if errors == 0, mcolor("0 114 178%50") msymbol(O) || ///
scatter t0b0 t1b1 if errors == 430, mcolor("213 94 0%60") msymbol(D) jitter(0) title(Identity-binomial, size(6)) xtitle("",size(5)) ytitle("",size(5)) xlabel(0.85(0.05)1.05,labsize(5)) ylabel(0.85(0.05)1.05,labsize(5)) subtitle(,size(vsmall)) legend(position(2) ring(0) bmargin(0 0 0 30) order( 2 "Not converged") size(4.5))  xline(1.0) yline(1.0) graphregion(margin(0 3 1 0)) ///
  saving(pred_ib_s4, replace)

scatter t1b1_s t0b0_s, mcolor("0 114 178%50") msymbol(O) jitter(0) title(Standardisation, size(6)) xtitle("",size(5)) ytitle("",size(5)) xlabel(0.85(0.05)1.05,labsize(5)) ylabel(0.85(0.05)1.05,labsize(5)) subtitle(,size(vsmall))  legend(order(1 "Converged" 2 "Not converged") size(4))  xline(1.0) yline(1.0) saving(pred_stan_s4, replace) graphregion(margin(0 2 1 0)) 

graph combine pred_ib_s4.gph pred_stan_s4.gph, title("", size(medium)) cols(2) rows(1) xsize(3) ysize(1.5) l1title(t1b1,size(4)) b1title(t0b0, size(4))

* Line graphs of outcome values across the four strata under scenario 4 (Fig. S18)

********************************************
* Diagram explaining least false estimates *
********************************************
import excel using "Interaction_true_solution.xlsx", clear firstrow case(lower)

rename (*) (subgroup true solution)
line true subgroup, lcolor("0 0 0") || line solution subgroup,lcolor("213 94 0") ///
title("{bf:A}",size(4) position(11)) ///
subtitle("True outcome values (black)" "and least false estimates (red)", size(3.5)) ///
xtitle("", size(medium)) xlab(0 "t0b0" 1 "t1b0" 2 "t0b1" 3 "t1b1") ///
ytitle("", size(medium)) ///
ylab(0.85(0.05)1) ///
graphregion(margin(0 1 1 0)) ///
legend(off) ///
saving(diagram,replace)

*****************************************************************
* Line graph of predicted values from identity-binomial models  *
* in repetitions where t0b0 > 0.999                             *
*****************************************************************
use simcheck_s4_base_08_postfile, clear

preserve
rename t0b0 prediction_0
rename t1b0 prediction_1
rename t0b1 prediction_2
rename t1b1 prediction_3

drop if prediction_0 <= 0.999 
drop trt_u se_u errors N n_iter trt_a se_a max trt_stan se_stan t0b0_s t1b0_s t0b1_s t1b1_s
reshape long prediction_, i(rep) j(prediction)

twoway line prediction_  prediction, lcolor("0 114 178%30") yline(0.95, lcolor("213 94 0") lpattern(solid)) xlabel(0 "t0b0" 1 "t1b0" 2 "t0b1" 3 "t1b1") connect(L) title("{bf:B}",size(4) position(11)) /// 
subtitle("Identity-binomial""t0b0 > 0.999 (N = 125)", size(3.5)) ytitle("") xtitle("") ///
graphregion(margin(0 0 1 0)) ///
saving(pred_t0b0_high, replace)
restore

*****************************************************************
* Line graph of predicted values from identity-binomial models  *
* in repetitions where t1b1 > 0.999                             *
*****************************************************************
preserve
rename t0b0 prediction_0
rename t1b0 prediction_1
rename t0b1 prediction_2
rename t1b1 prediction_3

drop if prediction_3 <= 0.999 
drop trt_u se_u errors N n_iter trt_a se_a max trt_stan se_stan t0b0_s t1b0_s t0b1_s t1b1_s
reshape long prediction_, i(rep) j(prediction)

twoway line prediction_  prediction, lcolor("0 114 178%30") yline(0.95, lcolor("213 94 0") lpattern(solid)) xlabel(0 "t0b0" 1 "t1b0" 2 "t0b1" 3 "t1b1") connect(L) title("{bf:C}",size(4) position(11)) subtitle("Identity-binomial" "t1b1 > 0.999 (N = 91)", size(3.5))  ytitle("") xtitle("") ///
graphregion(margin(0 1 0 1)) ///
saving(pred_t1b1_high, replace)
restore

********************************************************
* Line graph of predicted values from standardisation  *
* using the same repetitions                           *
********************************************************
preserve
rename t0b0_s prediction_0
rename t1b0_s prediction_1
rename t0b1_s prediction_2
rename t1b1_s prediction_3

drop if t0b0 <= 0.999 & t1b1 <= 0.999 // Use the same repetitions for comparison
drop trt_u se_u errors N n_iter trt_a se_a max trt_stan se_stan t0b0 t1b0 t0b1 t1b1
reshape long prediction_, i(rep) j(prediction)

twoway line prediction_  prediction, lcolor("0 114 178%30") yline(0.95, lcolor("213 94 0") lpattern(solid)) xlabel(0 "t0b0" 1 "t1b0" 2 "t0b1" 3 "t1b1") connect(L) ///
ylab(0.85(0.05)1) ///
title("{bf:D}",size(4) position(11)) ///
subtitle("Standardisation" "Estimates from same repetitions (N = 216)", size(3.5)) ytitle("") xtitle("") ///
graphregion(margin(0 0 0 1)) ///
saving(pred_stan_matched, replace)
restore

graph combine diagram.gph pred_t0b0_high.gph pred_t1b1_high.gph pred_stan_matched.gph, xcommon ycommon l1title(Outcome value, size(3)) b1title(Stratum, size(3)) xsize(1.4) ysize(1)

* Bland-Altman plots for adjusted treatment effect estimates with regression-based limits of agreement, comparing identity-binomial models with standardisation, panelled by the maximum predicted values from identity-binomial models (Fig. S19)

use simcheck_s4_n1248_postfile, clear
// DGM with a sample size of 1248 is used as an example this time
gen max_cat = 0 if max < 0.96
replace max_cat = 1 if max >= 0.96 & max < 0.97
replace max_cat = 2 if max >= 0.97 & max < 0.98
replace max_cat = 3 if max >= 0.98 

preserve
drop if  max_cat == 1 | max_cat == 2 | max_cat == 3
blandaltman trt_a trt_stan, plot(difference) xlab(-0.05(0.05)0.05, labsize(3.5)) ylab(-0.08(0.02)0.08, labsize(3.5)) ytitle("") xtitle("") title(Max less than 0.96, size(4)) graphregion(margin(0 1 0 0)) saving(max0, replace) 
restore

preserve
drop if  max_cat == 0 | max_cat == 2 | max_cat == 3
blandaltman trt_a trt_stan, plot(difference) xlab(-0.05(0.05)0.05, labsize(3.5)) ylab(-0.08(0.02)0.08, labsize(3.5)) ytitle("") xtitle("") title(Max between 0.96 and 0.97, size(4)) graphregion(margin(0 0 0 0))  saving(max1, replace) 
restore

preserve
drop if  max_cat == 0 | max_cat == 1 | max_cat == 3
blandaltman trt_a trt_stan, plot(difference) xlab(-0.05(0.05)0.05, labsize(3.5)) ylab(-0.08(0.02)0.08, labsize(3.5)) ytitle("") xtitle("")  title(Max between 0.97 and 0.98, size(4)) graphregion(margin(0 1 0 0))  saving(max2, replace)
restore

preserve
drop if  max_cat == 0 | max_cat == 1 | max_cat == 2
blandaltman trt_a trt_stan, plot(difference) xlab(-0.05(0.05)0.05, labsize(3.5)) ylab(-0.08(0.02)0.08, labsize(3.5)) ytitle("") xtitle("") title(Max more than 0.98, size(4)) graphregion(margin(0 0 0 0))  saving(max3, replace)
restore

graph combine max0.gph max1.gph max2.gph max3.gph, cols(2) rows(2) ycommon l1title("Point estimate from identity-binomial model minus standardisation ", size(3.2)) b1title(Average of point estimates, size(3.2)) xsize(2) ysize(1.5)

* Plots of differences in adjusted treatment effect estimates between identity-binomial models and standardisation vs. the number of iterations with identity-binomial models. 
// The plots include only cases where the maximum predicted values from identity-binomial models exceeded 0.96 and are panelled by the base DGMs with varying degrees of interactions.

** Base DGM with treatment effects of ±0.00 on risk difference scale in covariate subgroups
use simcheck_s4_base_00_postfile, clear

gen diff_met = trt_a - trt_stan

preserve
drop if max <= 0.96 
scatter diff_met n_iter if n_iter <= 50, xline(10, lcolor("213 94 0")) xlab(0(10)50, labsize(4)) ylab(-0.06(0.02)0.06, labsize(4)) mcolor("0 114 178%30")  graphregion(margin(0 0 0 0)) ytitle("") xtitle("") title("RD = ±0", size(4)) saving(diff_iter_00, replace)
restore

** Base DGM with treatment effects of ±0.02 on risk difference scale in covariate subgroups
use simcheck_s4_base_02_postfile, clear

gen diff_met = trt_a - trt_stan

preserve
drop if max <= 0.96 
scatter diff_met n_iter if n_iter <= 50, xline(10, lcolor("213 94 0")) xlab(0(10)50, labsize(4)) ylab(-0.06(0.02)0.06, labsize(4)) mcolor("0 114 178%30")  graphregion(margin(0 0 0 0)) ytitle("") xtitle("") title("RD = ±2", size(4)) saving(diff_iter_02, replace)
restore

** Base DGM with treatment effects of ±0.04 on risk difference scale in covariate subgroups
use simcheck_s4_base_04_postfile, clear

gen diff_met = trt_a - trt_stan

preserve
drop if max <= 0.96 
scatter diff_met n_iter if n_iter <= 50, xline(10, lcolor("213 94 0")) xlab(0(10)50, labsize(4)) ylab(-0.06(0.02)0.06, labsize(4)) mcolor("0 114 178%30")  graphregion(margin(0 0 0 0)) ytitle("") xtitle("") title("RD = ±4", size(4)) saving(diff_iter_04, replace)
restore

** Base DGM with treatment effects of ±0.06 on risk difference scale in covariate subgroups
use simcheck_s4_base_06_postfile, clear

gen diff_met = trt_a - trt_stan

preserve
drop if max <= 0.96 
scatter diff_met n_iter if n_iter <= 50, xline(10, lcolor("213 94 0")) xlab(0(10)50, labsize(4)) ylab(-0.06(0.02)0.06, labsize(4)) mcolor("0 114 178%30")  graphregion(margin(0 0 0 0)) ytitle("") xtitle("") title("RD = ±6", size(4)) saving(diff_iter_06, replace)
restore

** Base DGM with treatment effects of ±0.08 on risk difference scale in covariate subgroups
use simcheck_s4_base_08_postfile, clear

gen diff_met = trt_a - trt_stan

preserve
drop if max <= 0.96 
scatter diff_met n_iter if n_iter <= 50, xline(10, lcolor("213 94 0")) xlab(0(10)50, labsize(4)) ylab(-0.06(0.02)0.06, labsize(4)) mcolor("0 114 178%30")  graphregion(margin(0 0 0 0)) ytitle("") xtitle("") title("RD = ±8", size(4)) saving(diff_iter_08, replace)
restore

graph combine diff_iter_00.gph diff_iter_02.gph diff_iter_04.gph diff_iter_06.gph diff_iter_08.gph, rows(2) cols(3) xsize(1.5) ysize(1.0) xcommon b1title(Number of iterations, size(3.2) margin(0 0 0 1)) l1title("Point estimate from identity-binomial model minus standardisation ", size(3.2))
