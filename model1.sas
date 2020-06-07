proc import datafile = '\\smu.edu\Files\users$\jeolmos\Apps.SMU\Documents\6372\project_1\modelingData2.csv'
 out = model_data
 dbms = CSV
 replace;
run;


proc import datafile = '\\smu.edu\Files\users$\jeolmos\Apps.SMU\Documents\6372\project_1\modelingData.csv'
 out = model_original
 dbms = CSV
 replace;
run;



libname Sample csv '\\Client\C$\Users\jorgeolmos\Documents\SMU_DATA_SCIENCE\DS_6372\project_1\modelingData.csv'


proc print data = model_data;
run;


%let inputDataset = model_data;
%let numObs = 25471;  *** number of observations + 1;
%let numVarsLasso = 3; *** number of variables selected by Lasso;
%let lassoVars = vacid totSulfur alcohol	; *** list of variables from LASSO Selection;
%let numVarsOLS = 4; *** number of variables selected using OLS methods;
%let OLSVars = facid vacid totSulfur alcohol; *** list of variables from selected using OLS methods;
%let depVar = quality;  *** dependent (response) variable for models;


data inDat; set &inputDataset;  randNumber = ranuni(11); if _n_ < &numObs; run;
data train; set inDat; if randNumber <= 1/4 then delete; run;
data test; set inDat; if randNumber > 1/4 then delete; run;


*top correlate variables
life_sq
num_room
full_sq
build_count_brick
workplaces_km
swim_pool_km
university_km
basketball_km
office_km
stadium_km
kremlin_km


*non continuous variables
product_type
railroad_terminal_raion
big_market_raion;


proc glmselect data = model_data;
class product_type; 
*class railroad_terminal_raion; 
*class big_market_raion;
model price_doc = life_sq
  num_room
  full_sq
  build_count_brick
  workplaces_km
  swim_pool_km
  university_km
  basketball_km
  office_km
  stadium_km
  product_type
 

healthcare_centers_raion
hospital_beds_raion
university_top_20_raion
shopping_centers_raion
raion_popul
office_raion
children_school
X7_14_all
X0_17_all
X0_13_all
children_preschool
X0_6_all
max_floor
id
build_count_before_1920
timestamp
floor
material
big_road1_km
public_transport_station_km
railroad_station_avto_km
railroad_station_walk_km
railroad_station_walk_min
railroad_station_avto_min
school_km
ice_rink_km
bus_terminal_avto_km
big_road2_km
public_healthcare_km
market_shop_km
shopping_centers_km
metro_km_avto
metro_km_walk
metro_min_walk
park_km
fitness_km
metro_min_avto
big_church_km
	/ 
selection = backword(select=sl choose=press) details=steps select=SL slstay=0.1 slentry=0.1 cvDetails = all ;
run;




proc glmselect data=train testdata = test plots(stepAxis=number)=(criterionPanel ASEPlot CRITERIONPANEL);
class product_type; 
*class railroad_terminal_raion; 
*class big_market_raion;
model price_doc = 
life_sq
  num_room
  full_sq
  build_count_brick
  workplaces_km
  swim_pool_km
  university_km
  basketball_km
  office_km
  stadium_km
  product_type




healthcare_centers_raion
hospital_beds_raion
university_top_20_raion
shopping_centers_raion
raion_popul
office_raion
children_school
X7_14_all
X0_17_all
X0_13_all
children_preschool
X0_6_all
max_floor
id
build_count_before_1920
timestamp
floor
material
big_road1_km
public_transport_station_km
railroad_station_avto_km
railroad_station_walk_km
railroad_station_walk_min
railroad_station_avto_min
school_km
ice_rink_km
bus_terminal_avto_km
big_road2_km
public_healthcare_km
market_shop_km
shopping_centers_km
metro_km_avto
metro_km_walk
metro_min_walk
park_km
fitness_km
metro_min_avto
big_church_km
	/ 
selection=LASSO( choose=CV stop=CV ) CVdetails; 
           score data=test out=scoredLASSO;
run;            




PROC SGSCATTER DATA=model_data;
  MATRIX price_doc num_room full_sq workplaces_km shopping_centers_raion stadium_km university_top_20_raion office_km;
RUN;



data mode_data_3;
set model_data;
if railroad_terminal_raion ="yes" THEN railroad_terminal_raion=1; 
else railroad_terminal_raion=0;  
if big_market_raion="yes"  THEN big_market_raion=1; 
else big_market_raion=0;
if full_sq<10 and full_sq>0 then delete;
if life_sq>full_sq then delete;
if kitch_sq>full_sq then delete;
if num_room>15 and full_sq<50 then delete;
if build_year>2020 or build_year<1600 then delete

if full_all<X0_6_all then delete;
if full_all<X0_17_all  then delete;
if full_all<X16_29_all then delete;
if full_all<X0_13_all then delete;
run;

proc print data=modeldata3; run;


proc contents data=mode_data_3;
run;

