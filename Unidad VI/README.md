
 
 ### Link sesión Sabado 21-06-2025 [Link]()

 
 # Álgebra Matricial
Podemos resumir en 5 puntos claves la aplicación del Algebra Matricial a Data Science:

- **Álgebra Matricial**: La página se centra en el álgebra matricial, una rama importante de las matemáticas.
- **Vectores y Matrices en R**: Se discuten los conceptos básicos de vectores y matrices dentro del lenguaje de programación R.
- **Operaciones Matriciales**: Se describen operaciones como la multiplicación de matrices, la inversión matricial y la resolución de sistemas lineales.
- **Descomposiciones Matriciales**: Se exploran descomposiciones matriciales específicas, como LU, Choleski y QR.
- **Funciones Avanzadas**: Se mencionan funciones avanzadas de R como *outer()* y *apply()* para operaciones matriciales.

<img src="https://raw.githubusercontent.com/jelincovil/A_course_R_programming_2024/main/images_for_r_programming/intro_matrices.png" width="800"> 
  
## Vectores y matrices en R


Matrices pueden ser construidas usando las funciones matrix(), cbind() or rbind().

*Syntax*
```r

matrix(data, nrow, ncol) # data is a vector of nrow*ncol values
cbind(d1, d2, ..., dm) # d1, ..., dm are vectors (columns)
rbind(d1, d2, ..., dn) # d1, ..., dn are vectors (rows)

```

Aquí construimos una matriz  H3  de Hilbert de 3 × 3, donde la entrada (i,j) es 1/(i + j − 1). 
Notemos que  ncol no es requerido en el comando que lo creó, ya que los datos al argumento se le ha asignado un vector que consta de nueve elementos; 
está claro que si hay tres filas también debe haber tres columnas.

```r
H3 <- matrix(c(1, 1/2, 1/3, 1/2, 1/3, 1/4, 1/3, 1/4, 1/5), nrow = 3)
H3
```


Nosotro podriamos construir la matriz uniendo columnas de esta manera.
```r
1/cbind(seq(1, 3), seq(2, 4), seq(3, 5))

```

En este ejemplo, rbind() podria dar el mismo resultado, debido a la simetria

Por otra parte, es claro que las matrices no necesaruiamente deben ser cuadradas.

```r
matrix(seq(1, 12), nrow = 3)
```

O alternativamente

```r
x <- seq(1, 3)
x2 <- x^2
X <- cbind(x, x2)
X
class(X)

```
Una matriz tambien puede ser construida por medio de un vector.


```r

X <- matrix(c(1, 2, 3, 1, 4, 9), ncol = 2)
X

```

```r

Y <- matrix(c(1, 2, 3, 1, 4, 9), nrow = 2)
Y

```

###  Acceder a elementos de la matriz;  nombres de filas y columnas

Construimos una matriz uniendo columnas:

```r

x <- seq(1, 3)
x2 <- x^2
X <- cbind(x, x2)

```

```r
X[3, 2]

```

```r
X[3,]

```


```r

X[, 2]

```

```r
X[3, , drop = FALSE]

```

```r

X[, 2, drop = FALSE]

```

Podemos acceder a los nombres de columnas y lineas de la matriz X
```r
colnames(X)

rownames(X)

```

Podemos inserir los nombres en cada linea de la matriz

```r

rownames(X) <- c("obs1", "obs2", "obs3")
X
rownames(X)
```

errores al llamar las columnas
```r
X$x

X[, "x"]

```


### Propiedades matriciales

Dimensión de la matriz

```r
dim(X)

```
Determinante de una matriz
```r
det(H3)

```
La diagonal de una matriz
```r
diag(X)

diag(H3)
```

El trazo de una matriz

```r
trace <- function(data) sum(diag(data))

trace(X)

trace(H3)

```

Diagonal y transpuesta de una matriz

```r
diag(diag(H3))

t(X)

```

### Matrices triangulares

```r
lower.tri(H3)

Hnew <- H3

Hnew[upper.tri(H3, diag = TRUE)] <- 0

```

```r


```

```r

```

###  Aritmética de matrices

Multiplicación y suma de matrices
```r
Y <- 2 * X
Y

Y + X

```

Suma de una transpueta con una matriz de dimensiones diferentes

```r
t(Y) + X

```
En este ejemplo, t(Y) es un 2 × 3 matriz en cuanto X es 3 × 2

```r
X * Y
dim(X) ; dim(Y)

```

```r

Z= X * Y
dim(Z)

```


## Multiplicación e inversión de matricial 

En R, esta formada multiplicación de matriz puede ser desarrollado mediante el operador %*% por ejemplo

```r
t(Y) %*% X

```

```r
Y %*% X
```

# The crossprod() function is a somewhat more efficient way to
# calculate YTX:

La función crossprod() nos puede ayudar a forma eficiente a calcular 

$$
Y^T * X
$$
```r


crossprod(Y, X)
```

### Inversión matricial



```R
# Instalar el paquete si no está instalado
# install.packages("MASS")

# Cargar el paquete
library(MASS)

# Usaremos el conjunto de datos 'survey' del paquete MASS
data(survey)

# Construcción de matrices por columnas
matriz <- survey[, c("Age", "Height", "Weight")]
matriz <- na.omit(matriz)  # Eliminar filas con NA

# Acceder a columnas, lineas y elementos especificos de una matriz
primera_columna <- matriz[, 1]
primera_fila <- matriz[1, ]
primer_elemento <- matriz[1, 1]

# Elementos de la diagonal y trazo de una matriz cuadrada
# Primero, creamos una matriz cuadrada
matriz_cuadrada <- matriz[1:3, 1:3]
diagonal <- diag(matriz_cuadrada)
trazo <- sum(diagonal)

# Traspuesta de una Matriz y Matrices triangulares
traspuesta <- t(matriz)
triangular_superior <- upper.tri(matriz)
triangular_inferior <- lower.tri(matriz)

# Suma, resta, multiplicación, producto cruzado de matrices
# Para este ejemplo, usaremos dos matrices cuadradas pequeñas
A <- matrix(c(1, 2, 3, 4), nrow = 2)
B <- matrix(c(5, 6, 7, 8), nrow = 2)
suma <- A + B
resta <- A - B
multiplicacion <- A %*% B
producto_cruzado <- crossprod(A, B)

# Inversión de matrices
inversa_A <- solve(A)
```


Un problema real que se puede resolver con estos conceptos de álgebra lineal es el análisis de componentes principales (PCA), que es una técnica utilizada en ciencia de datos para reducir la dimensionalidad de los datos conservando la mayor cantidad de información posible. Esto se logra transformando las variables originales en un nuevo conjunto de variables, los componentes principales, que son combinaciones lineales de las variables originales.

Aquí proponemos un ejemplo de cómo se pueden aplicar estos conceptos en R para realizar un PCA en un conjunto de datos con tres variables (edad, peso, altura).

```R
# Instalar el paquete si no está instalado
# install.packages("MASS")

# Cargar el paquete
library(MASS)

# Usaremos el conjunto de datos 'survey' del paquete MASS
data(survey)

# Construcción de matrices por columnas
matriz <- survey[, c("Age", "Height", "Weight")]
matriz <- na.omit(matriz)  # Eliminar filas con NA

# Centrar y cambiar la escala a 0 y 1 los datos
matriz <- scale(matriz)

# Realizar el PCA
pca <- prcomp(matriz)

# Acceder a elementos específicos de la matriz de rotación (los coeficientes de las combinaciones lineales)
coeficientes <- pca$rotation[1, ]

# Elementos de la diagonal de la matriz de varianzas y covarianzas
varianzas <- diag(pca$sdev^2)

# Traspuesta de la matriz de scores
scores_traspuestos <- t(pca$x)

# Suma de las varianzas (igual al trazo de la matriz de varianzas y covarianzas)
suma_varianzas <- sum(varianzas)

# Inversión de la matriz de varianzas y covarianzas
inversa_var_cov <- solve(var(pca$x))
```

### Inversión de una matriz en R

Inversión de la matriz H3


```r

H3
H3inv <- solve(H3)
H3inv

```

```r
# Comprobamos que H3inv es la inversa de H3
H3inv %*% H3

```


## Valores propios y vectores propios

```r
eigen(H3)

v1 <- sprintf("%.3f", eigen(H3)$vectors[,1])


```

```r

evalues <- sprintf("%.3f", eigen(H3)$values)
evalues[3] <- sprintf("%.5f", eigen(H3)$values[3])
print(evalues)
```

## Otras descomposiciones matriciales

- Descomposición por valores singulares.
- De Choleski.
- Del tipo QR.

### La descomposición en valores singulares de una matriz

```r

help(svd)
H3.svd <- svd(H3)
H3.svd

```

```r

H3.svd$d
H3.svd$u
H3.svd$v

```


```r

# Podemos verificar que los componentes al multiplicarse 
# apropiadamente reconstruyen la matriz H3

H3.svd$u %*% diag(H3.svd$d) %*% t(H3.svd$v)

HH3 = H3.svd$u %*% diag(H3.svd$d) %*% t(H3.svd$v)

# Verificacion elemento por elemento

round( H3 -  HH3, 2)

```

```r

# Usando esta descomposición, podemos obtener la matriz inversa
# de H3

H3.svd$v %*% diag(1/H3.svd$d) %*% t(H3.svd$u)
solve(H3)

Inverse.H3 = H3.svd$v %*% diag(1/H3.svd$d) %*% t(H3.svd$u) 

round(solve(H3) - Inverse.H3, 2)

```


### La descomposición de Choleski de un positiva  matriz definida

```r

# Descomposición de Choleski

H3.chol <- chol(H3)
H3.chol   # Esta es la matriz triangular superior U

crossprod(H3.chol, H3.chol)  
# Multiplicamos  t(U) %*% U para recuperar  H3

```

```r
# Calculo de la inversa de H3 por medio de la descomposición de
# Choleski

chol2inv(H3.chol)

```



### La descomposición QR de una matriz.

```r
# Descomposicion QR

help(qr)
H3.qr <- qr(H3)
H3.qr

```

```r

# La matriz Q
Q <- qr.Q(H3.qr)
Q

# La matriz P
R <- qr.R(H3.qr)
R


```



```r

# Recuperar la matri H3
Q %*% R

round(H3 - Q %*% R, 3)

```



## Otras operaciones matriciales

### Función *outer ( )*

```r

help(outer)

x1 <- seq(1, 5)
x1
outer(x1, x1, "/")

```

```r

round(outer(x1, x1, "/"), 2)

outer(x1, x1, function(x, y) {x / y})

```


```r

outer(x1, x1, "-")

```

```r

y <- seq(5, 10)
outer(x1, y, "+")

```



### Función *apply ( )*

La familia de funciones **apply** en R es ampliamente utilizada para aplicar una función a cada elemento de una estructura de datos. Estas funciones son especialmente útiles para operar en matrices, data frames, arrays y listas. A continuación, se presentan las principales funciones de la familia **apply**:

1. **`apply()`**: Aplica una función a filas o columnas de una matriz, data frame o array. Puedes especificar el argumento `MARGIN` para indicar si deseas aplicar la función a filas (con `MARGIN = 1`), columnas (con `MARGIN = 2`), o ambos (con `MARGIN = c(1, 2)`). Además, puedes proporcionar argumentos adicionales para la función que se aplicará¹.

2. **`tapply()`**: Aplica una función a grupos de datos. Es útil para operaciones agregadas en función de factores o variables categóricas⁴.

3. **`sapply()`** y **`lapply()`**: Ambas aplican una función a elementos de una lista. La diferencia radica en que `sapply()` intenta simplificar el resultado a un vector o matriz, mientras que `lapply()` siempre devuelve una lista⁴.

La familia **apply** permite realizar operaciones de manera eficiente sin necesidad de bucles explícitos. ¡Es una herramienta poderosa para el análisis de datos en R! 



```r

# Aplicar las funciones apply

apply(H3, 1, sum)

## Ejemplo 1

# Construimos una matriz de 5x6
my_matrix <- matrix(1:30, nrow = 5, ncol = 6)
print(my_matrix)

# Calculamos la suma de cada columna
col_sums <- apply(my_matrix, 2, sum)

# Mostramos los resultados
print(col_sums)

# Agregamos 2 NAs a la matriz

my_matrix[2,3]<-NA
apply(my_matrix,1,sum)

# Agremamos un argumento de la funcion vectorizada
help(sum)
apply(my_matrix,1,sum,na.rm=TRUE)

# Uso de Lapply

mylist<-list(A=matrix(1:9,nrow=3),B=1:5,C=8)
mylist

lapply(mylist,sum)

unlist(lapply(mylist,sum))

lapply(mylist,function(x) x*20)
     
lapply(mylist,function(x) x*20)


# Uso de Sapply
sapply(mylist,sum)

# Uso de la función Sapply
mapply(rep,1:4,4:1)

x<-c(A=20,B=1,C=40)
y<-c(J=430,K=50,L=10)

simply<-function(u,v){
  (u+v)*2
}

mapply(simply,x,y)

# Uso de función Tapply
tapply(iris$Sepal.Length,iris$Species,max)

```

