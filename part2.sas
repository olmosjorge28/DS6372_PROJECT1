proc import datafile='\\smu.edu\Files\users$\jeolmos\Apps.SMU\Documents\6372\project_1\aggregatedMonthData.csv' 
out=model_data 
dbms=csv 
replace;
guessingrows=max;
run;




proc reg data=model_data plots(only) = (CooksD(label) DFFits(label));   
model avgPrice = MonthNumber;
output out=RegOut pred=Pred rstudent=RStudent dffits=DFFits cookd=CooksD; /* optional: output statistics */ run;



proc autoreg data=model_data;
model avgPrice = MonthNumber /dwprob;
run;



proc autoreg data=model_data;
model avgPrice = MonthNumber / nlag=(1) dwprob;
run;



data addObsForPred;
input MonthNumber @@; cards;
48
49
50
51
52
53
54
55
56
57
58
59
;
run;

data forPred; set model_data addObsForPred; run;


proc print data = forPred;
run;
proc autoreg data=forPred plots(unpack);
	model avgPrice = MonthNumber / nlag=(1) dwprob;
	output out = preds p = prediction lcl = lower ucl=upper pm = trend;
run;



proc print data = preds;
run;
