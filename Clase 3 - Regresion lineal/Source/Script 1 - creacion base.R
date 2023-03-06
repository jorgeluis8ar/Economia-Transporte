
library(data.table) # Funciones para el procesamiento de datos
library(dplyr)      # Funciones para manejo de datos
library(readr)      # Funciones para leer diferentes formatos
library(collapse)

files <- paste0("Input/OCDE/",list.files("Input/OCDE/"))

list.df <- parallel::mclapply(files, read_delim)


# Primera base ------------------------------------------------------------

df <- list.df[[1]]

df <- as.data.table(df)
df[,names := case_when(Indicator == "Share of employment in the transport sector" ~ "transport_share_country",
                       Indicator == "Share of household expenditure for transport in total household expenditure" ~ "transport_share_household",
                       Indicator == "Share of value added by the transport sector" ~ "value_added_transport")]
df <- df[!is.na(names),]
df <- df[,c("COUNTRY","Country","Year","Value","names")]

df.1 <- df %>% pivot_wider(names_from = names,values_from = Value)

# Segunda base ------------------------------------------------------------

df <- list.df[[2]]

df <- as.data.table(df)
df[,names := case_when(Indicator == "Share of CO2 emissions from road in total CO2 emissions from transport" ~ "co2_road_transport_share",
                       Indicator == "CO2 emissions from transport in tonnes per inhabitant" ~ "co2_per_inha_tonnes",
                       Indicator == "Share of CO2 emissions from transport in total CO2 emissions" ~ "co2_transport_totalshare")]
df <- df[!is.na(names),]
df <- df[,c("COUNTRY","Country","Year","Value","names")]

df.2 <- df %>% pivot_wider(names_from = names,values_from = Value)

# Tercer base ------------------------------------------------------------

df <- list.df[[3]]

df <- as.data.table(df)

df[,names := case_when(Variable == "Road infrastructure investment" ~ "road_investment",
                       Variable == "Total inland transport infrastructure investment" ~ "total_transport_investment")]
df <- df[!is.na(names),]
df <- df[,c("COUNTRY","Country","Year","Value","names")]

df <- df %>% 
        group_by(COUNTRY,Country,Year,names) %>% 
        summarise(Value = mean(Value))

df.3 <- df %>% pivot_wider(names_from = names,values_from = Value)

# Cuarta base ------------------------------------------------------------

df <- list.df[[4]]

df <- as.data.table(df)
df[,names := case_when(Variable == "Road passenger transport" ~ "road_passengers",
                       Variable == "Road passenger transport by buses and coaches" ~ "road_passengers_buses",
                       Variable == "Road passenger transport by passenger cars" ~ "road_passengers_cars")]
df <- df[!is.na(names),]
df <- df[,c("COUNTRY","Country","Year","Value","names")]

df.4 <- df %>% pivot_wider(names_from = names,values_from = Value)

# Quinta base ------------------------------------------------------------

df <- list.df[[5]]

df <- as.data.table(df)
df[,names := case_when(Series == "In 2021 constant prices at 2021 USD PPPs" ~ "real_wage")]
df <- df[!is.na(names),]
df <- df[`Pay period` == "Annual",]
df <- df[,c("COUNTRY","Country","Time","Value","names")]

df.5 <- df %>% pivot_wider(names_from = names,values_from = Value)
colnames(df.5)[3] <- "Year"

# Sexta base ------------------------------------------------------------

df <- list.df[[6]]

df <- as.data.table(df)
df[,names := case_when(Variable == "Road casualties (injured + killed)" ~ "road_caualties",
                       Variable == "Road fatalities (30 days)" ~ "road_fatalities",
                       Variable == "Road injured" ~ "road_injuries")]
df <- df[!is.na(names),]
df <- df[,c("COUNTRY","Country","Year","Value","names")]

df.6 <- df %>% pivot_wider(names_from = names,values_from = Value)

# Septima base ------------------------------------------------------------

df <- list.df[[7]]

df <- as.data.table(df)
df[,names := case_when(Indicator == "Road infrastructure investment per GDP" ~ "road_investment_gdp",
                       Indicator == "Share of urban roads in total road network" ~ "urban_roads_totalshare",
                       Indicator == "Road injured" ~ "road_injuries")]
df <- df[!is.na(names),]
df <- df[,c("COUNTRY","Country","Year","Value","names")]

df.7 <- df %>% pivot_wider(names_from = names,values_from = Value)


# Guardando la base de datos ----------------------------------------------

df.total <- merge(x = df.1,y = df.2, by = c("COUNTRY","Country","Year"))
df.total <- merge(x = df.total,y = df.3, by = c("COUNTRY","Country","Year"),all.x = T)
df.total <- merge(x = df.total,y = df.4, by = c("COUNTRY","Country","Year"),all.x = T)
df.total <- merge(x = df.total,y = df.5, by = c("COUNTRY","Country","Year"),all.x = T)
df.total <- merge(x = df.total,y = df.6, by = c("COUNTRY","Country","Year"),all.x = T)
df.total <- merge(x = df.total,y = df.7, by = c("COUNTRY","Country","Year"),all.x = T)

write_delim(x = df.total,"C:/Users/jl.ochoa/OneDrive - Universidad de los Andes/Complementarias/Economía del Transporte - Clases R/Clase R/Clase 3 - Regresion lineal/Input/Base datos transporte OCDE.csv",delim = "*")