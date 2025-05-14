# **La gramatica de los gráficos. Libreria `ggplot2`**

<img src="https://ggplot2.tidyverse.org/logo.png" alt="Logo de ggplot2" width="100">   <img src="https://ggplot2-book.org/cover.jpg" alt="Portada del libro ggplot2" width="100">


## Personalizar el aspecto de un gráfico
- `ggtitle`
- `xlab` y `ylab`.
- `theme()`
- `scale()`
- `annotate()`
- `geom_jitter()`

# Unidad II: gráficos de bajo y alto nivel

# **SESIÓN 1: primeros códigos**

Link del video del 14-05-2025 [Video](https://udla.zoom.us/rec/share/LOPwzXsheRVkUssluOA-4OuowKLl3-WW57v_nPB1zX36y3pZKHh6TFgevVZF7MIn.pNIDMEf_-B_4OgD5?startTime=1747177227000&pwd=jHtlMW0ivbmingK4JLxEfooheUGlGHjB)

## Gráficos usando librerías bases de R

Los gráficos básicos en R permiten una visualización clara y efectiva de los datos, facilitando su exploración inicial. La función **`barplot()`** se utiliza para representar datos categóricos mediante barras, lo que permite comparar frecuencias o proporciones entre distintas categorías. Por su parte, **`hist()`** muestra la distribución de una variable numérica continua, agrupando los valores en intervalos y permitiendo identificar patrones como sesgos, simetrías o concentraciones. El **`boxplot()`**, o diagrama de caja, resume visualmente la distribución de una variable, destacando la mediana, los cuartiles y los valores atípicos, siendo útil para comparar varias distribuciones simultáneamente. Finalmente, **`plot()`** en su forma más básica genera gráficos de dispersión entre dos variables numéricas, revelando relaciones, tendencias o correlaciones. Estos gráficos constituyen herramientas fundamentales para el análisis exploratorio de datos.

```{r}
library("knitr")
library(MPV)
data(WorldPhones)
str(WorldPhones)
```

### Gráfico de barras

```{r}
WorldPhones51 <- WorldPhones[1, ]
WorldPhones51
```

```{r}
barplot(WorldPhones51, main = "Telephone Usage in 1951", cex.names = 0.75,
cex.axis = 0.75, ylab = "Telephones (in Thousands)", xlab="Region")
```

### Gráfico de puntos

```{r}
dotchart(WorldPhones51, xlab = "Numbers of Phones ('000s)")
```

### Gráfico de barras por grupos

```{r}
barplot(VADeaths, beside = TRUE, legend = TRUE, ylim = c(0, 90),
ylab = "Deaths per 1000",
main = "Death rates in Virginia")
```

### Gráfico de torta

```{r}
groupsizes <- c(18, 30, 32, 10, 10)
labels <- c("A", "B", "C", "D", "F")
pie(groupsizes, labels,
col = c("grey40", "white", "grey", "black", "grey90"))
```

### Gráfico de histograma

```{r}
hist(log(1000*islands, 10), xlab = "Area (on base 10 log scale)",
main = "Areas of the World's Largest Landmasses")
```

### Gráfico de caja y bigotes

```{r}

data(iris)

boxplot(Sepal.Length ~ Species, data = iris,
ylab = "Sepal length (cm)", main = "Iris measurements",
boxwex = 0.5)

```

### Gráficos QQplots (quantile quantile)

```{r}
par(mfrow = c(1,4))
X <- rnorm(1000)
A <- rnorm(1000)
qqplot(X, A, main = "A and X are the same")
B <- rnorm(1000, mean = 3, sd = 2)
qqplot(X, B, main = "B is rescaled X")
C <- rt(1000, df = 2)
qqplot(X, C, main = "C has heavier tails")
D <- rexp(1000)
qqplot(X, D, main = "D is skewed to the right")

```

## La gramatica de los gráficos

El libro *The Grammar of Graphics* de Leland Wilkinson propone una visión estructurada y modular de la visualización de datos, en la que los gráficos no son simplemente imágenes estáticas, sino construcciones formales compuestas por elementos fundamentales. Esta obra establece una base teórica sólida para entender cómo se generan los gráficos, descomponiéndolos en componentes como datos, transformaciones estadísticas, geometrías, escalas, coordenadas y guías. Esta perspectiva ha influido profundamente en el desarrollo de herramientas modernas de visualización, como el paquete `ggplot2` en R, que implementa esta gramática de manera práctica y flexible, permitiendo a los usuarios construir gráficos complejos a partir de principios simples y combinables.

La idea de “gramática” en este contexto se refiere a un conjunto de reglas y estructuras que, al igual que en el lenguaje natural, permiten construir expresiones complejas a partir de unidades básicas. En el caso de los gráficos, estas unidades incluyen los datos (el contenido), las geometrías (cómo se representan visualmente), las escalas (cómo se mapean los valores), y las coordenadas (el sistema de referencia). Esta gramática permite que los gráficos sean generados de forma coherente, reproducible y extensible, lo que resulta especialmente útil en programación, donde la claridad y la modularidad son esenciales. Así, crear un gráfico en `ggplot2` no es simplemente dibujar, sino componer una estructura visual con significado, basada en reglas bien definidas.

`ggplot2` implementa una gramática de los gráficos inspirada en la obra de Leland Wilkinson, donde cada visualización se construye como una oración compuesta por elementos básicos que siguen reglas definidas. En esta gramática, los **datos** actúan como el sujeto, la **estética** como la estructura gramátical que conecta variables con atributos visuales, y la **geometría** como el verbo que define la forma del gráfico (puntos, líneas, barras, etc.). A estos se suman componentes como transformaciones estadísticas, escalas, coordenadas, temas y etiquetas, que enriquecen y completan el significado visual. Esta estructura modular permite construir gráficos complejos de manera lógica, clara y reproducible, haciendo de `ggplot2` una herramienta poderosa y elegante para el análisis visual de datos. La fórmula que resume esta lógica es:

\
**Gráfico = Datos + Estética + Geometría + (Transformaciones + Escalas  + Coordenadas + Temas + Etiquetas)**,\

lo que refleja cómo, al igual que en el lenguaje, se pueden formar expresiones ricas y precisas a partir de reglas simples y combinables.

Un ejemplo concreto de esta gramática en acción puede verse en el siguiente código en R, que utiliza `ggplot2` para explorar la relación entre el peso y el consumo de combustible de automóviles:

```{r}
library(ggplot2)  
data(mtcars)

ggplot(data = mtcars, aes(x = wt, y = mpg)) +   
  geom_point() +   
  geom_smooth(method = "lm", se = FALSE) +   
  labs(title = "Consumo vs Peso del Vehículo",
       x = "Peso (1000 lbs)",  
       y = "Millas por galón") 

```

En este gráfico, los datos (`mtcars`) se mapean a los ejes mediante `aes()`, se representan con puntos (`geom_point()`), se añade una capa de modelo lineal (`geom_smooth()`), y se etiquetan con `labs()`. Cada componente responde a una parte de la gramática, lo que permite construir visualizaciones claras, interpretables y adaptables a distintos contextos analíticos.

## Gráficos personalizados con `ggplot2`

```{r}

#library(ggplot2)
data("windWin80")
str(windWin80)


```

### Barplot con `ggplot2`

```{r}

library(ggplot2)
region <- names(WorldPhones51)
phones51 <- data.frame(Region = factor(region, levels = region),
Telephones = WorldPhones51)
ggplot(data = phones51, aes(x = Region, y = Telephones)) + geom_col()

```

### Agregando la grid

```{r}
g1 <- ggplot(phones51, aes(Region, Telephones))
g1
```

### Gráfico circular en \`ggplot2\`

```{r}

ggplot(phones51, aes(x = "", y = Telephones, fill = Region)) +
coord_polar(theta = "y") +
geom_col()

```

### Gráfico de poligono

```{r}
ggplot(phones51, aes(Region, Telephones)) +
geom_col() +
geom_line(col = "blue", aes(x = as.numeric(Region))) +
geom_point(col = "red")
```

### Boxplot con \`ggplot2\`

```{r}
ggplot(iris, aes(x = Species, y = Sepal.Length)) + geom_boxplot()

```

### Gráfico de violin con \`ggplot2\`

```{r}
ggplot(iris, aes(x = Species, y = Sepal.Length)) + geom_violin()
```

### Paleta de colores

```{r}
str(colors())
```

```{r}
palette.pals()
```

```{r}
palette()
```

### Personalizando gráficos con la paleta de colores

```{r}
ggplot(phones51, aes(Region, Telephones, fill = Region)) +
geom_col() +
scale_fill_brewer(palette = "Set2")
```

```{r}
ggplot(phones51, aes(Region, Telephones, fill = Telephones)) +
geom_col()
```

### Subdivisión de datos y gráficos separados (Faceting)

Es una técnica utilizada en visualización de datos para analizar y mostrar relaciones complejas entre múltiples variables. La idea es dividir el conjunto de datos en grupos más pequeños (subconjuntos) basados en los valores de ciertas variables. Luego, se crean gráficos separados para cada subconjunto, mostrando cómo las otras variables se comportan dentro de esos grupos. Esto permite una comparación más clara y detallada de las relaciones entre las variables en diferentes contextos.

```{r}

phones <- data.frame(Year = as.numeric(rep(rownames(WorldPhones), 7)),
Region = rep(colnames(WorldPhones), each = 7),
Telephones = as.numeric(WorldPhones))

ggplot(phones, aes(x = Region, y = Telephones, fill = Region)) +
geom_col() +
facet_wrap(vars(Year)) +
theme(axis.text.x = element_blank(), axis.ticks.x = element_blank()) +
xlab(element_blank())

```

```{r}
ggplot(mpg, aes(hwy, cty)) +
geom_point() +
facet_grid(cut_number(displ, 3) ~ cyl)

```

### Gráficos separados en una misma grid

```{r}
ggplot(mpg, aes(hwy, fill = factor(cyl))) +
geom_histogram(binwidth = 2)
```

### Matrices de gráficos

La función `ggarrange` del paquete `ggpubr` en R es una herramienta poderosa para organizar múltiples gráficos creados con `ggplot2` en una disposición de matriz. Esto es especialmente útil cuando se desea presentar varios gráficos de manera conjunta para facilitar la comparación visual y el análisis. Al utilizar `ggarrange`, puedes especificar el número de filas y columnas para la matriz de gráficos, así como ajustar el tamaño y la alineación de cada gráfico dentro del espacio común. Esta función simplifica la creación de paneles de gráficos complejos, permitiendo una presentación más clara y coherente de los datos.

```{r}
library(ggpubr)

p1 <- ggplot(mpg, aes(hwy, fill = factor(cyl))) + geom_histogram(binwidth = 2)
p2 <- ggplot(phones51, aes(Region, Telephones, fill = Telephones)) +
geom_col()

ggarrange(p1, p2, 
           labels = c("A", "B"),
           ncol = 1, nrow = 2)
```

```{r}
ggarrange(p1, p2, 
           labels = c("A", "B"),
           ncol = 2, nrow = 1)
```
# **SESIÓN 2: aplicación a un proyecto de Data Science**

## Referencias

- The Grammar of Graphics. Leland Wilkinson. [Libro](https://link.springer.com/book/10.1007/0-387-28695-0)
- Documentación oficial de la libreria `ggplot2`: [ggplot2](https://ggplot2.tidyverse.org/)
  
- ggplot2: Elegant Graphics for Data Analysis (3e) [ggplot2-book.org](https://ggplot2-book.org/)
  
- Introduction to Scientific Programming and Simulation Using R [Libro pdf](https://nyu-cdsc.github.io/learningr/assets/simulation.pdf)
- Ejemplo de tutorial de `ggplot2` en youtube [Video](https://www.youtube.com/watch?v=0wpLOsqwhWs&list=PLN3jIazaJLCOWery5d_kCp5G5NUxu5wcd)


  
