/*
Preliminary analysis using two simple datasets in Stata
*/

version 18

* 1. Dataset (a)
clear
input randtrt outcome n
0 0 0
0 1 100 
1 0 10
1 1 90
end 
l
// Treatment (randtrt) is a perfect predictor

* Simple analysis methods
cs outcome randtrt [fw=n]
reg outcome randtrt [fw=n]

* Identity-binomial models with four different settings 
** IRLS without asis refuses to estimate
glm outcome randtrt [fw=n], family(binomial) link(identity) irls
** IRLS with asis gets it right
glm outcome randtrt [fw=n], family(binomial) link(identity) irls asis
** NR without asis also refuses to estimate
glm outcome randtrt [fw=n], family(binomial) link(identity) ml
** NR with asis fails to converge
glm outcome randtrt [fw=n], family(binomial) link(identity) ml asis iter(200) nolog


* 2. Dataset (b)
clear
input cov randtrt ntot n1
0 0 100 90
0 1 100 94
1 0 100 100
1 1 100 100
end 
gen n0 = ntot - n1
drop ntot
reshape long n, i(cov randtrt) j(outcome)
l
// Covariate (cov) is a perfect predictor

* Display data
table outcome (cov randtrt) [fw=n]

* Simple unadjusted analysis
cs outcome randtrt [fw=n]

* Simple adjusted analysis with linear regression
reg outcome randtrt cov [fw=n]

* Identity-binomial models with four different settings 
* IRLS without asis wrongly drops a subgroup
glm outcome randtrt cov [fw=n], family(binomial) link(identity) irls
* IRLS with asis keeps the subgroup but still gets it wrong
glm outcome randtrt cov [fw=n], family(binomial) link(identity) irls asis
* NR without asis similarly drops the subgroup
glm outcome randtrt cov [fw=n], family(binomial) link(identity) ml
* NR with asis fails to converge
glm outcome randtrt cov [fw=n], family(binomial) link(identity) ml asis iter(200) nolog
