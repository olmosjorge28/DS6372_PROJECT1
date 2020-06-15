FILENAME REFFILE '/home/u44429873/Applied statistical/project1/DEMO2.csv';
PROC IMPORT DATAFILE=REFFILE
	DBMS=CSV
	OUT=demo2;
	GETNAMES=YES;
RUN;
proc contents data=demo2; run;
                                   
/*scatter plot*/
proc sgscatter data=demo2;
matrix price_doc full_sq num_room_imputed kremlin_km raion_popul park_km children_school kremlin_km;
run;

/*check multicollinearity*/
proc corr data=DEMO2 plots=matrix;
RUN;

/*check assumption*/
PROC PLOT DATA=demo2; 
PLOT Price_doc*(full_sq num_room_imputed kremlin_km raion_popul park_km children_school kremlin_km
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
hospital_beds_raion);
RUN; 

data logdata;
set demo2;
lkremlin_km=log(kremlin_km);
lbasketball_km=log(basketball_km);
lstadium_km=log(stadium_km);
lmetro_min_avto=log(metro_min_avto);
luniversity_km=log(university_km);
lswim_pool_km=log(swim_pool_km);

lworkplaces_km=log(workplaces_km);
lbig_church_km=log(big_church_km);
loffice_km=log(office_km);
lmetro_km_avto=log(metro_km_avto);
lpark_km=log(park_km);

lfitness_km=log(fitness_km);
lpublic_healthcare_km=log(public_healthcare_km);
lshopping_centers_km=log(shopping_centers_km);
lbus_terminal_avto_km=log(bus_terminal_avto_km);
lmarket_shop_km=log(market_shop_km);
lice_rink_km=log(ice_rink_km);
lschool_km=log(school_km);
lpublic_transport_station_km=log(public_transport_station_km);
lpublic_transport_station_min_wa=log(public_transport_station_min_wa);
lbig_road2_km=log(big_road2_km);
lrailroad_station_avto_min=log(railroad_station_avto_min);
lrailroad_station_avto_km=log(railroad_station_avto_km);
loffice_raion=log(office_raion);
lchildren_preschool=log(children_preschool);
lprice_doc=log(price_doc);
lX0_6_all=log(X0_6_all);
luniversity_top_20_raion=log(university_top_20_raion);
lX0_13_all=log(X0_13_all);
lX0_17_all=log(X0_17_all);
lchildren_school=log(children_school);
lX7_14_all=log(X7_14_all);
lshopping_centers_raion=log(shopping_centers_raion);
lraion_popul=log(raion_popul);
ltimestamp=log(timestamp);
lhealthcare_centers_raion=log(healthcare_centers_raion);
lkitch_sq_imputed=log(kitch_sq_imputed);
lnum_room_imputed=log(num_room_imputed);
lfull_sq=log(full_sq);
llife_sq_imputed=log(life_sq_imputed);
lbuild_year_imputed=log(build_year_imputed);
lhospital_beds_raion=log(hospital_beds_raion);
lbuild_count_brick=log(build_count_brick);
lmetro_min_walk=log(metro_min_walk);
lrailroad_terminal_raion=log(railroad_terminal_raion);
lrailroad_station_avto_min=log(railroad_station_avto_min);
lrailroad_station_avto_km=log(lrailroad_station_avto_km);
run;


PROC CONTENTS DATA=logdata; RUN;




%let depVar =price_doc;  
%let varlist=timestamp
full_sq
floor
raion_popul
indust_part
children_preschool
preschool_quota
children_school
healthcare_centers_raion
university_top_20_raion
shopping_centers_raion
office_raion
railroad_terminal_raion
big_market_raion
full_all

build_count_block
build_count_wood
build_count_frame
build_count_brick

metro_min_avto
park_km
green_zone_km
industrial_km
railroad_station_avto_min
public_transport_station_km
public_transport_station_min_wa
kremlin_km

railroad_km
bus_terminal_avto_km
big_market_km
market_shop_km

ice_rink_km
stadium_km
basketball_km
public_healthcare_km
university_km
workplaces_km
shopping_centers_km
office_km
big_church_km
abs_error_life_sq
life_sq_imputed
kitch_sq_imputed
num_room_imputed
max_floor_imputed
build_year_imputed
material_imputed;

data inDat; set logdata;  randNumber = ranuni(101912); if _n_ < 23470; run;
data train; set inDat; if randNumber <= 1/4 then delete; run;
data test; set inDat; if randNumber > 1/4 then delete; run;



%let depval=lprice_doc;
%let varlist=lkremlin_km
lbasketball_km
lstadium_km
lmetro_min_avto
luniversity_km
lswim_pool_km
lworkplaces_km
lbig_church_km
loffice_km
lmetro_km_avto
lpark_km
lfitness_km
lpublic_healthcare_km
lshopping_centers_km
lbus_terminal_avto_km
lmarket_shop_km
lice_rink_km
lschool_km
lpublic_transport_station_km
lpublic_transport_station_min_wa
lbig_road2_km
loffice_raion
lchildren_preschool
lX0_6_all
luniversity_top_20_raion
lX0_13_all
lX0_17_all
lchildren_school
lX7_14_all
lshopping_centers_raion
lraion_popul
ltimestamp
lhealthcare_centers_raion
lkitch_sq_imputed
lnum_room_imputed
lfull_sq
llife_sq_imputed
lbuild_year_imputed
lhospital_beds_raion
lrailroad_terminal_raion
lrailroad_station_avto_min
lrailroad_station_avto_km;
/*R=0.63 RMSE=0.33 Stepwize selection*/
proc glmselect data=train testdata=test plots(stepAxis=number)=(criterionPanel ASEPlot CRITERIONPANEL);
class product_type; 
class railroad_terminal_raion;
class hospital_beds_raion;
model &depval= &varlist/ selection = stepwise (select=sl choose=adjrsq stop=adjrsq) details=steps select=SL slstay=0.05 slentry=0.05 cvDetails = all ;
run;  

/*lasso selection R=0.50 RMSE=0.36*/
title "Selection Method LASSO Using LASSO Variables and Cross Validation";                                                                                                                                                                                                         
proc glmselect data=train testdata = test                                                                                                                                                                            
               seed=1 plots(stepAxis=number)=(criterionPanel ASEPlot CRITERIONPANEL);                                                                                                                                    
class product_type railroad_terminal_raion big_market_raion;
model &depVal = &varlist/selection=LASSO( choose=CV stop=CV ) CVdetails; 
           score data=test out=scoredLASSO;
run;                                                                                                                                                                                                                     

/*Forward selection RMSE=0.31848 R=0.67*/
ods graphics on;
title "Selection Method Step Using OLS Variables and OLS";                                                                                                                                                                                                         
proc glmselect data=train testdata = test                                                                                                                                                                          
               plots(stepAxis=number)=(criterionPanel ASEPlot CRITERIONPANEL);                                                                                                                                    
class product_type railroad_terminal_raion big_market_raion;
model &depVal = &varlist	
            / selection=forward(select=sl choose=adjrsq stop=adjrsq) details=steps select=SL slstay=0.05 slentry=0.05 cvDetails = all ;
run;                        
                                                                                                                                                                                                                     
quit;

/*backward selection RMSE=0.31 R=0.68*/
ods graphics on;
title "Selection Method Step Using OLS Variables and OLS";                                                                                                                                                                                                         
proc glmselect data=train testdata = test                                                                                                                                                                          
               plots(stepAxis=number)=(criterionPanel ASEPlot CRITERIONPANEL);                                                                                                                                    
class product_type railroad_terminal_raion big_market_raion;
model &depVal = &varlist	
            / selection=backward( choose=adjrsq stop=adjrsq include = 5) CVdetails;  
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





/**import projectiondata , then try to get prediction price*/



FILENAME REFFILE '/home/u44429873/Applied statistical/project1/clean_data_set2.csv';

PROC IMPORT DATAFILE=REFFILE
	DBMS=CSV
	OUT=projection;
	GETNAMES=YES;
RUN;

PROC CONTENTS DATA=projection; RUN;


data pro1;
set projection;
price=.;

proc glm data=pro1 PLOTS=(DIAGNOSTICS RESIDUALS) ;
class railroad_terminal_raion;
class product_type;
model price = kremlin_km  basketball_km    	
  university_km    	
  office_km        
  fitness_km
  public_healthcare_km 
  bus_terminal_avto_km
  ice_rink_km
  big_road2_km
   full_sq
  timestamp
  railroad_terminal_raion
  product_type;
  output out=RegOut pred=Pred rstudent=RStudent dffits=DFFits cookd=CooksD;
run;


/****
proc glm data=pro1 alpha=0.95;  
class product_type; 
class railroad_terminal_raion;
class hospital_beds_raion;
model price=kremlin_km
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
hospital_beds_raion full_sq*raion_popul / solution;
output out=model1_v2_out r=res p=benchmark2 lcl=Q25 ucl=Q75; Data pro1;  set model1_v2_out;  
run;
