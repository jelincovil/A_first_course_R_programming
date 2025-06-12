# Simulación

Cinco aplicaciones principales de la simulación estadística con R:

1. **Modelos de Regresión**: R permite simular datos que siguen un modelo o estructura dada². Esto es útil para comprender la naturaleza de los datos y para poner a prueba algunos procedimientos de modelos de regresión.

2. **Análisis de escenarios hipotéticos**: La simulación estadística en R implica crear modelos o experimentos computacionales para imitar procesos reales, generando datos aleatorios mediante funciones estadísticas y métodos de muestreo.

3. **Análisis de series de tiempo**: R proporciona funciones para analizar y predecir datos de series de tiempo.

4. **Pruebas estadísticas**: R permite realizar una amplia gama de pruebas estadísticas, que se pueden aplicar en diversas disciplinas.

5. **Estadísticas descriptivas**: R ofrece funciones para calcular estadísticas descriptivas básicas como la media, mediana, desviación típica, varianza, rango, cuartiles, percentiles y estadísticas de resumen para la exploración de datos.



## Generación de números pseudoaleatorios

La Generación de números pseudoaleatorios en computación se refiere al proceso de producir secuencias de números que parecen aleatorios, pero en realidad son generados por un algoritmo determinista. Estos son los puntos clave:

## Simulación de otras variables aleatorias.

### Generación de números Uniformes(a, b) 

```r
runif(5)

runif(10, min = -3, max = -1)
```

```r
u <- runif(10, min = -3, max = -1)
hist(u)
```

Notemos que una misma función con los mismo parametros genera secuencias de numeros diferentes.

```r

runif(5)

```

La función *set.seed(n)* fija la semilla de la generación de números aleatorios
proveyendo una misma secuencia de números:

```r

set.seed(32789) 
runif(5)

set.seed(666)
runif(5)

```

### Variables aleatorias de Bernoulli

```r

set.seed(23207) # use this to obtain our output
guesses <- runif(20)
correct.answers <- (guesses < 0.2)
correct.answers

```

```r

table(correct.answers)

```

```r
# Generamos números 0,1
rbinom(10,1,0.65)

Graficamos en un barplot
barplot(table(rbinom(10,1,0.65)))

```

### Variables aleatorias de Poisson

Función de probabilidad de Poisson

<img src="https://upload.wikimedia.org/wikipedia/commons/thumb/1/16/Poisson_pmf.svg/1280px-Poisson_pmf.svg.png" width="500"> 

Consideremos una variable $X \sim Poisson (3,7)$ con función de probabilidad
gráficada por

```r
s <- seq(0:8)
p <-  round( dpois(s,3.7), 3)
plot(s,p, type = "o")

```

```r
rpois(10, 3.7)

```




### Números aleatorios exponenciales

Función de densidad exponencial
<img src="https://upload.wikimedia.org/wikipedia/commons/thumb/f/f5/Exponential_distribution_pdf_-_public_domain.svg/1280px-Exponential_distribution_pdf_-_public_domain.svg.png" width="500"> 

Un banco tiene un solo cajero que se enfrenta a una fila de 10 clientes. El
El tiempo para atender a cada cliente se distribuye exponencialmente con la tasa.
3 por minuto. Podemos simular los tiempos de servicio (en minutos) para los 10
clientes.


```r
t <- seq(0,1, by=0.1)

p <-  round( dexp(t, rate = 3), 3)

plot(t, p, type = "l", col = "blue", 
     lwd=2, ylab = "f_exp", xlab = "T")

```


```r

servicetimes <- rexp(30, rate = 3)
servicetimes
hist(servicetimes)

```

Simulando 25 puntos de un proceso de Poisson de parametro $\lambda = 1.5$ comenzando desde 0.



```r

X <- rexp(25, rate = 1.5)
cumsum(X)
plot(0:24, X, type = "o", 
     main = "Proceso de Poisson",
     xlab = "Tiempo")

```

### Variables aleatorias Normales/Gaussianas

Función de densidad Normal
<img src="https://upload.wikimedia.org/wikipedia/commons/thumb/7/74/Normal_Distribution_PDF.svg/1920px-Normal_Distribution_PDF.svg.png" width="500"> 


```r
x <- rnorm(10, -3, 0.5)
print(x)
hist(x, main = "Variables Normales)

```

```r

x <- rnorm(100000) # simulate from the standard normal
x <- x[(0 < x) & (x < 3)] # reject all x's outside (0,3)
hist(x, probability=TRUE, main = "Variables Normales)

```
## Otros modelos de probabilidad

<img src = "https://raw.githubusercontent.com/jelincovil/A_course_R_programming_2024/main/images_for_r_programming/distribution_1.png" width="500"> 
<img src = "https://raw.githubusercontent.com/jelincovil/A_course_R_programming_2024/main/images_for_r_programming/distribution_2.png" width="500"> 

## Simulación de un modelo lineal

```r

set.seed(20)             
## Simulate predictor variable
 x <- rnorm(100)          
 ## Simulate the error term
 e <- rnorm(100, 0, 2)    
 ## Compute the outcome via the model
 y <- 0.5 + 2 * x + e     
 summary(y)

# Plot the model
plot(x, y)

```

## Simulación de Informe Laboral

Una hora antes de la apertura del mercado de valores el primer viernes de cada mes, la Oficina de Estadísticas Laborales de los EE. UU. publica el informe de empleo. Esta estimación ampliamente anticipada del cambio mensual en la nómina no agrícola es un indicador económico que a menudo conduce a cambios en el mercado de valores.

Si lees los blogs financieros, escucharás mucha especulación antes de que se publique el informe y mucho para explicar el cambio en el mercado de valores en los minutos posteriores a la publicación del informe. Y escucharás mucha anticipación de las consecuencias del informe de empleo de ese mes sobre las perspectivas de la economía en general. Resulta que muchos financieros leen mucho en los altibajos del informe de empleo. (Y otras personas, que no toman el informe tan en serio, ven oportunidades en responder a las acciones de los creyentes.)

Se sabe que en los meses posteriores al informe de empleo, se informa un número actualizado que puede tener en cuenta los datos que llegan tarde y que no se pudieron incluir en el informe original. Podriamos
simular los posibles resultados de este informe.

Consideremos como ejemplo de simulación el Rporte de Trabajo publicado en https://mdsr-book.github.io/mdsr2e/ch-simulation.html


Consideremos los siguientes códigos de R.

```r

jobs_true <- 150
 jobs_se <- 65  # in thousands of jobs
 gen_samp <- function(true_mean, true_sd, 
                      num_months = 12, delta = 0, id = 1) {
   samp_year <- rep(true_mean, num_months) + 
     rnorm(num_months, mean = delta * (1:num_months), sd = true_sd)
   return(
     tibble(
       jobs_number = samp_year, 
       month = as.factor(1:num_months), 
       id = id
     )
   )
 }

 n_sims <- 3
 params <- tibble(
   sd = c(0, rep(jobs_se, n_sims)), 
   id = c("Truth", paste("Sample", 1:n_sims))
 )
 params

```


```r

 df <- params %>%
   pmap_dfr(~gen_samp(true_mean = jobs_true, true_sd = ..1, id = ..2))
 
 
 ggplot(data = df, aes(x = month, y = jobs_number)) + 
   geom_hline(yintercept = jobs_true, linetype = 2) + 
   geom_col() + 
   facet_wrap(~ id) + 
   ylab("Number of new jobs (in thousands)")

```

## Un ejemplo de Shinny app web

https://bcdudek.net/rectangles/


Shiny es un paquete de R de código abierto que proporciona un marco de trabajo elegante y potente para construir aplicaciones web utilizando R. Shiny te ayuda a convertir tus análisis en aplicaciones web interactivas sin requerir conocimientos de HTML, CSS o JavaScript.

Aquí te dejo algunos detalles sobre Shiny:

- **Interfaz de usuario (UI)**: Define cómo se ve tu aplicación. En el caso más simple, puede ser una página que contiene palabras².
- **Función del servidor**: Define cómo funciona tu aplicación. Shiny utiliza la programación reactiva para actualizar automáticamente las salidas cuando cambian las entradas².
- **Expresiones reactivas**: Son el tercer componente importante de las aplicaciones Shiny².
- **Creación de la aplicación**: Puedes crear una aplicación Shiny creando un nuevo directorio para tu aplicación y colocando un solo archivo llamado app.R en él².

Shiny es una herramienta poderosa y flexible que facilita la construcción de aplicaciones web interactivas y paneles dinámicos directamente desde R⁴. Estas aplicaciones pueden alojarse en una página web independiente o incrustarse en documentos R Markdown⁴.



## Aplicación Shiny App


https://shiny.posit.co/r/gallery/

--------------------------------------------------------------------------


## Integración de Monte Carlo

### Aproximacion de probabilidades

$$

\lim_{n\to \infty}\dfrac{1}{n} \sum_{i=1}^{n} I_{(a,b)}(x_i) = P(a<X<b)=  \int_{a}^{b} f(x)dx 

$$


```r

```

```r

```

### Evaluación de la confianza de un intervalo de Confianza
$$
\lim_{n\to \infty}\dfrac{1}{n} \sum_{i=1}^{n} I_i(\mu) = \int_{a}^{b} f(t)dt= 1-\alpha
$$

```r

```


## Métodos avanzados de simulación

### Muestreo de rechazo/aceptación

Simulate pseudorandom variates from the triangular density function

Quiero generar variables de una densidad g(x)  en base a otra densidad acotada por f(x), es decir $k g(x) \leq f(x)$

1. Genero de X ~ f(x) y U ~ Uniforme (0,1)
2. Si   $U*f(x) \leq g(X)$, acepto  X.

```r
U1 <- runif(100000, max=2)
U2 <- runif(100000)
X <- U1[U2 < (1 - abs(1 - U1))]
hist(X)
```

```r
kg <- function(x) 0.5*exp(-(x^1.5)) # DENSIDAD exponencial
X <- rexp(100000)
U <- runif(100000)

# accept only those X
X <- X[ U*dexp(X) < kg(X) ] #

hist(X, freq = FALSE, breaks="Scott")


```

### Importancia del muestreo

1. Elija una densidad conveniente f(x) (que sabemos cómo extraer muestras de esta).
2. Obtenga $(x_1,\ldots,x_n)$ como muestra de f(x).
3. Calcular los pesos $wi = g(xi)/f(xi)$. para $i=1,\ldots, n$
Ahora podemos aproximarnos a la expectativa de una función h(X) donde $X \sim g(x)$ usando promedios de h(xi) ponderados por wi.


```r
# g(X) densidad target
g <- function(x) 10*exp(-x^{1.5})
X <- rexp(100000)
W <- g(X)/dexp(X)
media <- weighted.mean(X, W)
media
## [1] 0.6579773
weighted.mean( (X - media)^2, W)
```

```r

hist(X, freq = FALSE, breaks="Scott")
abline(v = media)

```


### El algoritmo de Metrópolis-Hastings

```r

theta <- seq(0, 1, length.out = 200)
prior <- dnorm(theta, mean = 0.5, sd = 0.1)
prior <- prior/max(prior)
n <- 200
x <- 54
posterior <- prior * theta^x * (1 - theta)^(n - x)
posterior <- posterior/max(posterior)
plot(theta, prior, type = "l", col = "blue", lwd=2,
     xlab = expression(theta), ylab = "Scaled Density")
lines(theta, posterior, col = "green", lwd= 2)
legend("topright", legend = c("Prior", "Posterior"), lty = 1,
       col = c("blue", "green"))

```

```r

logg <- function(theta) {
  dnorm(theta, mean = 0.5, sd = 0.1, log = TRUE) +
    x*log(theta) + (n - x)*log(1-theta)
}
N <- 100
xt <- numeric(N + 1)
xt[1] <- 0.5
sd <- 0.1


steps <- rnorm(N, 0, sd)
u <- runif(N)
for (i in 1:N) {
  y <- xt[i] + steps[i]
  if (y <= 0 || y >= 1 || log(u[i]) > logg(y) - logg(xt[i]))
    xt[i + 1] <- xt[i]
  else
    xt[i + 1] <- y
}

plot(0:N, xt, type = "l", ylab = expression(x[t]), xlab = "t")

```


##  Ejemplo de aplicación

Consideremos una variable aleatoria $D$ que asume valores en el conjunto de los números Naturales con función de probabilidad:

<img src = "https://raw.githubusercontent.com/jelincovil/A_course_R_programming_2024/main/images_for_r_programming/Weibull_II.png" width="800"> 

```r

# Función de Riesgo Weibull tipo II, 

pd <- function(d = NULL, pi = NULL, b = NULL) {
  
  if(d>0){p <- pi*d^(b-1)} else{p=0}
  return(p)
  
}

# Función de probabilidad

prob <- function(d,pi,b){
  
  ps <- as.numeric( lapply(1:d,  function(x) pd(x, pi, b) ) )  
  as <- 1-ps[1:(d-1)]
  producto <- ps[d]*prod(as)
  return(producto)
}


prob(2, 0.6, 0.8)


d=20
p <- rep(0, d)
for (i in 1:d) {
  p[i] <-  prob(i, 0.2, 0.9) 
}

p

plot(1:d, p, type = "o", main = "Probabilidad Weibull tipo II function")

```

```r

d <- 1:length(p)
probabilities <- p/sum(p)

# Take a sample
muestra <- sample(d, 
                      size = 100, 
                      replace = TRUE, 
                      prob = probabilities)


hist(muestra, probability = TRUE,  breaks="Scott")


```


```r

```


% ## Referencias
