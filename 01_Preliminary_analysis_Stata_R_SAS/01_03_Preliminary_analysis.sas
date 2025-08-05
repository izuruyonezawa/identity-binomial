/* Preliminary analysis using two simple datasets in SAS */

* 1. Dataset (a);
DATA mydata;
  INPUT randtrt outcome n;
  DATALINES;
0 0 0
0 1 100
1 0 10
1 1 90
;
run;

/* Frequency Table */
PROC freq data=mydata;
  tables randtrt*outcome;
  weight n;
RUN;
** Treatment (randtrt) is a perfect predictor;

* Fit GLM with binomial distribution and identity link;
PROC genmod data=mydata descending;
  CLASS randtrt;
  MODEL outcome = randtrt / DIST=BINOMIAL LINK=IDENTITY scale=pearson;
  freq n;
  estimate 'trt effect' randtrt -1 1;
RUN;
** The log file states, 'The specified model did not converge.';

* 2. Dataset (b);
DATA mydata2;
  INPUT cov randtrt outcome n;
  DATALINES;
0 0 1 90 
0 0 0 10
0 1 1 94
0 1 0 6 
1 0 1 100
1 0 0 0
1 1 1 100
1 1 0 0
;
RUN;

/* Frequency Table */
PROC freq data=mydata2;
  tables cov*randtrt*outcome;
  weight n;
RUN;
** Covariate (cov) is a perfect predictor;

* Fit GLM with binomial distribution and identity link;
PROC genmod data=mydata2 descending;
  CLASS cov randtrt;
  MODEL outcome = randtrt cov / DIST=BINOMIAL LINK=IDENTITY AGGREGATE=(randtrt cov) SCALE=PEARSON;
  FREQ n;
  ESTIMATE 'trt effect' randtrt -1 1;
RUN;
** The log file states, 'The specified model did not converge.';
