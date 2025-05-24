# ---------------------------------------------------------------------------
# Paso: definimos la funcion, argumentos y bloques

imputar_na_num <- function(data, metodo = "media") {
  # data: El dataframe de entrada.
  # metodo: "media" (por defecto) o "mediana" para la imputación.
 
  # 1. Validación de entradas
  
  # 2. Copia del dataframe para no modificar el original
  
  # 3. Imputación de NAs en columnas numéricas
  
  # 4. Preparar la salida con clase S3
  
  # 5. Asignamos una clase a la lista. Esto permite un 'print' personalizado.
}

# --------------------------------------------------------------------------
# Paso 1: Validación de entradas

if (!is.data.frame(data)) {
  stop("Error: 'data' debe ser un dataframe.")
}
if (!metodo %in% c("media", "mediana")) {
  stop("Error: 'metodo' debe ser 'media' o 'mediana'.")
}

# ----------------------------------------------------------------------------
# Paso 2: Copia del dataframe para no modificar el original

df_imputado <- data
columnas_imputadas <- character(0) # Para registrar qué columnas se modifican

# -------------------------------------------------------------------------------
# Paso 3: Imputación de NAs en columnas numéricas
for (col_name in names(df_imputado)) {
  columna <- df_imputado[[col_name]]
  
  if (is.numeric(columna) && any(is.na(columna))) {
    # Calcula el valor de imputación (media o mediana)
    valor_imputacion <- switch(metodo,
                               "media" = mean(columna, na.rm = TRUE),
                               "mediana" = median(columna, na.rm = TRUE))
    
    # Realiza la imputación
    df_imputado[is.na(df_imputado[[col_name]]), col_name] <- valor_imputacion
    columnas_imputadas <- c(columnas_imputadas, col_name)
  }
}

# -------------------------------------------------------------------------------
# Paso 4: Preparar la salida como lista
# La función devuelve una lista con el dataframe imputado y un resumen breve.
resultado <- list(
  data_imputed = df_imputado,
  method_used = metodo,
  columns_affected = columnas_imputadas
)

# --------------------------------------------------------------------------------
# Paso 5: Asignamos una clase a la lista. Esto permite un 'print' personalizado.
class(resultado) <- "imputacion_data"

return(resultado)


# ----------------------------------------------