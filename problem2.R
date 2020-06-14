library("readxl")
library(tidyverse)
library(dplyr)
library(modelr)
library(ggplot2)
library(tidyverse)
library(GGally)
library(car)



model_data <- read.csv("/Users/jorgeolmos/Documents/SMU_DATA_SCIENCE/DS_6372/project_1/transformedModelData.csv", header = TRUE)


separated_model <- model_data %>% separate(timestamp, c("month","day","year"), sep = "([/])")

aggregate_model<- aggregate(separated_model$price_doc, list(month=separated_model$month,year=separated_model$year), mean)


aggregate_model <- aggregate_model %>% 
  rename(
    avgPrice = x,
  )

aggregate_model$month <- as.numeric(aggregate_model$month)

aggregate_model$year <- as.numeric(aggregate_model$year)

aggregate_model <- aggregate_model[with(aggregate_model, order(year, month)), ]
c

aggregate_model$MonthNumber <- seq.int(nrow(aggregate_model))

ggplot(aggregate_model, aes(x=MonthNumber, y=avgPrice)) + geom_point()



write.csv(aggregate_model,"/Users/jorgeolmos/Documents/SMU_DATA_SCIENCE/DS_6372/project_1/aggregatedMonthData.csv")




