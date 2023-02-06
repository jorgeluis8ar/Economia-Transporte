# Codigo creado por: Jorge Luis Ochoa Rincon
# Fecha de creacion: 2023-01-31
# Objetivo: Comprender sinstaxis basica en R.
# Nota: No utilizo caracteres especiales en el codigo, excepto en las carpetas

# 0. Limpiando la consola y cargando paquetes --------------------------------

cat("\f")
rm(list = ls())

# Lenguaje orientado a objetos

# ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
# ++++++++++++++++++++ Lenguaje orientado a objetos ++++++++++++++++++++++++++++
# ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

a = 2
b = seq(1,10,1)

# ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
# 1. Tipo de datos en R -----------------------------------------------------------
# ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++


#  Tipos de datos:
# 1. Numeric = 1 , 100 , 1.2 , 00.5 
# 2. Character = 'Hola'
# 3. Factor = Etiquetas
# 4. Logical = FALSE, TRUE, NA

?typeof
typeof(x=1.4) # Double
typeof(x=4L) # Integer
typeof(x = "2")

cat("Importante no siempre se debe escribir el nombre del argumento, siempre y cuando se siga 
    el estricto orden de los argumentos de la funcion")

typeof("Hola") # Character
typeof(TRUE) # Logical
class(NA) ; class(1+100) ; class(0.5); class("Texto"); class("1")
str("a") ; str(100) ; str(0.001) ; str(FALSE) 

# Funciones is.() y as.()

 
# Las funciones is.() me devueleven un elemento logical como 'FALSE' o 'TRUE' 

is.numeric("1000") ; is.character(20) ; is.logical(TRUE) ; is.factor(9)

# Las funciones as.() se usan para convertir un elemento de un formato a otro 

as.numeric("1000") ; as.character(20) ; as.factor(9)

# Tanto la funcion is.() como as.() tiene una forma general de ecsribirse como:

is(object = "1000" ,class2 = "numeric")
is(20, "character")
as(object = "1000",Class = "numeric", strict = TRUE) 
as(20,"character",TRUE) 

cat("Sin embargo, se debe tener cuidado con la funcion as.() porque al convertir
    datos de character a numeric puede perse informacion")

as(c("1000 M","7","25","y7"),"numeric",TRUE) 

# ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
# 2. Paquetes en R -------------------------------------------------------------
# ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

### Paquetes instalados 
installed.packages()[,c(1,3,4)]

### Esta instalado un paquete? 
is.element("ggplot2",installed.packages()[,1])

### Instalar un paquete
install.packages("dplyr")

### Llamar el paquete
require('dplyr');library('dplyr')

####  Que pasa cuando el paquete no esta instalado
# Si el paquete no se encuentra instalado en el computador, R simplemente no entiende lo que se le dice
library('rgdala')

### Como unload un paquete que no estoy usando
detach("package:ggplot2", unload = TRUE) 

### Cuantos paquetes hay disponibles en R?
available.packages()[,1:2]
nrow(available.packages())

### Eliminar un paquetes 
remove.packages("dplyr") 


# ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
# 3. Estructuras de datos en R -------------------------------------------------
# ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

browseURL("https://rsanchezs.gitbooks.io/rprogramming/content/chapter2/enteringinput.html" , browser = getOption("browser"))

'
    ----------------------------------
    |  Homogeneos	   |  Heterogeneos |
    ----------------------------------
1d	|    Vector    |   Listas       |
2d	|    Matriz    |   Dataframe    |
nd	|    Array     |                |
    ----------------------------------
'
#------------#
## Vectores ##
#------------#

# Vectores pueden contener
# 1. character
char_vec <- c("a","b","c","r","d","a","e","c","a","r","r")
char_vec

# 2. numeric
num_vec <- c(1:15)

# 3. Logical
log_vec <- c(TRUE, FALSE, T, F)
log_vec

# Otros
letters
month.name

### ¡Ojo! Los elementos no son homogeneos
vector2 <- c(1,2,"c")
# Como los elementos no son homegeneos R cambia los nuemros a string paraque todos sean homogeneos
str(vector2)

### Transformaciones a vectores
vector2 <- as.numeric(vector2) # Los elementos que no se pueden transformar en un n'umero se convierten en NA
str(vector2)

### Eliminar elementos de un vector
dbl_vec <- seq(from = 1 , to = 50, by = 2) 
dbl_vec
dbl_vec[2] # Elemento numero 2
dbl_vec[1:10] # 10 primeros elementos
dbl_vec
dbl_vec <- dbl_vec[-1] # Eliminar el elemento de la posicion 1 del vector
dbl_vec

char_vec <- letters
#Para filtar elementos de un vector
char_vec <- char_vec[char_vec != "a"] # Dejar todos los elementos de char_vec diferentes de "a"
char_vec 
!char_vec %in% c("c","r")
char_vec <- char_vec[!char_vec %in% c("c","r")] # Eliminar todos los elementos de char_vec que sean diferentes de c y r
char_vec 

#------------#
## Matricez ##
#------------# 

### Generemos una matriz de numeros aleatorios (de una distribucion normal)
matriz_normal <- matrix(rnorm(n = 25,mean = 100 ,sd = 10) , nrow = 5, ncol = 5) # Matriz de 5*5
matriz_normal # Ver la matriz sobre la consola
nrow(matriz_normal) # Numero de filas
ncol(matriz_normal) # Numero de columnas
rownames(matriz_normal)
colnames(matriz_normal)

### Cambiemos los nombres de las columnas en una matriz
colnames(matriz_normal) <- c("Columna 1","Columna 2","Columna 3","Columna 4","Columna 5")
colnames(matriz_normal)[2]="Var2"
matriz_normal
rownames(matriz_normal) # Cambien ustedes los nombres de las filas

### Elementos de una matriz

matriz_normal[1,2]
matriz_normal[1,"Var2"]
matriz_normal[,2]
matriz_normal[4,]
A <- matriz_normal[,3]
A

#--------------#
## Dataframes ##
#--------------#

### Generemos un dataframe
nota_numerica = seq(0,10,2)
nota_numerica
nota_alfabetica = c("a","b","b","a","c","b")
nota_alfabetica
dfm <- data.frame(nota_numerica,nota_alfabetica) # Creamos el dataframe

### Elementos de un dataframe
dfm 
dfm[3,1]
dfm[,2]
dfm$nota_numerica

#----------#
## Listas ##
#----------#

### Crear y guardar objetos en una lista
lista <- list()
lista[[1]] <- dfm
lista[[2]] <- matriz_normal
lista[[3]] <- A
data.frame(dfm,matriz_normal,A)

### Atributos de una lista
class(lista[[1]]) # Elemento 1
colnames(lista[[1]]) # Elemento 1
class(lista[[2]]) # Elemento 2
colnames(lista[[2]]) # Elemento 2
length(lista) # Largo de la lista
7
### Ver elementos de una lista
lista
lista[[1]][,2]
lista[[1]][,2]

matriz_normal2 <- matrix(rnorm(n = 25,mean = 100 ,sd = 10) , nrow = 5, ncol = 5) # Matriz de 5*5
matriz_normal2[1,] <- c("A",1,3,4,5)
