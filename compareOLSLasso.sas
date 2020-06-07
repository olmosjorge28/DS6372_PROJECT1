/***********************************************
This program compares LASSO and OLS method variable selection results
using error ss and adjusted RSQ;
It uses coefficients from estimation using 75% of the input data;
It estimates adjusted RSQ using 25% of the input data;
RSQ and Adjusted RSQ results are shown for models using 
 LASSO variables and LASSO coefficients
 LASSO variables and OLS estimated coefficients
 OLS variables and OLS coefficients;
***********************************************/;

libname xl XLSX '//client/C$/Users/Martin/Documents/SMU/modeling6372/session2/winequalityRed.xlsx';

%let inputDataset = xl.data;
%let numObs = 201;  *** number of observations + 1;
%let numVarsLasso = 3; *** number of variables selected by Lasso;
%let lassoVars = vacid totSulfur alcohol	; *** list of variables from LASSO Selection;
%let numVarsOLS = 4; *** number of variables selected using OLS methods;
%let OLSVars = facid vacid totSulfur alcohol; *** list of variables from selected using OLS methods;
%let depVar = quality;  *** dependent (response) variable for models;

data inDat; set &inputDataset;  randNumber = ranuni(11); if _n_ < &numObs; run;
data train; set inDat; if randNumber <= 1/4 then delete; run;
data test; set inDat; if randNumber > 1/4 then delete; run;

ods graphics on;
title "Selection Method LASSO Using LASSO Variables and Cross Validation";                                                                                                                                                                                                         
proc glmselect data=train testdata = test                                                                                                                                                                            
               seed=1 plots(stepAxis=number)=(criterionPanel ASEPlot CRITERIONPANEL);                                                                                                                                    
model &depVar = &lassoVars	 
           / selection=LASSO( choose=CV stop=CV ) CVdetails; 
           score data=test out=scoredLASSO;
run;                                                                                                                                                                                                                     
quit;                                                                                                                                                                                                                    
ods graphics off;

ods graphics on;
title "Selection Method Step Using LASSO Variables and OLS";                                                                                                                                                                                                         
proc glmselect data=train testdata = test                                                                                                                                                                          
               plots(stepAxis=number)=(criterionPanel ASEPlot CRITERIONPANEL);                                                                                                                                    
model &depVar = &lassoVars	
            / selection=stepwise( choose=adjrsq stop=adjrsq include = &numVarsLasso) CVdetails;  
            score data=test out=scoredOLSLasso;
run;                                                                                                                                                                                                                     
quit; 

ods graphics on;
title "Selection Method Step Using OLS Variables and OLS";                                                                                                                                                                                                         
proc glmselect data=train testdata = test                                                                                                                                                                          
               plots(stepAxis=number)=(criterionPanel ASEPlot CRITERIONPANEL);                                                                                                                                    
model &depVar = &OLSVars	
            / selection=stepwise( choose=adjrsq stop=adjrsq include = &numVarsOLS) CVdetails;  
            score data=test out=scoredOLS;
run;                                                                                                                                                                                                                     
quit;

/*** Calculate Sums of Squares from LASSO and OLS outputs  ***/;
proc sql;
 create table fitLasso as 
  select count(&depVar) as n,css(&depVar) as totSS,sum((&depVar - p_&depvar)**2) as errSSLasso 
  from scoredLasso; 
 create table fitOLSLasso as select sum((quality - p_&depvar)**2) as errSSOLSLasso 
  from scoredOLSLasso;
 create table fitOLS as select sum((quality - p_&depvar)**2) as errSSOLS 
  from scoredOLS;
quit; 
run;

*** Calculate rsq and adjRsq using sums of squares from LASSO and OLS outputs ***/;
data allMeasures; merge fitLasso fitOLSLasso fitOLS; 
 rsqLasso = (1-errSSLasso/totSS);
 rsqOLSLasso = (1-errSSOLSLasso/totSS);
 rsqOLS= (1-errSSOLS/totSS);
 adjRsqLasso = (1-errSSLasso/totSS)*((n-1)/(n-&numVarsLasso-1));
 adjRsqOLSLasso = (1-errSSOLSLasso/totSS)*((n-1)/(n-&numVarsLasso-1));
 adjRsqOLS= (1-errSSOLS/totSS)*((n-1)/(n-&numVarsOLS-1));
run;   

title "Goodness of Fit Measues Using Test Data";
proc print data = allMeasures; run;       
