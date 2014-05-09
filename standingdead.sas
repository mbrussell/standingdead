/*THE FOLLOWING PRESENTS AN EXAMPLE FOR UPDATING RANDOM EFFECTS PARAMETERS WHEN
FITTING STANDARD AND ZERO-INFLATED COUNT MODELS WITH BAYESIAN METHODS IN SAS/STAT 9.3*/
/**/
/*COMPANION MANUSCRIPT IS:*/
/**/
/* Influence of prior distributions and random effects */
/* on count regression models: implications for estimating standing dead tree abundance */
/**/
/*EXAMPLE DATASET NAMED PLOT FOLLOWS:*/
/**/
/*VAR NAME		    DESCRIPTION	*/

/*PLOTID			Plot record ID	*/
/*SDT				Number of standing dead trees per hectare*/
/*BAPH			                Basal area (m2 ha-1)*/
/*MAT			   	Mean annual temperature (degrees C)*/
/*PUB				Indicator variable for whether the plot is located on public land (1) or not (0)*/
/*FORTYPCD 			Forest type code, as used in FIA program 
					(http://www.fs.usda.gov/detailfull/r5/landmanagement/gis/?cid=fsbdev3_047974&width=full)*/

data PLOT;
input PLOTID SDT BAPH MAT PUB FORTYPCD;
datalines;
1	15	18.65	6.1	0	102
2	59	24.28	6.1	0	127
3	89	5.54	6	0	121
4	15	16.38	6.1	0	801
5	30	10.03	6.3	0	708
6	74	16.36	6.1	0	901
7	0	10.55	5.9	0	503
8	0	23.6	6.2	0	505
9	30	41.49	6	0	409
10	15	23.38	6.1	0	901
11	59	23.19	6.1	0	901
12	30	3.33	6	0	901
13	30	22.84	6.2	0	708
14	45	27.02	6	0	401
15	59	11.79	6.2	0	901
16	89	6.79	6	0	701
17	0	7.07	6	0	805
18	0	17.79	6.1	0	381
19	0	13.05	6.1	0	101
20	0	1.53	6.4	1	701
21	0	35.05	6	0	505
22	59	9.25	6.3	1	706
23	15	16.09	6.2	0	901
24	59	30.69	6.3	0	801
25	15	9.65	6	0	805
26	59	5.98	6.1	0	904
27	15	13.55	7.2	0	901
28	59	29.58	6.3	0	127
29	74	5.39	6.2	0	701
30	0	6.11	6.3	0	517
31	15	19.18	6.1	0	706
32	59	12.05	6.1	0	701
33	15	13.14	7.3	0	901
34	15	47.23	6.1	0	127
35	0	12.55	6.2	1	102
36	15	13.87	7.2	0	902
37	0	7.33	7.3	0	805
38	45	13.25	6.2	1	802
39	149	39.17	6.3	1	102
40	74	12.38	6	0	901
41	149	12.66	7.2	0	901
42	30	20.46	6	0	708
43	74	13.23	6.3	0	701
44	15	4.47	6	0	701
45	30	20.4	6.3	0	127
46	104	16.83	6.2	0	381
47	89	38.21	6	1	901
48	30	30.17	5	0	127
49	15	28.74	5.9	0	999
50	149	17.17	6.1	0	127
51	149	29.88	6.1	0	127
52	15	19.09	6.1	1	801
53	89	11.83	7	0	701
54	0	0.51	6.1	0	127
55	15	18.35	6	0	127
56	104	24.56	7	0	901
57	15	6.26	6.2	0	904
58	74	32.47	6.2	1	102
59	45	52.53	7	0	505
60	15	11.55	6.3	1	901
61	15	2.12	6.2	0	127
62	30	0.2	8	0	901
63	30	23.59	5.9	0	127
64	0	8.65	6.1	0	904
65	74	11.41	8	0	901
66	15	1.26	6.1	0	801
67	30	19.15	6.1	0	801
68	59	17.08	7	0	707
69	30	5.32	5	0	702
70	15	18.88	5.9	0	901
71	45	28.76	8	0	901
72	89	10.11	6	0	409
73	0	31.25	5	0	901
74	164	32.77	5	0	102
75	89	36.3	5	0	901
76	59	14.83	5	0	801
77	45	12.55	9.1	0	901
78	104	4.98	6	0	121
79	149	29.19	6	0	701
80	0	2.28	6.2	0	701
81	30	21.68	5	1	122
82	15	7.48	6.1	0	901
83	59	26.92	6.2	0	127
84	30	15.6	6.2	0	503
85	59	10.35	6.4	1	409
86	89	22.74	6.2	0	801
87	0	1.26	6.1	0	704
88	104	11.04	6.1	0	517
89	0	14.86	6.3	0	706
90	30	4.07	6	1	962
91	45	16.98	6.1	0	901
92	89	26.24	6.2	1	102
93	89	29.55	6.1	0	102
94	59	10.56	6.1	0	701
95	134	21.55	6.2	1	708
96	164	10.9	6	0	801
97	149	18.54	6.2	0	102
98	0	0.65	6.2	1	126
99	45	23.16	6.1	1	401
100	30	10.2	6.1	0	901
;
run;

/*The MCMC procedure is a general purpose Markov chain Monte Carlo procedure designed to fit Bayesian models. */
/*Coefficients and variance parameters are specified with the parms statement, and prior distributions with the */
/*prior statement. Noninformative priors are here specified as Normal. */
/*Regression coefficients refer to either the abundance (pbeta) or logistic (lbeta) components. */
/*Means on the measurement scale are denoted mu and PI, respectively.  */
/*The llike component specifies that the zero-inflated Poisson model be fit to the response variable SDT. */
/*The model statement specifies the conditional distribution of the data given the parameters.*/

/*NOTE: Trace plots may not appear well mixed if using only the small example data above.
They serve for illustration purposes, only.*/

/*First four examples predict random effects using PROC MCMC, specifying noninformative priors*/

/*For all examples, a 5,000 Monte Carlo run is run following a 500-run burn-in*/

/*The Poission distribution follows:*/
/*Posteriors for fixed and random effects are output in post_P_NonInf_re:*/

ods graphics on;
proc mcmc data=PLOT seed =4572 nmc=5000 nbi=500 thin=3 dic propcov=quanew monitor =(_parms_ Pearson delta) 
outpost=post_P_NonInf_RE;
parms pbeta0 4.0352 pbeta1 0.010500 pbeta2 -0.031926 pbeta3 0.571985 s2 1;
prior pbeta: ~ normal(0,var=1000);
prior s2: ~ igamma(0.1,s=0.01);

random delta~normal(0,var=s2) subject=FORTYPCD ;
mu=exp(pbeta0 + delta + pbeta1*BAPH + pbeta2*MAT + pbeta3*PUB);

	model SDT~poisson(mu);
   if PLOTID = 1 then Pearson = 0;
   Pearson =  Pearson + ((SDT - mu)**2/mu);
run;
ods graphics off;


/*The negative binomial distribution follows.*/
/*PROC FCMP code from: */
/*Kleinman, K. and Horton, N.J. 2009 SAS and R: Data Management, Statistical Analysis, and Graphics. Chapman and Hall, 343 p.*/
/*and*/ 
/*http://sas-and-r.blogspot.com/2011/11/example-913-negative-binomial.html*/

/*Posteriors for fixed and random effects are output in post_NB_NonInf_re:*/
proc fcmp outlib=sasuser.funcs.test;
function poismean_nb(mean, size);
  return(size/(mean+size));
  endsub;
run;

options cmplib=sasuser.funcs;
run;

ods graphics on;
proc mcmc data=PLOT seed =4572 nmc=5000 nbi=500 thin=3 dic propcov=quanew monitor =(_parms_ Pearson) 
outpost=post_NB_NonInf_RE;
parms pbeta0 4.389 pbeta1 0.023 pbeta2 -0.1232 pbeta3 0.1532 alpha 1.75 s2 1;
prior pbeta: ~ normal(0,var=1000);
prior alpha ~ igamma(.01, scale=0.01);
prior s2: ~ igamma(0.1,s=0.01);

random delta~normal(0,var=s2) subject=FORTYPCD ;
alpha2=round(alpha+1, 1);
mu=exp(pbeta0 + delta+pbeta1*BAPH + pbeta2*MAT + pbeta3*PUB);
model SDT~negbin(alpha2, poismean_nb(mu, alpha2));
   if PLOTID = 1 then Pearson = 0;
   Pearson =  Pearson + ((SDT - mu)**2/mu);
run;
ods graphics off;

/*The zero-inflated Poission distribution follows.*/
/*Posteriors for fixed and random effects are output in post_ZIP_NonInf_re:*/

ods graphics on;
proc mcmc data=PLOT seed =4572 nmc=5000 nbi=5000 thin=3 dic propcov=quanew 
monitor =(_parms_ Pearson delta chi) outpost=post_ZIP_NonInf_RE;
parms pbeta0 4.62 pbeta1 0.0096 pbeta2 -0.087 pbeta3 0.105 lbeta0 -0.308 lbeta1 -0.083 delta_s2 1 chi_s2 1;
prior pbeta: ~ normal(0,var=1000);
prior lbeta: ~ normal(0,var=1000);
prior delta_s2: ~ igamma(0.1,s=0.01);
prior chi_s2: ~ igamma(0.1,s=0.01);

random delta~normal(0,var=delta_s2) subject=FORTYPCD ;
random chi~normal(0,var=chi_s2) subject=FORTYPCD ;

link1 = lbeta0 + chi + lbeta1*BAPH;
 PI  = ( 1/(1+exp(-link1)));
mu=exp(pbeta0 + delta+ pbeta1*BAPH + pbeta2*MAT + pbeta3*PUB );
llike=log(pi*(SDT eq 0) + (1-pi)*pdf("poisson",SDT,mu));
model general(llike);
   if PLOTID = 1 then Pearson = 0;
   Pearson =  Pearson + ((SDT - mu)**2/mu);
run;
ods graphics off;

/*The zero-inflated negative binomial distribution follows.*/
/*Posteriors for fixed and random effects are output in post_ZINB_NonInf_re:*/
ods graphics on;
proc mcmc data=PLOT seed =4572 nmc=5000 nbi=500 thin=3 dic propcov=quanew monitor =(_parms_ Pearson) 
outpost=post_zinb_NonInf_RE;
parms pbeta0 4.389 pbeta1 0.023 pbeta2 -0.1232 pbeta3 0.1532 lbeta0 -0.308 lbeta1 -0.083 alpha 1.75 delta_s2 1 chi_s2 1;
prior pbeta: ~ normal(0,var=1000);
prior lbeta: ~ normal(0,var=1000);
prior alpha ~ igamma(.01, scale=0.01);
prior delta_s2: ~ igamma(0.1,s=0.01);
prior chi_s2: ~ igamma(0.1,s=0.01);

random delta~normal(0,var=delta_s2) subject=FORTYPCD;
random chi~normal(0,var=chi_s2) subject=FORTYPCD;

alpha2=round(alpha+1, 1);

link1 = lbeta0 + chi + lbeta1*BAPH ;
 PI  = ( 1/(1+exp(-link1)));
mu=exp(pbeta0 + delta+ pbeta1*BAPH + pbeta2*MAT + pbeta3*PUB );
llike=log(pi*(SDT eq 0) + (1-pi)*pdf("poisson",SDT,mu));

model SDT~negbin(alpha2, poismean_nb(mu, alpha2));
   if PLOTID = 1 then Pearson = 0;
   Pearson =  Pearson + ((SDT - mu)**2/mu);
run;
ods graphics off;


/*The next four examples predict random effects using PROC MCMC, this time specifying informative priors from previous model fit*/

/*The Poission distribution follows:*/
/*Posteriors for fixed and random effects are output in post_P_Inf_re:*/
ods graphics on;
proc mcmc data=PLOT seed =4572 nmc=5000 nbi=500 thin=3 dic propcov=quanew monitor =(_parms_ Pearson delta) 
outpost=post_P_Inf_RE;
parms pbeta0 4.0352 pbeta1 0.010500 pbeta2 -0.031926 pbeta3 0.571985 s2 1;
prior pbeta0 ~ normal(3.9302,sd=0.1332);
prior pbeta1 ~ normal(0.0229,sd=0.000089);
prior pbeta2 ~ normal(-0.0944,sd=0.0000714);
prior pbeta3 ~ normal(0.1281,sd=0.00207);
prior s2: ~ igamma(0.4305,s=0.1017);

random delta~normal(0,var=s2) subject=FORTYPCD ;
mu=exp(pbeta0 + delta + pbeta1*BAPH + pbeta2*MAT + pbeta3*PUB);

	model SDT~poisson(mu);
   if PLOTID = 1 then Pearson = 0;
   Pearson =  Pearson + ((SDT - mu)**2/mu);
run;
ods graphics off;

/*The negative binomial distribution follows.*/
/*Posteriors for fixed and random effects are output in post_NB_Inf_re:*/
ods graphics on;
proc mcmc data=PLOT seed =4572 nmc=5000 nbi=500 thin=3 dic propcov=quanew monitor =(_parms_ Pearson) 
outpost=post_NB_Inf_RE;
parms pbeta0 4.389 pbeta1 0.023 pbeta2 -0.1232 pbeta3 0.1532 alpha 1.75 s2 1;
prior pbeta0 ~ normal(3.9973,sd=0.0562);
prior pbeta1 ~ normal(0.0285,sd=0.00085);
prior pbeta2 ~ normal(-0.0917,sd=0.0055);
prior pbeta3 ~ normal(0.1531,sd=0.0166);
prior alpha ~ igamma(0.1348, s=0.1313);
prior s2: ~ igamma(0.0708,s=0.0201);

random delta~normal(0,var=s2) subject=FORTYPCD ;
alpha2=round(alpha+1, 1);
mu=exp(pbeta0 + delta+pbeta1*BAPH + pbeta2*MAT + pbeta3*PUB);
model SDT~negbin(alpha2, poismean_nb(mu, alpha2));
   if PLOTID = 1 then Pearson = 0;
   Pearson =  Pearson + ((SDT - mu)**2/mu);
run;
ods graphics off;

/*The zero-inflated Poission distribution follows.*/
/*Posteriors for fixed and random effects are output in post_ZIP_Inf_re:*/

ods graphics on;
proc mcmc data=PLOT seed =4572 nmc=5000 nbi=500 thin=3 dic propcov=quanew 
monitor =(_parms_ Pearson delta chi) outpost=post_ZIP_Inf_RE;
parms pbeta0 4.62 pbeta1 0.0096 pbeta2 -0.087 pbeta3 0.105 lbeta0 -0.308 lbeta1 -0.083 lbeta3 -0.04 delta_s2 1 chi_s2 1;
prior pbeta0 ~ normal(4.2771,sd=0.0339);
prior pbeta1 ~ normal(0.0132,sd=0.000091);
prior pbeta2 ~ normal(-0.0664,sd=0.000717);
prior pbeta3 ~ normal(0.0887,sd=0.00203);
prior lbeta0 ~ normal(0.0500,sd=0.0884);
prior lbeta1 ~ normal(-0.0957,sd=0.00286);
prior lbeta3 ~ normal(-0.4445,sd=0.0474);
prior delta_s2: ~ igamma(0.118,s=0.0257);
prior chi_s2: ~ igamma(0.1604,s=0.1667);

random delta~normal(0,var=delta_s2) subject=FORTYPCD ;
random chi~normal(0,var=chi_s2) subject=FORTYPCD ;

link1 = lbeta0 + chi + lbeta1*BAPH;
 PI  = ( 1/(1+exp(-link1)));
mu=exp(pbeta0 + delta+ pbeta1*BAPH + pbeta2*MAT + pbeta3*PUB );
llike=log(pi*(SDT eq 0) + (1-pi)*pdf("poisson",SDT,mu));
model general(llike);
   if PLOTID = 1 then Pearson = 0;
   Pearson =  Pearson + ((SDT - mu)**2/mu);
run;
ods graphics off;

/*The zero-inflated negative binomial distribution follows.*/
/*Posteriors for fixed and random effects are output in post_ZINB_Inf_re:*/
ods graphics on;
proc mcmc data=PLOT seed =4572 nmc=5000 nbi=500 thin=3 dic propcov=quanew monitor =(_parms_ Pearson) 
outpost=post_ZINB_Inf_RE;
parms pbeta0 4.389 pbeta1 0.023 pbeta2 -0.1232 pbeta3 0.1532 lbeta0 -0.308 lbeta1 -0.083 alpha 1.75 delta_s2 1 chi_s2 1;
prior pbeta0 ~ normal(3.9313,sd=0.0567);
prior pbeta1 ~ normal(0.0285,sd=0.000607);
prior pbeta2 ~ normal(-0.0905,sd=0.00390);
prior pbeta3 ~ normal(0.1515,sd=0.0120);
prior lbeta0 ~ normal(0.0425,sd=0.1937);
prior lbeta1 ~ normal(0.3523,sd=0.1835);

prior alpha ~ igamma(1.0259, s=0.1665);
prior delta_s2: ~ igamma(0.1158,s=0.0349);
prior chi_s2: ~ igamma( 5963.7,s=25857.3);

random delta~normal(0,var=delta_s2) subject=FORTYPCD;
random chi~normal(0,var=chi_s2) subject=FORTYPCD;

alpha2=round(alpha+1, 1);

link1 = lbeta0 + chi + lbeta1*BAPH ;
 PI  = ( 1/(1+exp(-link1)));
mu=exp(pbeta0 + delta+ pbeta1*BAPH + pbeta2*MAT + pbeta3*PUB );
llike=log(pi*(SDT eq 0) + (1-pi)*pdf("poisson",SDT,mu));

model SDT~negbin(alpha2, poismean_nb(mu, alpha2));
   if PLOTID = 1 then Pearson = 0;
   Pearson =  Pearson + ((SDT - mu)**2/mu);
run;
ods graphics off;



