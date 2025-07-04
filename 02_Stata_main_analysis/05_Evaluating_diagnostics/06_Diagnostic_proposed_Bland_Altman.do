/* 
Producing Bland-Altman plots for adjusted treatment effect estimates and their standard errors, separately for diagnostic negative and positive identity-binomial models, with standardisation as a reference method (Figs. S26 and S27) 
*/

cd ""
version 18

* Package used:
// ssc install blandaltman

***************************************
* Adjusted treatment effect estimates *
***************************************
* Scenario 1
use simcheck_s1_base_postfile, clear

* Diagnostic negative
preserve
drop if errors==430 | max > 0.999 | (max <= 0.999 & max > 0.96 & n_iter > 10)
blandaltman trt_a trt_stan, plot(difference) xlab(-0.06(0.02)0.06,labsize(4)) ylab(,labsize(4)) ytitle("") xtitle("")   title(Negative, size(4))  saving(theta_neg_s1,replace)
restore

* Diagnostic positive
preserve
drop if errors==430 | max <= 0.96 | (max <= 0.999 & max > 0.96 & n_iter <= 10)
blandaltman trt_a trt_stan, plot(difference) xlab(-0.06(0.02)0.06,labsize(4)) ylab(,labsize(4)) ytitle("") xtitle("")  title(Positive, size(4)) saving(theta_pos_s1,replace) 
restore

graph combine theta_neg_s1.gph theta_pos_s1.gph, title(Scenario 1, size(3.5)) b1title(Average of point estimates, size(3)) l1title(Point estimate from identity-binomial model minus standardisation, size(3))


* Scenario 2
use simcheck_s2_base_postfile, clear

* Diagnostic negative
preserve
drop if errors==430 | max > 0.999 | (max <= 0.999 & max > 0.96 & n_iter > 10)
blandaltman trt_a trt_stan, plot(difference) xlab(,labsize(4)) ylab(-0.08(0.04)0.08,labsize(4)) ytitle("") xtitle("")  title(Negative, size(4)) saving(theta_neg_s2,replace)
restore

* Diagnostic positive
preserve
drop if errors==430 | max <= 0.96 | (max <= 0.999 & max > 0.96 & n_iter <= 10)
blandaltman trt_a trt_stan, plot(difference) xlab(,labsize(4)) ylab(-0.08(0.04)0.08,labsize(4)) ytitle("") xtitle("") title(Positive, size(4)) saving(theta_pos_s2,replace) 
restore

graph combine theta_neg_s2.gph theta_pos_s2.gph, title(Scenario 2, size(3.5)) b1title(Average of point estimates, size(3)) l1title(Point estimate from identity-binomial model minus standardisation, size(3))


* Scenario 3
use simcheck_s3_base_postfile, clear

* Diagnostic negative
preserve
drop if errors==430 | max > 0.999 | (max <= 0.999 & max > 0.96 & n_iter > 10)
blandaltman trt_a trt_stan, plot(difference) xlab(0(0.05)0.15,labsize(4)) ylab(-0.01(0.005)0.01,labsize(4)) ytitle("") xtitle("") title(Negative, size(4)) saving(theta_neg_s3,replace)
restore

* Diagnostic positive
preserve
drop if errors==430 | max <= 0.96 | (max <= 0.999 & max > 0.96 & n_iter <= 10)
blandaltman trt_a trt_stan, plot(difference) title(Positive, size(4)) ytitle("") xtitle("")  xlab(0(0.05)0.15,labsize(4)) ylab(-0.01(0.005)0.01,labsize(4)) saving(theta_pos_s3,replace) 
restore

graph combine theta_neg_s3.gph theta_pos_s3.gph, title(Scenario 3, size(3.5)) b1title(Average of point estimates, size(3)) l1title(Point estimate from identity-binomial model minus standardisation, size(3))


* Scenario 4
use simcheck_s4_base_08_postfile, clear

* Diagnostic negative
preserve
drop if errors==430 | max > 0.999 | (max <= 0.999 & max > 0.96 & n_iter > 10)
blandaltman trt_a trt_stan, plot(difference) xlab(-0.08(0.04)0.08,labsize(4)) ylab(-0.1(0.05)0.1,labsize(4)) ytitle("") xtitle("") title(Negative, size(4)) saving(theta_neg_s4,replace)
restore

* Diagnostic positive
preserve
drop if errors==430 | max <= 0.96 | (max <= 0.999 & max > 0.96 & n_iter <= 10)
blandaltman trt_a trt_stan, plot(difference) title(Positive, size(4)) xlab(-0.08(0.04)0.08,labsize(4)) ylab(-0.1(0.05)0.1,labsize(4)) ytitle("") xtitle("") saving(theta_pos_s4,replace) 
restore

graph combine theta_neg_s4.gph theta_pos_s4.gph, title(Scenario 4, size(3.5)) b1title(Average of point estimates, size(3)) l1title(Point estimate from identity-binomial model minus standardisation, size(3))


*******************
* Standard errors *
*******************
* Scenario 1
use simcheck_s1_base_postfile, clear

* Diagnostic negative
preserve
drop if errors==430 | max > 0.999 | (max <= 0.999 & max > 0.96 & n_iter > 10)
blandaltman se_a se_stan, plot(difference)  ytitle("") xtitle("") xlab(0.006(0.004)0.022,labsize(4)) ylab(-0.03(0.01)0.01,labsize(4))  title(Negative, size(4)) saving(se_neg_s1,replace)
restore

* Diagnostic positive
preserve
drop if errors==430 | max <= 0.96 | (max <= 0.999 & max > 0.96 & n_iter <= 10)
blandaltman se_a se_stan, plot(difference) ytitle("") xtitle("") xlab(0.006(0.004)0.022,labsize(4)) ylab(-0.03(0.01)0.01,labsize(4))  title(Positive, size(4)) saving(se_pos_s1,replace) 
restore

graph combine se_neg_s1.gph se_pos_s1.gph, title(Scenario 1, size(3.5))  b1title(Average of SEs, size(3)) l1title(SE from identity-binomial model minus standardisation, size(3))


* Scenario 2
use simcheck_s2_base_postfile, clear

* Diagnostic negative
preserve
drop if errors==430 | max > 0.999 | (max <= 0.999 & max > 0.96 & n_iter > 10)
blandaltman se_a se_stan, plot(difference)  ytitle("") xtitle("") xlab(0.006(0.004)0.018,labsize(4)) ylab(0(0.005)-0.02,labsize(4))  title(Negative, size(4)) yline(0, lpattern(solid)) saving(se_neg_s2,replace)
restore

* Diagnostic positive
preserve
drop if errors==430 | max <= 0.96 | (max <= 0.999 & max > 0.96 & n_iter <= 10)
blandaltman se_a se_stan, plot(difference)  ytitle("") xtitle("")  xlab(0.006(0.004)0.018,labsize(4)) ylab(0(0.005)-0.02,labsize(4)) yline(0, lpattern(solid)) title(Positive, size(4)) saving(se_pos_s2,replace) 
restore

graph combine se_neg_s2.gph se_pos_s2.gph, title(Scenario 2, size(3.5)) b1title(Average of SEs, size(3)) l1title(SE from identity-binomial model minus standardisation, size(3))


* Scenario 3
use simcheck_s3_base_postfile, clear

* Diagnostic negative
preserve
drop if errors==430 | max > 0.999 | (max <= 0.999 & max > 0.96 & n_iter > 10)
blandaltman se_a se_stan, plot(difference)  ytitle("") xtitle("") xlab(0.012(0.002)0.022,labsize(4)) ylab(-0.003(0.001)0.001,labsize(4)) title(Negative, size(4)) saving(se_neg_s3,replace)
restore

* Diagnostic positive
preserve
drop if errors==430 | max <= 0.96 | (max <= 0.999 & max > 0.96 & n_iter <= 10)
blandaltman se_a se_stan, plot(difference) xlab(0.012(0.002)0.022,labsize(4)) ylab(-0.003(0.001)0.001,labsize(4))  title(Positive, size(4)) ytitle("") xtitle("") saving(se_pos_s3,replace) 
restore

graph combine se_neg_s3.gph se_pos_s3.gph, title(Scenario 3, size(3.5)) b1title(Average of SEs, size(3)) l1title(SE from identity-binomial model minus standardisation, size(3))


* Scenario 4
use simcheck_s4_base_08_postfile, clear

* Diagnostic negative
preserve
drop if errors==430 | max > 0.999 | (max <= 0.999 & max > 0.96 & n_iter > 10)
blandaltman se_a se_stan, plot(difference) ytitle("") xtitle("") xlab(0.012(0.002)0.022,labsize(4)) ylab(-0.006(0.002)0.002,labsize(4)) title(Negative, size(4)) saving(se_neg_s4,replace)
restore

* Diagnostic positive
preserve
drop if errors==430 | max <= 0.96 | (max <= 0.999 & max > 0.96 & n_iter <= 10)
blandaltman se_a se_stan, plot(difference) xlab(0.012(0.002)0.022,labsize(4)) ylab(-0.006(0.002)0.002,labsize(4)) title(Positive, size(4))  ytitle("") xtitle("") saving(se_pos_s4,replace) 
restore

graph combine se_neg_s4.gph se_pos_s4.gph, title(Scenario 4, size(3.5)) b1title(Average of SEs, size(3)) l1title(SE from identity-binomial model minus standardisation, size(3))
