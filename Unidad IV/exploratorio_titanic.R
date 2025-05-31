# --- Carga de Librerías ---
library(tidyverse) # Incluye dplyr y ggplot2
library(titanic)   # Para el dataset titanic_train

# --- 1. Preparación de Datos (similar a lo que ya hemos hecho) ---

# Limpiamos y preparamos los datos base titanic_train
datos_titanic_base <- titanic_train %>%
  as_tibble() %>% # Convertir a tibble
  # Opcional: drop_na(Age, Embarked) # Si quieres trabajar solo con filas completas, como en los modelos
  mutate(
    Superviviente = factor(Survived, levels = c(0, 1), labels = c("No", "Si"))
    # No necesitamos las otras variables por ahora, solo Superviviente
  ) %>%
  select(Superviviente) # Solo necesitamos esta columna para el conteo

# --- 2. Cálculo de Porcentajes ---

conteo_y_porcentajes <- datos_titanic_base %>%
  group_by(Superviviente) %>%        # Agrupar por la variable Superviviente
  summarise(Conteo = n()) %>%        # Contar el número de filas en cada grupo
  ungroup() %>%                      # Desagrupar para cálculos posteriores
  mutate(
    Porcentaje = Conteo / sum(Conteo), # Calcular el porcentaje
    Etiqueta_Porcentaje = scales::percent(Porcentaje) # Formatear como porcentaje para etiquetas
  )

print("--- Conteo y Porcentajes de Supervivencia ---")
print(conteo_y_porcentajes)

# --- 3. Gráficos ---

# --- Gráfico de Barras de Porcentajes (La que pediste) ---
# Muestra la proporción de sobrevivientes y no sobrevivientes
grafico_porcentaje <- conteo_y_porcentajes %>%
  ggplot(aes(x = Superviviente, y = Porcentaje, fill = Superviviente)) +
  geom_col() +
  geom_text(aes(label = Etiqueta_Porcentaje), vjust = -0.5, size = 4) + # Añadir etiquetas de porcentaje
  labs(
    title = "Porcentaje de Pasajeros Sobrevivientes vs. No Sobrevivientes",
    x = "Estado de Supervivencia",
    y = "Porcentaje de Pasajeros",
    fill = "Superviviente"
  ) +
  scale_y_continuous(labels = scales::percent) + # Formatear el eje Y como porcentajes
  scale_fill_manual(values = c("No" = "lightcoral", "Si" = "mediumseagreen")) +
  theme_minimal() +
  theme(legend.position = "none")

print(grafico_porcentaje)
