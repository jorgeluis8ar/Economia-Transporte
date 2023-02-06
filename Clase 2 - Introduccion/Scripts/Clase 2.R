# Codigo creado por: Jorge Luis Ochoa Rincon
# Fecha de creacion: 2023-03-01
# Objetivo: Paquetes, bases de datos y estadísticas
# Nota: No utilizo caracteres especiales en el codigo, excepto en las carpetas

# 0. Limpiando la consola y cargando paquetes --------------------------------

# configuracion inicial 
rm(list = ls()) # limpia el entorno de R
Sys.setlocale("LC_CTYPE", "en_US.UTF-8") # Encoding UTF-8

# Instalando los paquetes
# install.packages(c("pacman","rio","skimr","tidyverse","readr","sf"))

require(pacman) 
# Llamar y/o instalar las librerías de la clase
p_load(rio,skimr,tidyverse,readr) 



# 0.1 Directorio ----------------------------------------------------------

# Ubicacion actual
getwd()

# Ubicacion deseada
setwd("C:/Users/jl.ochoa/OneDrive - Universidad de los Andes/Complementarias/Economía del Transporte/Clase R/Clase 2 - Introduccion/")

# 1. Importar y exportar datos --------------------------------------------

# Existen dos paquetes con funciones muy poderosa para leer y/o exportar bases
# de datos. 
# 1. rio: Con una sola funcion podemos cargar casi todo tipo de bases de datos
# 2. readr: Tiene funciones para muchos tipos de datos


# 1.2 rio ----------------------------------------------------------------


# Recordemos que podemos pedir ayuda con el signo pregunta
?rio
browseURL("https://github.com/leeper/rio" , browser = getOption("browser"))

# 1.2.1 Importar con rio --------------------------------------------------

# Ayuda de la funcion import
?rio::import

# Importar bases de datos en formato .csv
data_csv = import(file = "Input/Entradas de extranjeros a Colombia.csv" , sep = "," , header = T, stringsAsFactors = F) 
# paquete readr::read_delim()

# Importar bases de datos en formato .xls y .xlsx 
data_xls = import(file= "Input/Hurto personas SIEDCO.xlsx" , sheet = "Hurto a Personas" , col_names = TRUE, skip = 10) 
# paquete readxl::read_xls() o readxl::read_xlsx()

# Importar bases de datos en formato .dta
data_dta = import(file = "Input/Recaudo anual por tipo de impuesto.dta")
# paquete haven::read_dta()

# Importar bases de datos en formato .rds
data_rds = import(file = "Input/Recaudo anual por tipo de impuesto.RDS") 
# paquete readr::read_rds()

# Extra
# Si les interesan los datos espaciales uno de los mejores paquetes para importar,
# modificar, procesar y exportar datos espaciales es sf.
# Vamos a cargar una base de datos de estaciones de policia en bogota
# library(sf)
# browseURL("https://r-spatial.github.io/sf/" , browser = getOption("browser"))
# shape <- read_sf("Input/Shape files/estacionpolicia.shp")



# 1.2.2 Exportar con rio --------------------------------------------------

# Ayuda de la funcion export
?rio::export

# exportar bases de datos en formato .csv
export(data_csv, "Output/Entradas de extranjeros a Colombia.csv")  
# paquete readr::write_delim()

# exportar bases de datos en formato .xls y .xlsx 
export(data_xls,"Output/Hurto personas SIEDCO.xlsx",overwrite = T)
# paquete writexl::write_xlsx()

# exportar bases de datos en formato .dta
export(data_dta,"Output/Recaudo anual por tipo de impuesto.dta")
# paquete haven::write_dta()

# exportar bases de datos en formato .rds
export(data_rds,"Output/Recaudo anual por tipo de impuesto.RDS") 
# paquete readr::write_rds

# 1.2.3 Convertir con rio --------------------------------------------------

# Ayuda de la funcion convert
?rio::convert

# Convertir a formato .rds
convert(in_file = "Input/Entradas de extranjeros a Colombia.csv" ,out_file = "Output/Entradas de extranjeros a Colombia.rds")

# Convertir a formato .csv
convert("Input/Hurto personas SIEDCO.xlsx" ,"Output/Hurto personas SIEDCO.csv")

# Convertir a formato .dta
convert("Input/Hurto personas SIEDCO.xlsx" ,"Output/Hurto personas SIEDCO.dta")


#-------------------------#
#       1.3  skimr        #
#-------------------------#
# Informacion extra
?skimr::skim()

# 1.3.1 resumen del data -#
skim(data_csv)
skim(data_dta)
skim(data_rds)
skim(data_xls)



# 2. Operador Pipe --------------------------------------------------------

# Información del funcionamiento de la funcion pipe
browseURL("https://rsanchezs.gitbooks.io/rprogramming/content/chapter9/pipeline.html" , browser = getOption("browser"))


# 2.1 Sin pipe ------------------------------------------------------------

# ejemplo 1
head(data_rds)
df <- data_rds
df <- df[1:16,] # Selecionamos filas 1:5
df <- df[,1:3] # Selecionamos columnas 1:3
df

# ejemplo 2
a <- 1:15
a <- as.character(a)
a <- paste0("Número ", a)
a

# 2.2 Con pipe ------------------------------------------------------------


# ejemplo 1
df <- as_tibble(mtcars) %>% .[1:5,] %>% .[,1:3]
df

# ejemplo 2
a <- 1:15 %>% as.character(.) %>% paste0("Número ", .)
a


# 3. Creacion de variables ------------------------------------------------


cat("Se puden adicionar y/o eliminar variables de dos maneras: usando $ (una función de la base de R)
 o usando mutate() de la librería dplyr.")

library(help = "datasets")

df <- as_tibble(mtcars) # convertir en tibble
df <- df[,c(1,4,6,10)] # mantener solo las columnas 1,4,6 y 10


# 3.1 Operador $ ----------------------------------------------------------

cat("Agregar una variable con la relación caballos de fuerza / peso del vehículo")

df$hp_vt <- df$hp/df$wt # agregar nueva variable
df


# 3.2 Mutate --------------------------------------------------------------

cat("Generar una variable con la relación millas/galón sobre el número de caballos de fuerza:")

df <- mutate(.data = df , mpg_hp = mpg/hp)
df


# 3.3 Aplicando una condicion ---------------------------------------------

# | Condicional o
# & Condicional y
# < menor que
# > mayor que
# >= mayor o igual que
# <= menor o igual que
# == igual a


cat("Generar una variable para los vehículos pesados mayores a la media y otra para los vehículos con 5 velocidades")

# data$var
df$wt_mean.indicator <- ifelse(test= df$wt>mean(df$wt) , yes=1 , no=0)

#mutate
df <- mutate(.data=df , gear_5 = ifelse(test=gear==5 , yes=1 , no=0))
df


# 3.4 Mas de una condicion ------------------------------------------------


cat("Generar una variable si:
    1. Menos del promedio
    2. Mayor al promedio
    3. Maoy al promedio y con 5 velocidades")

df <-  mutate(df , wt_chr = case_when(wt_mean.indicator == 0 ~ "Menor del promedio" ,
                                      (wt_mean.indicator == 1)&(gear < 5) ~ "Mayor al promedio" ,
                                      (wt_mean.indicator == 1)&(gear == 5) ~ "Mayor al promedio y 5 velocidades"))
df

# 3.5 Cambiando todas las variables ---------------------------------------

# Aplicar una función a todas las variables
df <- mutate_all(.tbl=df , .funs = as.character)
df

#------------------------------#
## Renombrar variables
colnames(df)
colnames(df)[5] <- "hp.vt.char"
colnames(df)

colnames(df) = toupper(colnames(df))
