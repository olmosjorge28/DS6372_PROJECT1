FILENAME REFFILE '/home/u44429873/Applied statistical/project1/DEMO2.csv';
PROC IMPORT DATAFILE=REFFILE
	DBMS=CSV
	OUT=demo2;
	GETNAMES=YES;
RUN;
                                   
/*scatter plot*/
proc sgscatter data=demo2;
matrix price_doc full_sq num_room_imputed kremlin_km raion_popul park_km children_school kremlin_km;
run;

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
run;


PROC CONTENTS DATA=logdata; RUN;
