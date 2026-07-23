/* -----------------------------------------------------------------------------
 * Bundle derived from SAS_Code.sas in this repository.
 * The insurance beneficiaries data is inlined here as DATALINES (a sample of the
 * repository's healthinsurance.csv) so the script is self-contained; the
 * labelling, derived indicator columns, and the PROC below are the author's own
 * code, with the libref rewritten from healthin.healthinsurancedata to WORK.
 * --------------------------------------------------------------------------- */
data healthin;
  length sex $6 smoker $3 region $9;
  infile datalines dsd truncover;
  input age sex $ bmi children smoker $ region $ charges;
datalines;
19,female,27.9,0,yes,southwest,16884.924
18,male,33.77,1,no,southeast,1725.5523
28,male,33,3,no,southeast,4449.462
33,male,22.705,0,no,northwest,21984.47061
32,male,28.88,0,no,northwest,3866.8552
31,female,25.74,0,no,southeast,3756.6216
46,female,33.44,1,no,southeast,8240.5896
37,female,27.74,3,no,northwest,7281.5056
37,male,29.83,2,no,northeast,6406.4107
60,female,25.84,0,no,northwest,28923.13692
25,male,26.22,0,no,northeast,2721.3208
62,female,26.29,0,yes,southeast,27808.7251
23,male,34.4,0,no,southwest,1826.843
56,female,39.82,0,no,southeast,11090.7178
27,male,42.13,0,yes,southeast,39611.7577
19,male,24.6,1,no,southwest,1837.237
52,female,30.78,1,no,northeast,10797.3362
23,male,23.845,0,no,northeast,2395.17155
56,male,40.3,0,no,southwest,10602.385
30,male,35.3,0,yes,southwest,36837.467
60,female,36.005,0,no,northeast,13228.84695
30,female,32.4,1,no,southwest,4149.736
18,male,34.1,0,no,southeast,1137.011
34,female,31.92,1,yes,northeast,37701.8768
37,male,28.025,2,no,northwest,6203.90175
59,female,27.72,3,no,southeast,14001.1338
63,female,23.085,0,no,northeast,14451.83515
55,female,32.775,2,no,northwest,12268.63225
23,male,17.385,1,no,northwest,2775.19215
31,male,36.3,2,yes,southwest,38711
22,male,35.6,0,yes,southwest,35585.576
18,female,26.315,0,no,northeast,2198.18985
19,female,28.6,5,no,southwest,4687.797
63,male,28.31,0,no,northwest,13770.0979
28,male,36.4,1,yes,southwest,51194.55914
19,male,20.425,0,no,northwest,1625.43375
62,female,32.965,3,no,northwest,15612.19335
26,male,20.8,0,no,southwest,2302.3
35,male,36.67,1,yes,northeast,39774.2763
60,male,39.9,0,yes,southwest,48173.361
24,female,26.6,0,no,northeast,3046.062
31,female,36.63,2,no,southeast,4949.7587
41,male,21.78,1,no,southeast,6272.4772
37,female,30.8,2,no,southeast,6313.759
38,male,37.05,1,no,northeast,6079.6715
55,male,37.3,0,no,southwest,20630.28351
18,female,38.665,2,no,northeast,3393.35635
28,female,34.77,0,no,northwest,3556.9223
60,female,24.53,0,no,southeast,12629.8967
36,male,35.2,1,yes,southeast,38709.176
18,female,35.625,0,no,northeast,2211.13075
21,female,33.63,2,no,northwest,3579.8287
48,male,28,1,yes,southwest,23568.272
36,male,34.43,0,yes,southeast,37742.5757
40,female,28.69,3,no,northwest,8059.6791
58,male,36.955,2,yes,northwest,47496.49445
58,female,31.825,2,no,northeast,13607.36875
18,male,31.68,2,yes,southeast,34303.1672
53,female,22.88,1,yes,southeast,23244.7902
34,female,37.335,2,no,northwest,5989.52365
;
run;

/* Code 2: Data Labelling (from SAS_Code.sas, libref rewritten to WORK) */
title "heath insurance data";
data healthin;
set healthin;
label
age ='age beneficiary'
age_group='beneficiary age, 0-><=median age, 1->>median age'
sex ='insurance contractor gender'
sex_status = 'insurance contractor gender - 0=female, 1=male'
bmi = 'body mass index'
children = 'number of children covered by health insurance / number of dependents'
smoker = 'smoking status'
smoker_status = 'smoking status - 0=no,1=yes'
region = 'rhe beneficiarys residential area in the us'
region_value ='residential area in the us seperated from 0 to 3 based on each region'
charges = 'individual medical costs billed by health insurance'
charges_seperation= 'charges seperated based on the median medical costs - <=median=0, >median=1 ';
run;

/* Code 3: If Else Loop (derived indicator columns, verbatim logic) */
data healthin;
   set healthin;
   if sex = 'female' then sex_status = 0;
   else if sex = 'male' then sex_status = 1;
run;
data healthin;
   set healthin;
   if region='northwest' then region_value=0;
   else if region='northeast' then region_value=1;
   else if region='southwest' then region_value=2;
   else if region='southeast' then region_value=3;
run;
data healthin;
   set healthin;
   if smoker = 'no' then smoker_status = 0;
   else if smoker = 'yes' then smoker_status = 1;
run;
data healthin;
   set healthin;
   if age<=39 then age_group = 0;
   else if age>39 then age_group = 1;
run;
data healthin;
   set healthin;
   if charges<=9382.03 then charges_seperation_median = 0;
   else if charges>9382.03 then charges_seperation_median = 1;
run;
data healthin;
   set healthin;
   if charges<=13270.42 then charges_seperation_mean = 0;
   else if charges>13270.42 then charges_seperation_mean = 1;
run;
data healthin;
   set healthin;
   if charges<=16657.72 then charges_seperation = 0;
   else if charges>16657.72 then charges_seperation= 1;
run;

/* charges_log transform (Code 7 in SAS_Code.sas) */
data healthin; set healthin; charges_log=log10(charges); run;


proc glm data=healthin;
  class smoker;
  model charges_log = smoker;
  means smoker / hovtest=levene;
run;
