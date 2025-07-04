/*
Meauring non-convergence rates after producing estimates datasets
*/

cd ""
version 18

* Use estimates dataset produced in the previous step
** Here, the one produced for scenario 1 is used
use simcheck_s1_base_postfile, clear

* Check error types
tab errors, m

* Produce a variable for non-convergence
gen nc = 0 if errors == 0
replace nc = 1 if errors == 430
// errors == 430 means convergence issues

* Tabulate
tab nc, m

* Calculate confidence interval
ci proportions nc
