

FILENAME REFFILE '/home/u44429873/Applied statistical/project1/imputed_dataset.csv';

PROC IMPORT DATAFILE=REFFILE
	DBMS=CSV
	OUT=imputeddata;
	GETNAMES=YES;
RUN;

PROC CONTENTS DATA=imputeddata; RUN;

data impute2;
set imputeddata;
lprice=log(price_doc);
lfullall=log(full_all);
ltimestamp=log(timestamp);
lchildschool=log(children_school);
if railroad_terminal_raion ="yes" THEN railroad_terminal_raion=1; else railroad_terminal_raion=0;   
if big_market_raion="yes"  THEN big_market_raion=1; else big_market_raion=0;
if product_type="Investment" THEN product_type=1; else product_type=0;
if life_sq_imputed > full_sq then delete;
if kitch_sq_imputed >full_sq then delete;
if num_room_imputed >15 and full_sq<100 then delete;
if full_sq<10 then delete;
if full_all<X0_6_all then delete;
if full_all<X0_17_all  then delete;
if full_all<X16_29_all then delete;
 if full_all<X0_13_all then delete;
 if build_year_imputed>2020 or build_year_imputed<1600 then delete;
 proc contents data=impute2;

%let numObs = 23613;  *** number of observations + 1;
%let numVarsLasso = 5; *** number of variables selected by Lasso;
%let lassoVars = ; *** list of variables from LASSO Selection;
%let numVarsOLS = 5; *** number of variables selected using OLS methods;
Proc reg data=impute2;
Model lprice=kremlin_km
basketball_km
stadium_km
metro_min_avto
university_km
swim_pool_km
workplaces_km
big_church_km
office_km
metro_km_avto
park_km
fitness_km
public_healthcare_km
shopping_centers_km
bus_terminal_avto_km
market_shop_km
ice_rink_km
school_km
public_transport_station_km
public_transport_station_min_wa
big_road2_km
railroad_station_avto_min
railroad_station_avto_km
office_raion
children_preschool
X0_6_all
university_top_20_raion
X0_13_all
X0_17_all
lchildschool
X7_14_all
shopping_centers_raion
raion_popul
ltimestamp
healthcare_centers_raion
kitch_sq_imputed
num_room_imputed
full_sq
life_sq_imputed/r;
Output out=demo1 student=studresids rstudent=studdelresid cookd=cook;
Run;
Proc sort data=demo1; by cook;
Run;
data demo2;
set demo1;
if cook>0.001 or cook=0.001 then delete;
proc contents data=demo2; run;
/*Based on P-value, get rid of stadium_km, university_km, workplace_km,metro_km_avto,shopping_centers_km, bus_terminal_avto_km,market_shop_km school_km,public_transport_station_km,railroad_station_avto_min, railroad_station_avto_km, children_preschool,xo-13_all,, xo_17_all,x7_14_all, shopping_centers_raion, raion_popul, kitch_sq_imputed*/
Proc reg data=demo2;
Model lprice=kremlin_km
basketball_km
metro_min_avto
swim_pool_km
big_church_km
office_km
park_km
fitness_km
public_healthcare_km
ice_rink_km
public_transport_station_min_wa
big_road2_km
office_raion
X0_6_all
university_top_20_raion
lchildschool
ltimestamp
healthcare_centers_raion
num_room_imputed
full_sq
life_sq_imputed/r;
Output out=demo1 student=studresids rstudent=studdelresid cookd=cook;
Run;
data demo3;
set demo2;
if cook>0.002 or cook=0.002 then delete;

proc contents data=demo3; run;
 