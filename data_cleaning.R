library("readxl")
library(tidyverse)
library(dplyr)
library(modelr)
library(ggplot2)
library(tidyverse)
library(GGally)
library(car)


library(corrplot)
library(RColorBrewer)


model_data <- read.csv("/Users/jorgeolmos/Documents/SMU_DATA_SCIENCE/DS_6372/project_1/modelingData.csv", header = TRUE)


summary(model_data)


model_data_na_ommitted <- na.omit(model_data)

#full_sq life_sq floor max_floor material build_year num_room kitch_sq


#modifyin NAs to 0
model_data[is.na(model_data)] <- 0
write.csv(model_data,"/Users/jorgeolmos/Documents/SMU_DATA_SCIENCE/DS_6372/project_1/modelingData2.csv")



#M <-cor(model_data)

#Colinearity plot
M <- cor(model_data, use="pairwise.complete.obs")
corrplot(M, type="upper", order="hclust",
         col=brewer.pal(n=8, name="RdYlBu"))
M <- cor(model_data[sapply(model_data, is.numeric)])

corrplot(M, type="upper", order="hclust",
         col=brewer.pal(n=8, name="RdYlBu"))
M[,"price_doc"] 

#Printing price_doc colinearity data
newdata <- M["price_doc",]
price_doc_corr <- M[,"price_doc"]
write.csv(price_doc_corr,"/Users/jorgeolmos/Documents/SMU_DATA_SCIENCE/DS_6372/project_1/correlationAnalysis.csv")


filtered_model <- model_data %>% select(
  price_doc,
  life_sq,
  num_room,
  full_sq,
  build_count_brick,
  workplaces_km,
  swim_pool_km,
  university_km,
  basketball_km,
  office_km,
  stadium_km) 

ggpairs(filtered_model, title="correlogram with ggpairs()") 
corrplot(cor(filtered_model), type="upper", order="hclust")




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

model_data <- model_data %>% filter(model_data$full_sq > 10) 

#prediction life_sq
model_data_life_sq_train <- model_data %>% filter(!is.na(model_data$life_sq)) %>% filter(full_sq >= life_sq) 
model_life_sq <- model_data_life_sq_train %>% lm(formula = life_sq ~ full_sq )
model_data <- model_data %>% add_predictions(model_life_sq) %>% mutate(abs_error_life_sq=abs(life_sq - pred), life_sq_imputed  = if_else(is.na(life_sq), as.numeric(round(pred)), as.numeric(life_sq)), imputed_life_sq_ind = factor(if_else(is.na(kitch_sq), "Imputed", "Real")) )


#prediction kitchen
model_data_kitchen_sq_train <- model_data %>% filter(!is.na(model_data$kitch_sq)) %>% filter(full_sq >= kitch_sq) 
model_kitchen_sq <- model_data_kitchen_sq_train %>% lm(formula = kitch_sq ~ full_sq )
model_data <- model_data %>% add_predictions(model_kitchen_sq) %>% mutate(abs_error_kitch_sq=abs(kitch_sq - pred), kitch_sq_imputed  = if_else(is.na(kitch_sq), as.numeric(round(pred)), as.numeric(kitch_sq)), imputed_kitch_sq_ind = factor(if_else(is.na(kitch_sq), "Imputed", "Real")) )


#prediction floor num
model_data_num_room_train <- model_data %>% filter(!is.na(model_data$num_room)) %>% filter(!(num_room > 15 && full_sq<50))
model_num_room<- model_data_num_room_train %>% lm(formula = num_room ~ full_sq )
model_data <- model_data %>% add_predictions(model_num_room) %>% mutate(abs_error_num_room=abs(num_room - pred), num_room_imputed  = if_else(is.na(num_room), as.numeric(round(pred)), as.numeric(kitch_sq)), imputed_num_room_ind = factor(if_else(is.na(num_room), "Imputed", "Real")) )


#max_floor
model_data <- model_data %>%  mutate(max_floor_imputed = if_else(is.na(max_floor), as.numeric(floor), as.numeric(max_floor)),  max_floor_imputed_ind= factor(if_else(is.na(max_floor), "Imputed", "Real")))


#build year
model_data_filtered_build_year <-model_data %>% filter(!is.na(build_year)) %>% filter(build_year<=2020) %>% filter(build_year>=1600)  
model_data_filtered_build_year$build_year <- as.numeric(model_data_filtered_build_year$build_year)
mean(model_data_filtered_build_year$build_year)
median(model_data_filtered_build_year$build_year)


model_data <- model_data %>%  mutate(build_year_imputed = if_else(is.na(build_year), as.numeric(1981), as.numeric(build_year)),  build_year_imputed_ind= factor(if_else(is.na(build_year), "Imputed", "Real")))


#material
model_data_filtered_material <-model_data %>% filter(!is.na(material))
model_data_filtered_material$material <- as.factor(model_data_filtered_material$material)
mean(model_data_filtered_material$material)


model_data_filtered_material %>% group_by(material) %>%
  summarise(no_rows = length(material))

model_data <- model_data %>% mutate(material = if_else(is.na(material), as.numeric(1), as.numeric(material)), material_imputed_ind= factor(if_else(is.na(material), "Imputed", "Real")))





write.csv(model_data,"/Users/jorgeolmos/Documents/SMU_DATA_SCIENCE/DS_6372/project_1/imputed_dataset.csv")







