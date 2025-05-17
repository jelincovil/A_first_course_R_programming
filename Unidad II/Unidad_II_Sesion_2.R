library(tidyverse)
library(ggthemes)
library(ggrepel)
library(patchwork)
library(GGally)
library(FactoMineR)
library(factoextra)

# Cargar datos desde sklearn (preconvertido en R como data.frame)
# Supongamos que breast_cancer_df ya está cargado con columnas + una columna "diagnosis"
# Puedes usar reticulate::py_run_file() si deseas leerlo directo desde Python

# Carga de datos
df = read.csv("breast_cancer_data.csv")
head(df)


summary(df$mean.area) ## milimetros

---
El operador `%>%` permite encadenar funciones de forma clara, por ejemplo:

```r
mtcars %>% filter(mpg > 20) %>% summarise(media_hp = mean(hp))
```

> Filtra autos con más de 20 mpg y calcula el promedio de caballos de fuerza.

---

#Crear una nueva variable categórica basada en mean.area
df <- df %>%
  mutate(tamano_tumor = case_when(
    mean.area < 420.3 ~ "Pequeño",
    mean.area >= 420.3 & mean.area <= 782.7 ~ "Mediano",
    mean.area > 782.7 ~ "Grande"
  ))

# Verificar los primeros 6 registros
head(df %>% select(mean.area, tamano_tumor))



# 1. Gráfico de distribuciones por tipo de tumor
p1 <-     df %>%
  pivot_longer(cols = -tamano_tumor) %>%
  ggplot(aes(x = value, fill = tamano_tumor)) +
  geom_density(alpha = 0.5) +
  facet_wrap(~ name, scales = "free", ncol = 3) +
  labs(title = "Distribuciones por variable y tipo de tumor",
       x = "Valor", y = "Densidad") +
  theme_minimal()

p1

# 2. Boxplots para comparar grupos en una variable
p2 <-   df %>%
  ggplot(aes(x = tamano_tumor, y = mean.compactness, fill = tamano_tumor)) +
  geom_violin(trim = FALSE, alpha = 0.5) +
  geom_boxplot(width = 0.1, outlier.shape = NA) +
  labs(title = "Distribución de 'crim' según tipo de tumor",
       y = "mean.compactness", x = "Tipo de tumor") +
  theme_classic()

p2

# 3. PCA con visualización de clases
# Asumiendo que solo columnas numéricas están en cols 2:11
df_pca <- df %>% select(-tamano_tumor)
pca_result <- PCA(df_pca, graph = FALSE)

# Agregamos clase a resultados para graficar
pca_df <- data.frame(pca_result$ind$coord[, 1:2]) %>%
  mutate(diagnosis = df$tamano_tumor)

p3 <- ggplot(pca_df, aes(x = Dim.1, y = Dim.2, color = diagnosis)) +
  geom_point(alpha = 0.6) +
  labs(title = "PCA: Visualización de clases en 2D",
       x = "PC1", y = "PC2") +
  theme_minimal()

p3


# Cargar paquetes necesarios
library(tidyverse)
library(reshape2)  # Para convertir la matriz de correlación en formato largo

# Seleccionar solo variables numéricas
df_numeric <- df %>% select(where(is.numeric))

# Calcular la matriz de correlación
cor_matrix <- cor(df_numeric, use = "complete.obs")

# Convertir la matriz en formato largo para ggplot2
cor_data <- melt(cor_matrix)

# Crear el gráfico de calor
p4 <- ggplot(cor_data, aes(x = Var1, y = Var2, fill = value)) +
  geom_tile(color = "white") +
  scale_fill_gradient2(low = "red", high = "blue", mid = "white",
                       midpoint = 0, limit = c(-1, 1), space = "Lab",
                       name = "Correlación") +
  theme_minimal() +
  theme(axis.text.x = element_text(angle = 45, vjust = 1, hjust = 1)) +
  labs(title = "Mapa de calor de correlaciones",
       x = "", y = "")

p4
