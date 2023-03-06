# Codigo creado por: Jorge Luis Ochoa Rincon
# Fecha de creacion: 2023-02-21
# Objetivo: Regresion lineal, pruebas de hipotesis y exportar resultados
# Nota: No utilizo caracteres especiales en el codigo, excepto en las carpetas

# 0. Limpiando la consola y cargando paquetes --------------------------------

# configuracion inicial 
cat('\f')
rm(list=ls())
options('scipen'=100, 'digits'=4) # Forzar a R a no usar e+
Sys.setlocale("LC_CTYPE", "en_US.UTF-8") # Encoding UTF-8

# Instalando los paquetes
# install.packages(c("pacman","readr","fixest","stargazer","AER","ggplot2","dplyr"))

require(pacman) 
# Llamar y/o instalar las librerías de la clase
p_load(readr,fixest,stargazer,AER,ggplot2,dplyr) 

# 0.1 Directorio ----------------------------------------------------------

# Ubicacion actual
getwd()

# Ubicacion deseada
setwd("C:/Users/jl.ochoa/OneDrive - Universidad de los Andes/Complementarias/Economía del Transporte - Clases R/Clase R/Clase 3 - Regresion lineal/")

# 1. Importando la base de datos --------------------------------------------

ocde <- read_delim(file = "Input/Base datos transporte OCDE.csv",delim = "*")

# Filtrando los datos

paises <- c("Albania","Australia","Austria","Belgium","Bulgaria","Canada","Chile","Croatia",
            "Czech Republic","Denmark","Estonia","Finland","France","Germany","Greece","Hungary",
            "Iceland","Ireland","Israel","Italy","Japan","Korea","Mexico","Netherlands",
            "New Zealand","Norway","Poland","Portugal","Russian Federation","Spain","Sweden",
            "Switzerland","United Kingdom","United States")

ocde <- ocde %>% filter(Country %in% paises)

ocde %>% 
  group_by(Country) %>% 
  summarise(wage = mean(real_wage,na.rm = T),
            passengers = mean(road_passengers,na.rm = T)) %>% 
  ggplot() +
    geom_point(aes(x = log(passengers), y = log(wage))) +
    geom_smooth(method = lm, se = FALSE,aes(x = log(passengers), y = log(wage))) +
  theme_classic()

# Creando una variable de tratamiento

list.eu <- c("Albania","Australia","Austria","Belgium","Bulgaria","Canada","Chile","Croatia",
            "Czech Republic","Denmark","Estonia","Finland","France","Germany","Greece","Hungary",
            "Ireland","Italy","Netherlands", "Poland","Portugal","Spain","Sweden","United Kingdom")

ocde <- ocde %>% 
            mutate(eu = case_when(
              Country %in% list.eu ~ 1,
              !(Country %in% list.eu) ~ 0))


# 1. Regresion lineal ----------------------------------------------------------

# Unidades
# road_passengers: Passenger-Kilometers, Millions
# real_wage: Dollars, thousand
ocde$real_wage <- (ocde$real_wage)/1000


?lm
ols <- lm(road_passengers ~ real_wage, data = ocde )
ols
summary(ols) 


# 1.1 Elementos de objeto lm ----------------------------------------------

View(ols)

# 1.1.1 modelo estimado ---------------------------------------------------
ols$call

# 1.1.2 Coeficientes estimados -------------------------------------------------
ols$coefficients

# 1.1.3 ¿Que sucede con las observaciones con NA? ------------------------------
ols$na.action

# 1.1.4 ¿Que guarda la funcion summary? ------------------------------
# Residuales
summary(ols)$residuals
summary(ols$residuals)
hist(ols$residuals)
# R2
summary(ols)$r.squared
summary(ols)$adj.r.squared

# 1.2 Inferencia estadistica
coeftest(ols)
Confint(ols)
Confint(ols,level = 0.92)
summary(ols)$fstatistic


# Variable dummy o indicadora

ols.dummy <- lm(road_passengers ~ factor(eu), data = ocde )
summary(ols.dummy) 

# Regresion vs prueba de medias
mean(ocde$road_passengers[ocde$eu == 0],na.rm = T)
mean(ocde$road_passengers[ocde$eu == 1],na.rm = T)
t.test(road_passengers ~ eu, data = ocde)

# Creando modelo multiple -------------------------------------------------

ols2 <- lm(road_passengers ~ real_wage + transport_share_household, data = ocde )
linearHypothesis(ols2, c("real_wage=0","transport_share_household=0"))

ols3 <- lm(road_passengers ~ real_wage*factor(eu) + transport_share_household + co2_transport_totalshare, data = ocde )
linearHypothesis(ols3, c("real_wage=0","transport_share_household=0","co2_transport_totalshare=0"))

ols4 <- lm(road_passengers ~ real_wage*factor(eu) + transport_share_household + co2_transport_totalshare +
             total_transport_investment:factor(eu), data = ocde )

ols5 <- lm(road_passengers ~ real_wage*factor(eu) + transport_share_household + co2_transport_totalshare +
             total_transport_investment:factor(eu) + road_fatalities + road_injuries, data = ocde )

# 2.1.1. Valores predichos
ols5 %>% predict()
ocde$y_gorro = predict(object = ols5,newdata=ocde)


#----------------------#
# 4. After estimations #
#----------------------#

all_regs <- list(ols,ols2,ols3,ols4,ols5)

### 4.3. Funcion stargazer


stargazer(all_regs, type = "text",
          column.labels = c('Modelo 1','Modelo 2','Modelo 3','Modelo 4','Modelo 5'),
          digits=4 , title="Estimacion de pasajeros", align=TRUE,
          out = 'output/Resultados 1.tex',
          covariate.labels=c("Salario minimo real","Zona europea",
                             "Porcentaje gasto transporte: Hogar",
                             "Porcentaje emisiones CO2 de transporte",
                             "Muertes en vias","Heridos en vias",
                             "Salario minimo real x zona europea",
                             "Zona europea = 0 x Inversion total infraestructura vial",
                             "Zona europea = 1 x Inversion total infraestructura vial",
                             "Constante"))
          # keep.stat = c('n','rsq','adj.rsq'))
