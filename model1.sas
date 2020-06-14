proc import datafile = '\\smu.edu\Files\users$\jeolmos\Apps.SMU\Documents\6372\project_1\imputed_dataset.csv'
 dbms = CSV
 out = model_data
 GUESSINGROWS=MAX
 replace;
run;

proc import datafile='\\smu.edu\Files\users$\jeolmos\Apps.SMU\Documents\6372\project_1\imputed_dataset.csv' 
out=model_data 
dbms=csv 
replace;
guessingrows=max;
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
  MATRIX price_doc num_room_imputed full_sq workplaces_km shopping_centers_raion stadium_km university_top_20_raion office_km;
RUN;



data clean_model_data;
set model_data;
if railroad_terminal_raion ="yes" THEN railroad_terminal_raion=1; else railroad_terminal_raion=0; 
if big_market_raion="yes"  THEN big_market_raion=1; else big_market_raion=0;
if life_sq_imputed > full_sq then delete;
if kitch_sq_imputed >full_sq then delete;
if num_room_imputed >15 and full_sq<100 then delete;
if full_sq<10 then delete;
if full_all<X0_6_all then delete;
if full_all<X0_17_all  then delete;
if full_all<X16_29_all then delete;
if full_all<X0_13_all then delete;
if build_year_imputed>2020 or build_year_imputed<1600 then delete;
*proc print data=impute2; 
*run;

proc print data=modeldata3; run;


proc contents data=mode_data_3;
run;



proc contents data=model_data;
run;

proc contents data=clean_model_data;
run;



data clean_model_data;
   set clean_model_data;
   log_price_doc = log( price_doc );
run;



data clean_model_data;
   set clean_model_data;
   over_price_doc = 1/price_doc;
run;

data clean_model_data;
   set clean_model_data;
   price_doc_sqr = price_doc*price_doc;
run;


proc contents data=clean_model_data;
run;


proc export data=clean_model_data
      outfile='\\smu.edu\Files\users$\jeolmos\Apps.SMU\Documents\6372\project_1\clean_data_set.csv'
      dbms=csv;  
      delimiter=',';
run;


PROC SGSCATTER DATA=clean_model_data;
  MATRIX 
  log_price_doc
  life_sq_imputed
  num_room_imputed
  build_year_imputed
  num_room_imputed
  kitch_sq_imputed
  material_imputed
  full_sq
  workplaces_km
  swim_pool_km
  university_km
  basketball_km
  office_km
  stadium_km;
RUN;



%let inputDataset = clean_model_data;
%let numObs = 23612;  *** number of observations + 1;
*%let numVarsLasso = 3; *** number of variables selected by Lasso;
*%let lassoVars = vacid totSulfur alcohol	; *** list of variables from LASSO Selection;
*%let numVarsOLS = 4; *** number of variables selected using OLS methods;
*%let OLSVars = facid vacid totSulfur alcohol; *** list of variables from selected using OLS methods;
*%let depVar = quality;  *** dependent (response) variable for models;


data inDat; set &inputDataset;  randNumber = ranuni(101912); if _n_ < &numObs; run;
*data test; set inDat; if randNumber <= 1/4 then delete; run;
*data train; set inDat; if randNumber > 1/4 then delete; run;

data test; set inDat; if randNumber <= 1/10 then delete; run;
data train; set inDat; if randNumber > 1/10 then delete; run;


*lasso;
proc glmselect data=train testdata=test plots(stepAxis=number)=(criterionPanel ASEPlot CRITERIONPANEL);
class product_type; 
class railroad_terminal_raion;
*class hospital_beds_raion;
model price_doc= 
kremlin_km
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
children_school
X7_14_all
shopping_centers_raion
raion_popul
timestamp
healthcare_centers_raion
kitch_sq_imputed
num_room_imputed
full_sq
life_sq_imputed
product_type
build_year_imputed
railroad_terminal_raion
/ 
selection=LASSO( choose=adjrsq stop=adjrsq ) CVdetails; 
           score data=test out=scoredLASSO;
run;  


*selection=LASSO( choose=CV stop=CV ) CVdetails; *score data=test out=scoredLASSO;



*backword on 0.5185
*stepwise 0.5438
*stepwise;
proc glmselect data=train testdata=test plots(stepAxis=number)=(criterionPanel ASEPlot CRITERIONPANEL);
class product_type; 
class railroad_terminal_raion;
class hospital_beds_raion;
model price_doc_sqr= 
kremlin_km
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
children_school
X7_14_all
shopping_centers_raion
raion_popul
timestamp
healthcare_centers_raion
kitch_sq_imputed
num_room_imputed
full_sq
life_sq_imputed
product_type
build_year_imputed
railroad_terminal_raion
hospital_beds_raion
/ 
selection = stepwise(select=sl choose=adjrsq stop=adjrsq) details=steps select=SL slstay=0.05 slentry=0.05 cvDetails = all ;
run;  
*selection = backword(select=sl choose=press) details=steps select=SL slstay=0.01 slentry=0.01 cvDetails = all ;


/**/
/*kremlin_km       	1 -150800 */
/*basketball_km    	1 54494 */
/*university_km    	1 -21826 */
/*office_km        	1 -89215 */
/*fitness_km       	1 -79896 */
/*public_healthcare_km 1 -94264 */
/*bus_terminal_avto_km 1 11931 */
/*ice_rink_km 1 109959 */
/*public_transport_sta 1 1688.674197 */
/*big_road2_km 1 -20379 */
/*railroad_station_avt 1 -850.356175 */
/*raion_popul 1 2.361892 */
/*timestamp 1 1094.651801 */
/*healthcare_centers_r 1 170356 */
/*full_sq 1 149100 */
/*product_type_Investment 1 752353 */
/*build_year_imputed 1 3141.382929 */
/*railroad_terminal_raion_0 1 642732 */


PROC SGSCATTER DATA=clean_model_data;
  MATRIX 
  price_doc
  kremlin_km       
  basketball_km    	
  university_km    	
  office_km        
  fitness_km;       
RUN;




  
PROC SGSCATTER DATA=clean_model_data;
  MATRIX 
  price_doc
public_healthcare_km 
  bus_terminal_avto_km
  ice_rink_km
  big_road2_km
  build_year_imputed
  full_sq;      
RUN;




proc glm data=clean_model_data PLOTS=(DIAGNOSTICS RESIDUALS) ;
class railroad_terminal_raion;
class product_type;
model price_doc = 
  kremlin_km       
  basketball_km    	
  university_km    	
  office_km        
  fitness_km
  public_healthcare_km 
  bus_terminal_avto_km
  ice_rink_km
  big_road2_km
  build_year_imputed
  full_sq
  timestamp
  build_year_imputed
  railroad_terminal_raion
  product_type;
  output out=RegOut pred=Pred rstudent=RStudent dffits=DFFits cookd=CooksD;
run;

proc reg data=clean_model_data plots(only) = (CooksD(label) DFFits(label));   
model price_doc =  
kremlin_km       	
basketball_km    	
university_km    	
office_km        	
fitness_km       	
public_healthcare_km 
bus_terminal_avto_km
ice_rink_km               
big_road2_km              
raion_popul            
timestamp              
healthcare_centers_raion 
full_sq                  
build_year_imputed 
railroad_station_avto_km
public_transport_station_km;
output out=RegOut pred=Pred rstudent=RStudent dffits=DFFits cookd=CooksD; /* optional: output statistics */ run; quit;

*railroad_terminal_raion transform to numeric
*product_type to numeric;



proc print data = DIAGNOSTICS;
run;

