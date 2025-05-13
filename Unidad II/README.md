# **La gramatica de los gráficos. Libreria `ggplot2`**

<img src="https://ggplot2.tidyverse.org/logo.png" alt="Logo de ggplot2" width="100">   <img src="https://ggplot2-book.org/cover.jpg" alt="Portada del libro ggplot2" width="100">

¿Que es ?


## Personalizar el aspecto de un gráfico
- `ggtitle`
- `xlab` y `ylab`.
- `theme()`
- `scale()`
- `annotate()`
- `geom_jitter()`
- `windWin80`: un conjunto de datos de *R*.

Data from the MPV package contains pairs of observations of wind speed at the Winnipeg International Airport. The columns
give the wind speed in km per hour at midnight (h0) and noon (h12).

### Mejorando el gráfico
```r
library(MPV)
library(ggplot2)
a1 <- 3/2; a2 <- 5/3; b0 <- 108; b1 <- 5.3; b2 <- 65
grid <- with(MPV::windWin80,
             expand.grid(x1 = seq(0, max(h0), len=101),
                         x2 = seq(0, max(h12), len=101)))
grid$z <- with(grid, a1*a2*exp(-x1^a1/b2 - x2^a2/
                                 (b0+b1*x1))*x1^(a1-1)*x2^(a2-1)/(b2*(b0+b1*x1)) )
# Plot the data on top of the density function
ggplot(MPV::windWin80, aes(x = h0, y = h12)) +
  geom_contour(data = grid, aes(x = x1, y = x2, z = z) ) +
  geom_point()
```

- Sacar o destacar datos que se super ponen: geom_jitter()
- Usar xlab() and ylab(). para dejar más información en los ejes.
- Agregar lineas de contorno en base a los datos y no ecuaciones. Para hacer esto, podríamos agregar una función PDF estimada a
el gráfico usando geom_density2d():
- La función o theme() podría ayudar a destacar la cuadricula.
- 

```r
ggplot(MPV::windWin80, aes(x = h0, y = h12)) +
  geom_density2d(col = "red") +
  geom_contour(data = grid, aes(x = x1, y = x2, z = z) ) +
  geom_jitter() +
  xlab("Wind speed at midnight (km/h)") +
  ylab("Wind speed at noon (km/h)") +
  theme(panel.grid = element_blank()) +
  annotate("text", x = 46, y = 20, hjust = 0, label = "Too many points") +
  annotate("segment", x = 46, y = 20, xend = 35, yend = 34) +
  annotate("text", x = 5, y = 50, vjust = -1, label = "Too few points") +
  annotate("segment", x = 5, y = 50, xend = 6, yend = 11)

```
## Subdividir el gráfico por grupo

Usaremos la función facet_grid()

```r

ggplot(phones, aes(x = Region, y = Telephones, fill = Region)) +
  geom_col() +
  facet_wrap(vars(Year)) +
  theme(axis.text.x = element_blank(), axis.ticks.x = element_blank()) +
  xlab(element_blank())

```

```r
data(mtcars)
ggplot(mpg, aes(hwy, cty)) +
  geom_point() +
  facet_grid(cut_number(displ, 3) ~ cyl)

```

## Crear grupos con `ggplot()`

```r

For example, with the mpg data set,
ggplot(mpg, aes(hwy, fill = factor(cyl))) +
geom_histogram(binwidth = 2)

```

## Otros sistemas gráficos

## El paquete lattice

```r
library(lattice)
xyplot(Telephones ˜ Year | Region, data = phones)
```

## El paquete grid

```r
library(grid)
grid.rect() # draw black rectangle containing original viewport
vp <- viewport(h = 0.4, w = 0.6, angle = 60)
pushViewport(vp) # create viewport rotated 60 degrees (counter clockwise)
# with height 40% and width 60% of original box
grid.rect(gp = gpar(col = "red")) # draw red rectangle around new viewport
pushViewport(vp) # create new viewport nested in previous viewport,
# rotated 60 degrees and with height 40%
# and width 60% of previous viewport.
grid.rect(gp = gpar(col = "blue"))
```

# Creación de funciones que automatizan el trabajo.

## Función para variable categorica

## Función para dos variables categoricas.

## Referencia sobre Programación funcional en R

Programación funcional R, en esencia, es un lenguaje de programación funcional (FP). Esto significa que proporciona muchas herramientas para la creación y manipulación de funciones. En particular, R tiene lo que se conoce como funciones de primera clase. Puedes hacer cualquier cosa con funciones que puedas hacer con vectores: puedes asignarlas a variables, almacenarlas en listas, pasarlas como argumentos a otras funciones, crearlas dentro de funciones e incluso devolverlas como resultado de una función.

Comienzamos mostrando un ejemplo motivador, eliminando la redundancia y la duplicación en el código utilizado para limpiar y resumir datos. Luego aprenderá sobre los tres componentes básicos de la programación funcional: funciones anónimas, cierres (funciones escritas por funciones) y listas de funciones. Estas piezas se entrelazan en la conclusión que muestra cómo construir un conjunto de herramientas para la integración numérica, a partir de primitivas muy simples. Este es un tema recurrente en FP: comenzar con bloques de construcción pequeños y fáciles de entender, combinarlos en estructuras más complejas y aplicarlos con confianza.

La discusión sobre la programación funcional continúa en los dos capítulos siguientes: funcionales explora funciones que toman funciones como argumentos y devuelven vectores como salida, y operadores de funciones explora funciones que toman funciones como entrada y las devuelven como salida.

- Describir. La motivación motiva la programación funcional utilizando un problema común: limpiar y resumir datos antes de un análisis serio.

- Funciones anónimas le muestra un lado de las funciones que quizás no conocía: puede usar funciones sin darles un nombre.

- Cierres introduce el cierre, una función escrita por otra función. Un cierre puede acceder a sus propios argumentos y variables definidas en su padre.

- Listas de funciones muestra cómo colocar funciones en una lista y explica por qué podría interesarle.

- La integración numérica concluye el capítulo con un estudio de caso que utiliza funciones anónimas, cierres y listas de funciones para construir un conjunto de herramientas flexible para la integración numérica.

Referencia: http://adv-r.had.co.nz/Functional-programming.html

## Ejemplo de verificación paso a peso de una función

```r
data(mtcars)

# Step by step
df = mtcars
colores = viridis(10)[4:6]
variable = "cyl"

c1 <- colores[1] ; c2 <- colores[2] ; c3 <- colores[3] # sacar los colores en 3 caracteres

c(c1,c2,c3)

grupo <- names(table(df[, variable]))

n <- as.vector(table(df[, variable]))

as.vector(table(df[, variable]))
length(df[, variable])


prop <- as.vector(table(df[, variable]))/length(df[, variable])


count.data <- data.frame(
  grupo = names(table(df[, variable])),
  n = as.vector(table(df[, variable])),
  prop = round(n/length(df[, variable])*100, 3)
)

count.data

help(arrange)

count.data <- count.data %>%
  arrange(desc(grupo)) %>%
  mutate(lab.ypos = cumsum(prop) - 0.5*prop)

count.data

g1 <- ggplot(count.data, aes(x = grupo, y=n ) ) +
  geom_bar(stat="identity", width= 1, fill= c1 , 
           color = c2, alpha=2.5) +
  geom_text(aes(label = n, y = n + 1), color = "black",
            position = position_dodge(width = 1)) +
  ggtitle(paste("Gráfico de barras para", variable)) +
  xlab(variable) + 
  ylab(paste("Número de casos por", variable))+
  theme(panel.background = element_rect(fill = c3, 
                                        colour = c3, size = 2, linetype = "solid"))
g1

# abro llaves
c1 <- colores[1] ; c2 <- colores[2] ; c3 <- colores[3] # sacar los colores en 3 caracteres

grupo <- names(table(df[, variable]))
n <- as.vector(table(df[, variable]))
prop <- as.vector(table(df[, variable]))/length(df[, variable])

count.data <- data.frame(
  grupo = names(table(df[, variable])),
  n = as.vector(table(df[, variable])),
  prop = round(n/length(df[, variable])*100, 3)
)

count.data <- count.data %>%
  arrange(desc(grupo)) %>%
  mutate(lab.ypos = cumsum(prop) - 0.5*prop)

g1 <- ggplot(count.data, aes(x = grupo, y=n ) ) +
  geom_bar(stat="identity", width= 1, fill= c1 , 
           color = c2, alpha=2.5) +
  geom_text(aes(label = n, y = n + 1), color = "black",
            position = position_dodge(width = 1)) +
  ggtitle(paste("Gráfico de barras para", variable)) +
  xlab(variable) + 
  ylab(paste("Número de casos por", variable))+
  theme(panel.background = element_rect(fill = c3, 
                                        colour = c3, size = 2, linetype = "solid"))


g2 <- ggplot(count.data, aes(x = "", y = prop)) +
  geom_bar(width = 1, stat = "identity", fill= c1, 
           color = c2, alpha=2.5) +
  coord_polar("y", start = 0)+
  geom_text(aes(y = lab.ypos, label = prop), color = "white")+
  ggtitle(paste("Gráfico de torta (%) para", variable)) +
  theme(panel.background = element_rect(fill = c3, 
                                        colour = c3, size = 2, linetype = "solid"))

g2

ggarrange(g1, g2, 
           labels = c("A", "B"),
           ncol = 2, nrow = 1)

```

## Referencias

- The Grammar of Graphics. Leland Wilkinson. [Libro](https://link.springer.com/book/10.1007/0-387-28695-0)
- Documentación oficial de la libreria `ggplot2`: [ggplot2](https://ggplot2.tidyverse.org/)
  
- ggplot2: Elegant Graphics for Data Analysis (3e) [ggplot2-book.org](https://ggplot2-book.org/)
  
- Introduction to Scientific Programming and Simulation Using R [Libro pdf](https://nyu-cdsc.github.io/learningr/assets/simulation.pdf)
- Ejemplo de tutorial de `ggplot2` en youtube [Video](https://www.youtube.com/watch?v=0wpLOsqwhWs&list=PLN3jIazaJLCOWery5d_kCp5G5NUxu5wcd)


  
