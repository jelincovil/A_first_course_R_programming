

![](https://laddem.github.io/courses/tidyverse/featured_hubbdc597b3758119e4235f53c47f8ef56_339557_1200x1200_fit_lanczos_2.png){width="350"}

### SESIÓN 1: Uso del paquete `tidyverse` en programación con R.

Link de la clase del dia martes 27-05-2025 [Link](https://udla.zoom.us/rec/share/AR4LT4tafYYp6MLOwDSTAnIyY-hyTVno5WTDtQ9bzU6-fIPvqayV6zKDfaHqq8dQ.R15DEICjtNJgeluV?startTime=1748387250000&pwd=GY1VFF86RPuGYzXDmpfLsJFULGvIi9Lj)

# El manifiesto **Tidyverse**

El Manifiesto Tidyverse establece una serie de principios de diseño para lograr consistencia y coherencia en la interfaz de los paquetes del `tidyverse`, buscando que estos funcionen armónicamente. Es importante notar que se trata de un ideal aspiracional, y ningún paquete cumple actualmente con todos estos objetivos. Además, el manifiesto clarifica que los paquetes fuera del `tidyverse` no son inferiores, simplemente siguen enfoques de diseño distintos [Link](https://cran.r-project.org/web/packages/tidyverse/vignettes/manifesto.html).

Los principios fundamentales de un paquete "tidy" son los siguientes:

-   **Reutilizar las estructuras de datos existentes:** Se favorece el uso de estructuras de datos familiares como los `data frames` (particularmente los `tibbles`) para conjuntos de datos rectangulares, y los tipos de vectores base de R cuando sea posible.
-   **Componer funciones simples con el operador pipe (`%>%`):** Se promueve la combinación de funciones sencillas y fáciles de entender mediante el operador pipe. Las funciones deben ser lo más simples posible, realizar una única tarea de manera eficiente, evitar mezclar efectos secundarios con transformaciones y tener nombres basados en verbos para mayor claridad.
-   **Adoptar la Programación Funcional (PF):** El manifiesto alienta el uso de objetos inmutables, funciones genéricas provistas por S3 y S4, y herramientas que eviten los bucles `for` y `while` entre otros.
-   **Diseñar para humanos:** *Se prioriza la facilidad de uso para los programadores por encima de la eficiencia computacional de la máquina*. Esto se logra mediante nombres de funciones evocadores y explícitos, así como el uso de prefijos comunes para las familias de funciones, facilitando la autocompletado y la comprensión.

```{r}
# Activamos el paquete
library(tidyverse)

```

```{r}
# Vemos el manifiesto en el IV cuadrante

vignette("manifesto", package = "tidyverse")
```

### Bloque de Inicialización de Librerías

Activamos los paquetes, en caso de no estarlo.

```{r}
library(tibble)
library(dplyr)
library(readr)
library(stringr)
library(purrr)
```

Aseguir revisamos los principales paquetes integrados en el ecosistema `tidyverse`.

### `tibble`: La Base Inmutable de Datos

El paquete `tibble` se presenta como una evolución de los `data.frame` de R base, diseñado para ser más predecible y compatible con la filosofía de la programación funcional. Su característica más importante radica en su comportamiento **inmutable** en las operaciones del `tidyverse`. `tibble` actúa como la estructura de datos fundamental que esperan y devuelven las demás funciones del `tidyverse`, asegurando la consistencia en el flujo de trabajo.

Un ejemplo relevante para ilustrar su utilidad consiste en crear un `tibble` y demostrar cómo las transformaciones lo manipulan sin alterar su estado original.

```{r}
productos <- tibble(
  id = 1:3,
  nombre = c("Manzana", "Pera", "Uva"),
  precio = c(1.0, 1.2, 2.5)
)
productos # Tibble original de productos (inmutable)

# Aplicamos una transformación para calcular el precio con IVA.
# mutate() es una función pura: para los mismos datos de entrada y la misma regla,
# siempre dará el mismo resultado. Además, no modifica 'productos'.

productos_con_iva = productos %>% # operador pipe
                    mutate(precio_iva = precio * 1.19)

productos_con_iva # Nuevo tibble con 'precio_iva' (resultado de una función pura)

```

```{r}
# Verificamos que el tibble original 'productos' NO ha cambiado.
# Esto demuestra el principio de INMUTABILIDAD.
productos # El tibble original 'productos' permanece INALTERADO

```

`tibble` se comporta como un bloque de construcción inmutable. Cuando se aplica una operación como `mutate()`, no se modifica el `tibble` original; en su lugar, se crea uno completamente nuevo con las transformaciones deseadas. Esta característica es fundamental para la predictibilidad y para evitar efectos secundarios no deseados en el código.

### `readr`: Lectura Pura y Predecible

El paquete `readr` es el componente del `tidyverse` dedicado a la importación de datos. Sus funciones se caracterizan por ser **puras**, lo que significa que, para una misma ruta de archivo y las mismas opciones de configuración, siempre generarán el mismo `tibble` resultante sin sorpresas. `readr` complementa el ecosistema al proporcionar los `tibbles` iniciales (inmutables) con los que luego trabajarán `dplyr`, `stringr` y `purrr`.

Para ilustrar su utilidad, se presentará un ejemplo de cómo leer un archivo CSV de manera explícita, asegurando una carga de datos consistente y predecible.

```{r}
# Preparamos una cadena de texto que simula el contenido de un archivo CSV simple.
csv_simple <- "id,nombre,valor
1,ItemA,100
2,ItemB,150
3,ItemC,200"

# Creamos un archivo temporal para simular la lectura de un archivo real.
temp_csv_file <- tempfile(fileext = ".csv")
write_file(csv_simple, temp_csv_file)

# read_csv() es una función PURA: dado el mismo archivo, siempre
# devolverá el mismo tibble. No tiene efectos secundarios.
datos_cargados <- read_csv(
  temp_csv_file,
  col_types = cols( # Explicitamos los tipos de columna para mayor predictibilidad
    id = col_integer(),
    nombre = col_character(),
    valor = col_integer()
  )
)
datos_cargados # Datos cargados con read_csv() 

class(datos_cargados) # Verificando la clase del objeto cargado (siempre un tibble por defecto en readr)

# Eliminamos el archivo temporal.
unlink(temp_csv_file)

# Al especificar col_types, la lectura es determinista.
# Si se leyera el mismo archivo con los mismos argumentos múltiples veces,
# el 'tibble' resultante sería idéntico, sin variaciones por inferencia automática.
```

`readr` otorga la garantía de que los datos se cargarán siempre de la misma manera. Se lo puede concebir como una "máquina de hacer `tibbles`" que produce consistentemente el mismo resultado dados los mismos insumos, lo que previene errores sutiles derivados de la inferencia automática de tipos de datos.

``` r
# Bloque de demostración: Ejemplos de funciones menos "puras" o predecibles

# --- Demostración de read.csv() (R base) ---
# Problema: Comportamiento inconsistente de la salida (tipo de objeto)
# read.csv() no siempre devuelve un data.frame. Si lee una sola columna, puede devolver un vector.
# Esto rompe la predictibilidad y la facilidad de composición en pipes.

# Simular un CSV con una sola columna
writeLines("columna_unica\n10\n20\n30", "single_column.csv")

# Comportamiento cuando read.csv lee una sola columna
datos_columna_unica_base <- read.csv("single_column.csv")
cat("Clase de la salida de read.csv (una columna): ")
print(class(datos_columna_unica_base)) # Puede ser "data.frame"
cat("Clase de la columna accedida: ")
print(class(datos_columna_unica_base$columna_unica)) # Generalmente "numeric" (un vector)
print(datos_columna_unica_base)
cat("\n")

# Comparación con readr::read_csv() para consistencia
# (Se asume que library(readr) ya fue llamado en un bloque inicial)
datos_columna_unica_readr <- readr::read_csv("single_column.csv", show_col_types = FALSE)
cat("Clase de la salida de readr::read_csv() (una columna): ")
print(class(datos_columna_unica_readr)) # Siempre "tbl_df", "tbl", "data.frame" (un tibble)
print(datos_columna_unica_readr)
cat("\n")

# Limpiar archivo temporal
unlink("single_column.csv")


# Problema: Inferencia automática de 'stringsAsFactors' (histórico, pre-R 4.0)
# Antes de R 4.0, read.csv convertía cadenas a factores por defecto,
# un efecto secundario en la interpretación del tipo de dato.
writeLines("id,nombre,tipo\n1,Manzana,Fruta\n2,Pera,Fruta\n3,Leche,Lacteo", "data_factors.csv")

cat("--- Demostración de stringsAsFactors en read.csv() (histórico/forzado) ---\n")
datos_con_factores <- read.csv("data_factors.csv", stringsAsFactors = TRUE)
cat("Clase de la columna 'tipo' con stringsAsFactors = TRUE: ")
print(class(datos_con_factores$tipo)) # Muestra "factor"
print(datos_con_factores)
cat("\n")

# Limpiar archivo temporal
unlink("data_factors.csv")

# --- Demostración de funciones con efectos secundarios globales ---
# Problema: Modifican el estado global del entorno de R, afectando la predictibilidad
# de otras operaciones y la reproducibilidad del script.

cat("--- Demostración de setwd() (efecto secundario global) ---\n")
# Guardamos el directorio de trabajo actual para poder restaurarlo después
original_wd <- getwd()
cat("Directorio de trabajo original: ", original_wd, "\n")

# Este es un efecto secundario: modifica el entorno global
setwd(tempdir()) # Cambia el directorio de trabajo a uno temporal
cat("Nuevo directorio de trabajo (efecto secundario): ", getwd(), "\n")

# Cualquier operación posterior que use rutas relativas se verá afectada.
# Por ejemplo, si intentaras leer un archivo que estaba en el WD original, fallaría.
# tryCatch(read.csv("archivo_que_no_existe_en_temp.csv"), error = function(e) message("Error: Archivo no encontrado debido a setwd()"))
```

### `dplyr`: La Maquinaria de Transformación Funcional

`dplyr` se presenta como el núcleo del `tidyverse` para la manipulación de datos. Sus funciones (`filter()`, `mutate()`, `group_by()`, `summarise()`, `select()`, etc.) son inherentemente **puras** y están diseñadas para la **composición** fluida mediante el operador pipe (`%>%`), siempre respetando la **inmutabilidad** de los datos. `dplyr` complementa a los otros paquetes al tomar los `tibbles` iniciales de `readr` y transformarlos en nuevos `tibbles` de forma legible y segura, listos para ser utilizados por `stringr` o procesados por `purrr`.

Un ejemplo de utilidad relevante se centrará en el cálculo de totales simples por categoría, mostrando múltiples pasos de composición.

```{r}
transacciones <- tibble(
  categoria = c("A", "B", "A", "C", "B"),
  monto = c(100, 50, 120, 200, 75)
)
transacciones # Datos de transacciones originales

```

```{r}

# Cada paso devuelve un NUEVO tibble, manteniendo la INMUTABILIDAD
resumen_transacciones <- transacciones %>%
  # Paso 1: Agrupar por categoría
  # group_by() es PURA: define grupos lógicos, no modifica los datos en sí.
  group_by(categoria) %>%
  # Paso 2: Sumar el monto total por cada categoría
  # summarise() es PURA: reduce cada grupo a una fila de resumen, sin efectos secundarios.
  summarise(total_monto = sum(monto)) %>%
  # Paso 3: Filtrar categorías con un monto total superior a 100
  # filter() es PURA: selecciona filas según una condición, sin efectos secundarios.
  filter(total_monto > 100) %>%
  # Paso 4: Desagrupar el tibble para futuras operaciones
  # ungroup() es PURA: remueve la estructura de agrupación.
  ungroup()

resumen_transacciones # Resumen de transacciones procesado (nuevo tibble, original inalterado)

```

```{r}
transacciones # Verificando que los datos originales NO se han modificado
```

`dplyr` funciona como una "fábrica modular" donde cada "estación" (`group_by`, `summarise`, `filter`) recibe un producto (el `tibble`), realiza una operación pura y pasa el resultado a la siguiente estación. El resultado final es un nuevo producto sin haber alterado el original, lo que simplifica enormemente la construcción y comprensión de flujos de análisis complejos.

### `stringr`: Manipulación de Texto Pura y Consistente

`stringr` se presenta como una herramienta que simplifica la manipulación de cadenas de texto en R, ofreciendo funciones **puras** con una sintaxis notablemente consistente. Este paquete complementa el ecosistema al permitir la limpieza y estandarización de datos textuales dentro de los `tibbles` (comúnmente utilizando `dplyr::mutate`), ya sea antes o después de otras transformaciones.

Un ejemplo relevante para ilustrar su utilidad es la estandarización de nombres simples.

```{r}
usuarios <- tibble(
  id = 1:3,
  nombre_usuario = c("  ALICE  ", "bOb", " charlie ")
)
usuarios # Nombres de usuario originales

```

```{r}
# Limpieza y estandarización de nombres usando stringr dentro de dplyr::mutate
# str_trim, str_to_lower, str_to_title son funciones PURAS.
usuarios_limpios <- usuarios %>%
          mutate(
    nombre_limpio = str_trim(nombre_usuario),    # Elimina espacios al inicio/final
    nombre_estandar = str_to_title(str_to_lower(nombre_limpio)) # Pasa a minúsculas y luego a título
  )

usuarios_limpios # Nombres de usuario estandarizados (nuevo tibble, original inalterado)

# str_trim
# str_to_title
# str_to_lower

```

```{r}
usuarios # El tibble original 'usuarios' no ha cambiado (INMUTABILIDAD)
```

Cuando se trabaja con datos textuales, que a menudo son "sucios", `stringr` proporciona herramientas limpias y puras para su procesamiento. Cada función realiza su tarea específica sin afectar otros elementos, lo que facilita el encadenamiento de operaciones complejas de texto de manera predecible.

Tratamiento de acentos y otros caractere

```{r}
# Ejemplo simple con stringr para caracteres especiales

# Datos sucios con acentos y tildes/virgulillas
nombres_sucios <- c("José", "Mañana", "Niño~")

nombres_limpios <- nombres_sucios %>%
  str_to_lower() %>% # 1. Convertir a minúsculas para uniformidad
  str_replace_all("~", "") %>% # 2. Transliterar acentos a ASCII (aproximación)
  iconv(from = "UTF-8", to = "ASCII//TRANSLIT") # 3. Eliminar el carácter '~'

print(nombres_limpios)
```

### `purrr`: Iteración Funcional de Alto Nivel

`purrr` reemplaza los bucles (como for y while) explícitos con funciones que operan sobre colecciones de datos (listas y vectores) de manera funcional. Sus funciones de alto orden promueven la **composición** y la **pureza** en las iteraciones. `purrr` complementa el `tidyverse` al permitir aplicar secuencias de transformaciones a múltiples `tibbles` (o cualquier otro objeto) de forma consistente y reproducible.

#### Composición de Operaciones con el Operador Pipe (`%>%`) en `purrr`

El operador pipe (`%>%`) es fundamental en `purrr` para componer una secuencia de operaciones sobre colecciones de datos de forma legible y encadenada. En ciencia de datos, esto es común para flujos de limpieza y transformación paso a paso.

```{r}
# Un vector de datos de calidad de aire con posibles entradas inconsistentes
datos_calidad_aire_crudos <- c("25.5", "18.2", "40.1*", "15.0", "30.7?")

# Aplicamos una serie de transformaciones encadenadas para limpiar y convertir los datos
datos_calidad_aire_limpios <- datos_calidad_aire_crudos %>%
  str_replace_all("[^0-9.]", "") %>% # Eliminar caracteres no numéricos
  as.numeric() %>%                   # Convertir a número
  map(~ .x * 1.05) %>%               # Ajustar por un factor de calibración del 5% 
  flatten_dbl()                      # Convertir la lista resultante en un vector numérico

datos_calidad_aire_limpios # Datos de calidad de aire después de la limpieza y ajuste
```

```{r}
datos_calidad_aire_crudos # Los datos crudos originales no han sido modificados

```

El operador pipe permite una **composición secuencial** clara de múltiples pasos. Cada función toma la salida del paso anterior, manteniendo la pureza e inmutabilidad. Esto facilita la lectura y el mantenimiento del código.

#### Iteración Pura con `map()`

La familia de funciones `map` en `purrr` es clave para realizar iteraciones funcionales. Permite aplicar una función a cada elemento de una lista o vector, devolviendo una nueva lista (o vector de tipo específico) sin modificar el original. Es especialmente útil para procesar conjuntos de datos o modelos de forma individual pero consistente.

```{r}

# Lista de data frames, simulando diferentes muestras de datos de pacientes

muestras_pacientes <- list(
  tibble(id = 1, estatura = 1.60, peso = 70),
  tibble(id = 2, estatura = 1.75, peso = 85),
  tibble(id = 3, estatura = 1.5, peso = 60)
)
muestras_pacientes # Muestras de pacientes originales

```

```{r}
# Definimos una función pura para calcular el IMC para un data frame de paciente
# Esta función es PURA: mismo resultado para misma entrada, sin efectos secundarios.
calcular_imc <- function(df_paciente) {
  df_paciente %>%
    mutate(imc = peso / estatura^2) # Simplificado, solo para demostración
}

# map() aplica 'calcular_imc' a cada data frame de 'muestras_pacientes'.
# El resultado es una NUEVA lista de data frames, manteniendo la INMUTABILIDAD.
muestras_pacientes_con_imc <- map(muestras_pacientes, calcular_imc)

muestras_pacientes_con_imc # Muestras de pacientes con IMC calculado (Iteración Funcional)

```

```{r}
muestras_pacientes # La lista original no ha sido modificada
```

`map()` permite componer una operación de procesamiento sobre múltiples elementos sin un bucle `for` explícito, resultando en un código más declarativo y menos propenso a errores. Esto es invaluable en ciencia de datos para procesamiento por lotes, aplicación de modelos a subconjuntos de datos o limpieza de listas de data frames. El resultado es un código más limpio y escalable.

### Complemento: Principios de Programación Funcional en Tidyverse

-   La **Programación Funcional** (PF) es un paradigma que construye programas mediante la composición de funciones puras e inmutables, tratando las funciones como valores para lograr código predecible y escalable.

En este apartado analizamos los principios de programación funcional (PF) —funciones puras, inmutabilidad y composición de funciones— en el contexto del paquete **tidyverse** de R, dirigido a un público de nivel magister. Cada principio se define, se ilustra con un ejemplo en tidyverse y se contrasta con un caso que lo viola. Se incluye una tabla comparativa para sintetizar las ideas.

### Funciones Puras

**Definición**: Una función pura produce el mismo resultado para los mismos argumentos y no genera efectos secundarios (e.g., modificar estados externos). Esto garantiza predictibilidad y facilidad de razonamiento.

**Ejemplo en Tidyverse**:

```{r}
library(tidyverse)
numeros <- list(1, 2, 3, 4)
map_dbl(numeros, ~ .x^2) # Resultado: [1, 4, 9, 16]
```

La función `~ .x^2` es pura, ya que siempre produce `.x^2` para cada entrada `.x` sin alterar el entorno.

**Contraejemplo**:

```{r}
contador <- 0
no_pura <- function(x) {
  contador <<- contador + 1
  x + contador
}
no_pura(5) # Resultado: 6 (primera vez)
no_pura(5) # Resultado: 7 (segunda vez)
```

La función `no_pura` viola la pureza al depender de y modificar `contador`, un estado externo.

### Inmutabilidad

**Definición**: La inmutabilidad implica no modificar datos originales, generando copias con los cambios aplicados. Esto evita perdida del dataset original y asegura consistencia en eluso de datos.

**Ejemplo en Tidyverse**:

```{r}
library(tidyverse)
datos <- tibble(x = c(1, 2, 3))
nuevo <- datos %>% mutate(x_doble = x * 2)
nuevo # x = c(1, 2, 3), x_doble = c(2, 4, 6)
datos # Original sin cambios
```

`mutate()` respeta la inmutabilidad al devolver un nuevo tibble sin alterar `datos`.

**Contraejemplo**:

```{r}
datos <- tibble(x = c(1, 2, 3))
datos$x[1] <- 10 # Modifica directamente
datos # x = c(10, 2, 3)
```

Modificar directamente `datos` viola la inmutabilidad al alterar el objeto original.

### Composición de Funciones

**Definición**: La composición de funciones encadena funciones pequeñas, donde la salida de una es la entrada de la siguiente, promoviendo un estilo declarativo y modular.

**Ejemplo en Tidyverse**:

```{r}
datos <- tibble(nombre = c("Ana", "Bob", "Cris"), edad = c(25, 30, 35))
result <- datos %>%
  filter(edad > 25) %>% # funcion "h"
  mutate(edad_doble = edad * 2) %>% # funcion "g"
  summarise(edad_promedio = mean(edad_doble)) # funcion "f"
result # edad_promedio = 65
```

El operador `%>%` compone `filter()`, `mutate()` y `summarise()` de forma clara e inmutable.

**Contraejemplo**:

```{r}

datos <- tibble(x = c(1, 2, 3))
resultado <- numeric()
for (i in 1:nrow(datos)) {
  if (datos$x[i] > 1) {
    resultado <- c(resultado, datos$x[i] * 2)
  }
}
resultado # c(4, 6)

```

El bucle imperativo gestiona el flujo manualmente, perdiendo la modularidad de la composición funcional.

### Tabla Comparativa

| Principio | Descripción | Ejemplo en Tidyverse | Contraejemplo |
|------------------|------------------|------------------|------------------|
| **Funciones Puras** | Mismo resultado para mismos argumentos, sin efectos secundarios. | `map_dbl(list(1, 2, 3, 4), ~ .x^2)` | `no_pura(5)` modifica `contador` |
| **Inmutabilidad** | No modificar datos originales; crear copias con cambios. | `datos %>% mutate(x_doble = x * 2)` | `datos$x[1] <- 10` modifica directamente |
| **Composición de Funciones** | Encadenar funciones, salida de una como entrada de otra. | `datos %>% filter(...) %>% mutate(...) %>% summarise(...)` | Bucle `for` para filtrar y transformar datos |

# El paquete **`tidymodels`**

<!-- Introducir el objetivo, curiosidades y funcion -->

## Modelos inferenciales: Un ANOVA de un factor

```{r}
library(tidymodels)
library(rlang)
data(mtcars)

# 1. Definir mtcars como un tibble
datos_mtcars_tidy = mtcars %>%
                     as_tibble() %>%
                     mutate(cyl= factor(cyl))
  

# 2. Voy a especificar el modelo ANOVA
espec_modelo = linear_reg() %>%
              set_engine("lm")    


# 3. Voy a "ajustar" (fit) o "entrenar" el modelo
# Darle una forma al modelo `espec_modelo` en base a mtcars
modelo_fit = espec_modelo %>%
            fit(mpg ~ cyl, data= datos_mtcars_tidy)


# 4. Extraer la informacion del modelo
resumen_tidy = modelo_fit %>%
               pluck("fit") %>%  # extrar el model lm de modelo_fit
               anova() %>%   # Usando lm ejecuto el test Ho vs H1
               tidy()

# Imprimir la informacion
print(resumen_tidy )
```

Concluir: Rechazo H0. Concluyo que al separar los autos por numero de cilindros, obtengo grupos diferentes en cuanto a su eficiencia en millas por galón.

Tarea: si quiero saber que pares son diferentes, son los test "comparacion par a par" es pairwise Comparisons of Means (Post-Hoc Tests).

```         
```

## Modelo de clasificador: variables significativas

```{r}
# --- Ejemplo 2: Modelo Logístico Lineal con tidymodels (usando Titanic) ---
library(titanic)
data("titanic_train")

# 1. Preparar los datos
datos_titanic = titanic_train %>%
                as_tibble() %>%
                select(Survived, Pclass, Sex, Age) %>%
                drop_na() %>%
        mutate( Survived= factor(Survived, levels = c(0,1), labels = c("No", "Si")),
                Pclass  = factor(Pclass),
                Sex = factor(Sex),
                Child = factor(ifelse(Age < 18, "Si", "No" ))
              ) %>%
         select(-Age)


# 2. Definir el modelo logisitico
modelo_logistico = logistic_reg() %>%
                   set_engine("glm") # glm: general linear model

# 3. Ajustar le modelo logistico
modelo_log_fit = modelo_logistico %>%
                fit(Survived ~ Pclass +Sex + Child, data = datos_titanic)

# 4. Ver los resultados
tabla_output = modelo_log_fit %>%
               tidy()

print(tabla_output)
```

-   Para verificar la fuerza del impacto de cada covariables por si sola, se estudian los odd o log-odds

------------------------------------------------------------------------

### SESIÓN 2: Modelos descriptivos y predictivos con `tidymodels`

Link de la clase del 31-05-2025 [Link](https://udla.zoom.us/rec/share/zUgXpqE6HcMZ_iItcVQY-7cenJc8gIRHJWYQ-3S0kYSWwZ-_rAP3IKTeRAMTvejv.ch0s9GMrb23vjwb3?startTime=1748888936000&pwd=_PnqblyVLSDnP2oXxE5xMRidzOwX_Ino)

## Entrenamiento de un modelo logistico para clasificación

```{r}
# --- Carga de Librerías Esenciales ---
library(tidyverse) 
library(titanic)  
library(yardstick) 
```

```{r}
# --- 1. Preparación de Datos ---

# Preparar y limpiar el dataset de Titanic
datos_titanic <- titanic_train %>% # Pipe
  as_tibble() %>%
  drop_na(Age, Embarked) %>%
  mutate(
    Superviviente = factor(Survived, levels = c(0, 1), labels = c("No", "Si")),
    Clase = factor(Pclass),
    Sexo = factor(Sex),
    PuertoEmbarque = factor(Embarked),
    Menor = factor(ifelse(Age < 18, "Si", "No")),
    Tarifa = Fare
  ) %>%
  select(Superviviente, Clase, Sexo, PuertoEmbarque, Menor, Tarifa)

```

```{r}
# --- 2. Ajuste del Modelo Logístico ---
modelo_logistico <- glm(
                    Superviviente ~ Clase + Sexo + PuertoEmbarque + Menor + Tarifa,
                        data = datos_titanic,
                        family = binomial) # Modelo logistico

# --- 3. Predicciones y Evaluación (sobre los mismos datos de ajuste) ---

# Realizar predicciones de probabilidad y clase
predicciones_y_reales <- datos_titanic %>%
  mutate(
    # Predicción de probabilidad para la clase "Si" (segundo nivel)
    .pred_Si = predict(modelo_logistico, newdata = ., type = "response"),
    # Calcular probabilidad para la clase "No" (útil para otras métricas o si se requiere explícitamente)
    .pred_No = 1 - .pred_Si,
    # Predicción de clase basada en umbral 0.5
    clase_predicha = factor(ifelse(.pred_Si > 0.5, "Si", "No"),
                            levels = c("No", "Si"))
  )

```

```{r}
predicciones_y_reales
```

```{r}

# Calcular la Matriz de Confusión
matriz_confusion <- yardstick::conf_mat(predicciones_y_reales, 
                                        estimate = clase_predicha,
                                         truth = Superviviente)
print("- Matriz de Confusión -")
print(matriz_confusion)

```

```{r}

# Calcular las Métricas de Error (Ej. Exactitud, AUC)
metricas_error <- predicciones_y_reales %>%
  yardstick::metrics(
    truth = Superviviente,
    estimate = clase_predicha, # Para accuracy
    .pred_Si                   
  )
print("- Métricas de Error -")
print(metricas_error)

```

```{r}
# --- 4. Visualización Final (con ggplot2) ---

# Gráfico de Curva ROC
curva_roc_plot <- predicciones_y_reales %>%
  yardstick::roc_curve(Superviviente, .pred_Si) %>% # Pasar solo la columna de probabilidad de la clase positiva
  autoplot() +
  labs(title = "Curva ROC - Modelo Logístico",
       x = "Tasa de Falsos Positivos (1 - Especificidad)",
       y = "Tasa de Verdaderos Positivos (Sensibilidad)") +
  theme_minimal()
```

```{r}

# Gráfico de Distribución de Probabilidades Predichas por Clase Real
distribucion_prob_plot <- predicciones_y_reales %>%
  ggplot(aes(x = .pred_Si, fill = Superviviente)) +
  geom_density(alpha = 0.6) +
  labs(
    title = "Distribución de Probabilidad Predicha por Clase Real",
    x = "Probabilidad Predicha de Supervivencia",
    y = "Densidad",
    fill = "Superviviente Real"
  ) +
  theme_minimal()

# Mostrar los gráficos
print(curva_roc_plot)
print(distribucion_prob_plot)

```

El entrenamiento de un Random Forest

```{r}
library(ranger)

# --- 2. Ajuste del Modelo Random Forest ---

# Ajustar un modelo Random Forest simple (sin tuning complejo)
# Se usan valores por defecto o elegidos para la demostración
modelo_random_forest <- ranger::ranger(
  Superviviente ~ ., # '.' significa todas las demás variables como predictores
  data = datos_titanic,
  num.trees = 500,     
  mtry = 3,         
  min.node.size = 5,   
  probability = TRUE, 
  seed = 456           
)

# --- 3. Predicciones y Evaluación (sobre los mismos datos de ajuste) ---

# Realizar predicciones de probabilidad y clase sobre los mismos datos de ajuste
predicciones_rf_y_reales <- datos_titanic %>%
  mutate(
    # Las predicciones de ranger vienen en un formato específico
    .pred_No = modelo_random_forest$predictions[, "No"],
    .pred_Si = modelo_random_forest$predictions[, "Si"],
    # Convertir probabilidades a clases (umbral 0.5)
    clase_predicha = factor(ifelse(.pred_Si > 0.5, "Si", "No"),
                           levels = c("No", "Si"))
  )

# Calcular la Matriz de Confusión
matriz_confusion_rf <- yardstick::conf_mat(predicciones_rf_y_reales,
                                         truth = Superviviente,
                                         estimate = clase_predicha)
print("- Matriz de Confusión (Random Forest) -")
print(matriz_confusion_rf)


```

```{r}
# Calcular las Métricas de Error (Exactitud, AUC)
metricas_error_rf <- predicciones_rf_y_reales %>%
  yardstick::metrics(
    truth = Superviviente,
    estimate = clase_predicha, # Para accuracy
    .pred_Si                   # Para roc_auc
  )
print("- Métricas de Error (Random Forest) -")
print(metricas_error_rf)

```

```{r}
# --- 4. Visualización Final (con ggplot2) ---

# Gráfico de Curva ROC
curva_roc_rf_plot <- predicciones_rf_y_reales %>%
  yardstick::roc_curve(Superviviente, .pred_Si) %>%
  autoplot() +
  labs(title = "ROC - Modelo Random Forest",
       x = "Tasa de Falsos Positivos (1 - Especificidad)",
       y = "Tasa de Verdaderos Positivos (Sensibilidad)") +
  theme_minimal()

# Gráfico de Distribución de Probabilidades Predichas por Clase Real
distribucion_prob_rf_plot <- predicciones_rf_y_reales %>%
  ggplot(aes(x = .pred_Si, fill = Superviviente)) +
  geom_density(alpha = 0.6) +
  labs(
    title = "Distribución de Probabilidad Predicha por Clase Real (Random Forest)",
    x = "Probabilidad Predicha de Supervivencia",
    y = "Densidad",
    fill = "Superviviente Real"
  ) +
  theme_minimal()

# Mostrar los gráficos
print(curva_roc_rf_plot)
print(distribucion_prob_rf_plot)

```

```{r}
library(patchwork)

curva_roc_plot + curva_roc_rf_plot
```

## ¿Como sabemos a calidad del entrenamiento de nuestro ML?

![](https://towardsdatascience.com/wp-content/uploads/2022/02/1SKn7aehckf2J8FVz9xnraQ-768x269.png){width="800"}

![](https://towardsdatascience.com/wp-content/uploads/2022/02/1SQe_g5Rs_VzaU5CUV_dzSA-768x179.png){width="800"}

## ¿Como lo puedo mejorar?

-   Para el modelo Logistico se puede usar el procedimiento de **regularización** y selección de variables.

-   Para el Randoforest, se puede seleciones los parametos extra via validación cruzada.

## Referencias

-   Mailund, T. (2017). Functional programming in R: Advanced statistical programming for data science, analysis and finance (1ª ed.). Apress.

-   Hastie, T., Tibshirani, R., and Friedman, J. (2009). The Elements of Statistical Learning: Data Mining, Inference, and Prediction (2nd ed.). Springer
