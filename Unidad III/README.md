# Unidad III:   Programando con R

# Clase del Martes

La programación implica escribir sistemas de instrucciones relativamente complejos.
Hay dos estilos amplios de programación: el estilo **imperativo** implica encadenar 
instrucciones que le dicen a la computadora qué hacer. El estilo **declarativo** implica
escribir una descripción del resultado final, sin dar detalles sobre cómo
para llegar allí.

##  **Control del flujo "flow" DETERMINISTA**

```mermaid
graph TD
A[Inicio] --> B{Condición del input}
B --> C{Sí} --> D[Ejecutar bloque de código]
D --> E{¿Continuar?}
E --> C
B --> F{No} --> G[Ejecutar bloque de código while]
H{¿Condición?}
G --> H
H --> I{Sí} --> D
H --> F
I --> G
F --> J[Fin]
```

**Explicación del diagrama:**

* El diagrama comienza en el nodo **A (Inicio)**.
* Desde **A**, hay una pregunta que decide si se debe usar un bucle **for** o un bucle **while**.
* Si la respuesta a la pregunta es **sí** (nodo **B**), el flujo pasa al nodo **C (Ejecutar bloque de código)**.
* Dentro del bucle **for**, el bloque de código se ejecuta (nodo **D**).
* Luego, hay otra pregunta que decide si se debe continuar con el bucle (nodo **E**).
* Si la respuesta es **sí**, el flujo vuelve al nodo **C** para ejecutar el bloque de código nuevamente.
* Si la respuesta es **no**, el flujo sale del bucle **for** y pasa al nodo **F (No)**.
* Si la respuesta a la pregunta inicial (nodo **B**) es **no**, el flujo pasa directamente al nodo **G (Ejecutar bloque de código while)**.
* Dentro del bucle **while**, el bloque de código se ejecuta (nodo **D**).
* Luego, la condición del bucle se evalúa en el nodo **H (¿Condición?)**.
* Si la condición es **sí**, el flujo vuelve al nodo **G** para ejecutar el bloque de código nuevamente.
* Si la condición es **no**, el flujo sale del bucle **while** y pasa al nodo **F (No)**.
* Finalmente, el flujo termina en el nodo **J (Fin)**.
* 
### El loop *for ( )*

Calculo de un factorial:

```r
n <- 100
result <- 1
for (i in 1:n)
result <- result * i
result
```
Calculo de la sequencia de Fibonacci:

```r
Fibonacci <- numeric(12)
Fibonacci[1] <- Fibonacci[2] <- 1
for (i in 3:12)
Fibonacci[i] <- Fibonacci[i - 2] + Fibonacci[i - 1]
```




### El condicionador *if (  )*

Syntax

```r
if (condition) {commands when TRUE}
if (condition) {commands when TRUE} else {commands when FALSE}
```
Un ejemplo simple

```r
x <- 3
if (x > 2) y <- 2 * x else y <- 3 * x
```

```r
Eratosthenes <- function(n) {
# Return all prime numbers up to n (based on the sieve of Eratosthenes)
if (n >= 2) {
sieve <- seq(2, n)
primes <- c()
for (i in seq(2, n)) {
if (any(sieve == i)) {
primes <- c(primes, i)
sieve <- c(sieve[(sieve %% i) != 0], i)
}
}
return(primes)
} else {
stop("Input value of n should be at least 2.")
}
}

Eratosthenes(50)
```

### El loop *while ( )*

Syntax
```r
while (condition) {statements}

```

Calculo de números de la secuencia de Fibonacci:
```r
Fib1 <- 1
Fib2 <- 1
Fibonacci <- c(Fib1, Fib2)
while (Fib2 < 300) {
Fibonacci <- c(Fibonacci, Fib2)
oldFib2 <- Fib2
Fib2 <- Fib1 + Fib2
Fib1 <- oldFib2
}

Fibonacci

```

```r
```
### El loop *repeat* y el *break* y proximos declaraciones

Syntax
```r
repeat { statements } if (condition) break
```

```r
x <- x0
tolerance <- 0.000001
repeat {
f <- xˆ3 + 2 * xˆ2 - 7
if (abs(f) < tolerance) break
f.prime <- 3 * xˆ2 + 4 * x
x <- x - f / f.prime
}
x
```

```r
```



## *GESTION DE LA COMPLEJIDAD ATRAVEZ DE FUNCIONES*

La mayoría de los programas informáticos reales son mucho más largos que los ejemplos que damos en este libro. La mayoría de las personas no pueden tener todos los detalles en la cabeza a la vez, por lo que es extremadamente importante encontrar formas de reducir la complejidad. A lo largo de los años se han desarrollado diversas estrategias de diseño de programas. En esta sección damos un breve resumen de algunas de las estrategias que nos han funcionado.

Las funciones son unidades autónomas de código R con un propósito bien definido. En general, las funciones toman entradas, hacen cálculos (posiblemente imprimiendo resultados intermedios, dibujando gráficos, llamando a otras funciones, etc.) y producen resultados. Si las entradas y salidas están bien definidas, el programador puede estar razonablemente seguro de si la función funciona o no: y una vez que funciona, puede pasar al siguiente problema.



### ¿Qué son las funciones?

En el análisis de datos, podrías definir funciones para realizar tareas comunes como la limpieza de datos, la transformación de datos, o el ajuste de modelos. Por ejemplo, aquí hay una función que podría usar para calcular la media de una columna en un dataframe:

Sintaxis
```r
func_name <- function (parameters) {
statement
}
```

```r
annuityAmt <- function(n, R, i) {
R*((1 + i)ˆn - 1) / i
}
annuityAmt(10, 400, 0.05)
```

```r
# define a function to compute power
power <- function(a = 2, b) {
    print(paste("a raised to the power b is: ", a^b))
}

# call the power function with arguments
power(2, 3)

# call function with default arguments
power(b=3)
```

```r
# define a function to compute power
power <- function(a, b) {
    return (a^b)
}

# call the power function with arguments
print(paste("a raised to the power b is: ", power(2, 3)))
```



### Devolución de varios objetos en listas

```r
annuityValues <- function(n, R, i) {
amount <- R*((1 + i)ˆn - 1) / i
PV <- amount * (1 + i)ˆ(-n)
list(amount = amount, PV = PV)
}
annuityValues(10, 400, 0.05)
```

### Uso de clases de S3 para controlar la impresión

Una solución general a este problema es declarar el tipo de valor de retorno y decirle a R cómo imprimir cosas así. Este es un tipo de programación orientada a objetos. De hecho, hay varias formas de hacer esto y una discusión completa está más allá del alcance de este texto, pero en esta sección mostraremos una de las formas más simples: usar métodos S3.

Además de tener valores, los objetos en R pueden tener atributos con nombre. La clase S3 es (en el caso más simple) una cadena de caracteres llamada clase que contiene la clase del objeto.

```r
annuityValues <- function(n, R, i) {
amount <- R*((1 + i)^n - 1) / i
PV <- amount * (1 + i)^(-n)
list(amount = amount, PV = PV)
}

# Aplicar la función
annuityValues(10, 400, 0.05)

# Creo la clase Annuity
values <- annuityValues(10, 400, 0.05)
class(values) <- "annuity"

# Creo una forma bacana de imprimir los resultados
 
print.annuity <- function(x, ...) {
cat("An annuity object with present value", x$PV, "and final value",
x$amount, "\n")
invisible(x)
}

values

values$PV
```

# Clase del martes 28-05-2024


### El operador %>% del paquete *magrittr*

```r
# Para aplicar una función f de dos argumentos f(x,y), podemos escribir
x %>% f(x, y)
# Simbolizando, dado el objeto x, aplicar la función f en los
# argumentos f(x,y)
```


```r
boxplot(Sepal.Length ~ Species, data = iris,
        ylab = "Sepal length (cm)",
        main = "Iris measurements",
        boxwex = 0.5)
```

```r
iris %>% boxplot(Sepal.Length ~ Species, data = .,
                 ylab = "Sepal length (cm)",
                 main = "Iris measurements",
                 boxwex = 0.5)
```


El operador `%>%` del paquete `magrittr` en R es muy útil para encadenar operaciones. Veamos otros dos ejemplos utilizando el conjunto de datos `iris`:
**Ejemplo 1: Resumen estadístico de las variables numéricas**
```r
library(dplyr)
library(magrittr)

iris %>%
  summarise_at(vars(-Species), funs(mean(., na.rm = TRUE), sd(., na.rm = TRUE)))
```
Este código calcula la media y la desviación estándar de todas las columnas numéricas en el conjunto de datos `iris`, excluyendo la columna `Species`.

**Ejemplo 2: Filtrado y ordenamiento**
```r
iris %>%
  filter(Species == "setosa") %>%
  arrange(desc(Sepal.Length))
```
Este código filtra el conjunto de datos `iris` para incluir solo las filas donde `Species` es "setosa", y luego ordena estas filas en orden descendente por `Sepal.Length`.

###  La función *replicate ( )*

- Replica una funcition un número **n** de veces.
- 
syntaxis
```r
replicate(n, { statements })
```

Replicar 5 veces de una muestra de 1:5
```r
replicate(5, 1:5)
```

5 muestras de tamaño 6 de una variable Normal con media 2 y varianza 1
```r
replicate(5, rnorm(6, 2,1))
```

```r

```

## *Consejos de programación miscelánea*


### La limpieza cuenta del código

Evitar errores en los códigos
```r
x1<-a+b+c
y12< -a+b+c
```

Código espaciado y simetrico
```r
x1 <- a + b + c
y12 < -a + b + c

```

### Diseño de arriba hacia abajo


<img src="https://raw.githubusercontent.com/jelincovil/A_course_R_programming/main/images_for_r_programming/arriba_hacia_abajo.png" width="500"> 

```r
# 1. Use a merge sort to sort a vector
mergesort <- function (x) {
  ## 2: sort x into result
  return (result)
}
```

```r
# 1. Use a merge sort to sort a vector
mergesort <- function (x) {
  # 2: sort x into result
  ## 2.1: split x in half
  ## 2.2: sort each half
  ## 2.3: merge the 2 sorted parts into a sorted result
  return (result)
}

```

```r
# 2.1: split x in half
len <- length(x)
x1 <- x[1:(len %/% 2)]
x2 <- x[(len %/% 2 + 1):len]
```

```r
# 1. Use a merge sort to sort a vector
mergesort <- function (x) {
  # Check for a vector that doesn't need sorting
  len <- length(x)
  if (len < 2) result <- x
  else {
    # 2: sort x into result
    # 2.1: split x in half
    y <- x[1:(len %/% 2)]
    z <- x[(len %/% 2 + 1):len]
    ## 2.2: sort y and z
    ## 2.3: merge y and z into a sorted result
  }
  return(result)
}

```

```r

# 2.2: sort y and z
y <- mergesort(y)
z <- mergesort(z)
```

```r
# 1. Use a merge sort to sort a vector
mergesort <- function (x) {
# Check for a vector that doesn't need sorting
len <- length(x)
if (len < 2) result <- x
            else {
# 2: sort x into result
# 2.1: split x in half
y <- x[1:(len %/% 2)]
z <- x[(len %/% 2 + 1):len]
# 2.2: sort y and z
y <- mergesort(y)
z <- mergesort(z)
# 2.3: merge y and z into a sorted result
result <- c()
## 2.3.1: while (some are left in both piles)
## 2.3.2: put the smallest first element on the end
## 2.3.3: remove it from y or z
## 2.3.4: put the leftovers onto the end of result
}
return(result)
}

```

```r
# 1. Use a merge sort to sort a vector
mergesort <- function (x) {
  # Check for a vector that doesn't need sorting
  len <- length(x)
  if (len < 2) result <- x
  else {
    # 2: sort x into result
    
    # 2.1: split x in half
    y <- x[1:(len %/% 2)]
    z <- x[(len %/% 2 + 1):len]
    # 2.2: sort y and z
    y <- mergesort(y)
    z <- mergesort(z)
    # 2.3: merge y and z into a sorted result
    result <- c()
    # 2.3.1: while (some are left in both piles)
    while (min(length(y), length(z)) > 0) {
      # 2.3.2: put the smallest first element on the end
      # 2.3.3: remove it from y or z
      if (y[1] < z[1]) {
        result <- c(result, y[1])
        y <- y[-1]
      } else {
        result <- c(result, z[1])
        z <- z[-1]
      }
    }
    # 2.3.4: put the leftovers onto the end of result
    if (length(y) > 0)
      result <- c(result, y)
    else
      result <- c(result, z)
  }
  return(result)
}


```

Ordenando una mustra de un modelo Normal y Poisson
```r
mergesort(rnorm(10,3,1))
```

```r
mergesort(rpois(10,5))
```



### Reconociendo errores

```r
sqrt(var)

```

```r

x <- c(2,4,5,6,8,3,3,1)
mean("x")

```

```r

mean(X)

```

```r

if (x == NA) print("NA")

```


### Identificar la causa del error


### Depuración de los operadores %>% magrittr

- **Aplicquemos este desafio**: Elija un número entre 1 y 10 y manténgalo en secreto. Multiplica tu número por 3. Suma 3. Multiplica por 3 nuevamente. 
Pronostico: Los dígitos de tu número actual suman 9.


```r
library(magrittr)
x <- sample(1:10, 1)
x %>% multiply_by(3) %>% add(5) %>% multiply_by(3)

```

Los dígitos no suman 9! Para depurar esto, podemos reescribir el secuencia, guardando resultados intermedios


```r
r1 <- x %>% multiply_by(3); r1

r2 <- r1 %>% add(5); r2

r3 <- r2 %>% multiply_by(3); r3

```
Ahora es obvio que no sumamos 3 en el segundo paso, sumamos 5.

La otra forma de depurar esto es insertar la función magrittr debug_pipe() en la tubería, por ejemplo.
Esto llama al navegador browser() entre cada paso con el valor actual almacenado en x. Luego pasa x al siguiente paso sin cambios. Podemos imprimir x y reconocer cuando no es el valor correcto. 

```r
x %>% multiply_by(3) %>% debug_pipe() %>% add(5) %>%
  debug_pipe() %>% multiply_by(3)

```

Podemos comprobar que nuestra solución es correcta haciendo el cálculo para cada opción inicial posible:

```r
1:10 %>% multiply_by(3) %>% add(3) %>% multiply_by(3)
```
y ahora vemos otro error: si se hubiera elegido 10, la suma de dígitos sería 18, por lo que deberíamos reformular el truco de magia para seguir sumando dígitos hasta llegar a un solo dígito.


## *Programación eficiente*

- Una función o programación en R es ineficiente si su ejecución demora mucho tiempo y una gran cantidad de memoria.
  
Por ejemplo, la suma de dos vectores se podría hacer de la siguiente manera

```r
X <- rnorm(100000) # Xi ˜ N(0, 1) i=1, ..., 100,000
Y <- rnorm(100000) # Yi ˜ N(0, 1) i=1, ..., 100,000
Z <- c()
for (i in 1:100000) {
  Z <- c(Z, X[i] + Y[i]) # this takes about 25 seconds
}

```

```r

Z <- rep(NA, 100000)
for (i in 1:100000) {
  Z[i] <- X[i] + Y[i] # this takes about 0.15 seconds
}

Z <- X + Y
```



### Mide el tiempo que tarda tu programa

Usamos la función **system.time** para medir el tiempo 
de ejecución.

```r
X <- rnorm(100000)
Y <- rnorm(100000)
Z <- c()
system.time({
for (i in 1:100000) {
Z <- c(Z, X[i] + Y[i])
}
})
```


```r
Z <- rep(NA, 100000)
system.time({
for (i in 1:100000) {
Z[i] <- X[i] + Y[i]
}
})

system.time(Z <- X + Y)

```


```r

```




## *Referencias*
1.  Introduction  to  Scientific  Programming and Simulation  Using R: [https://nyu-cdsc.github.io/learningr/assets/simulation.pdf](https://nyu-cdsc.github.io/learningr/assets/simulation.pdf)
2.  Advanced R: [https://adv-r.hadley.nz/](https://adv-r.hadley.nz/)

