

# Function to determine optimal j_1 based on normalized energy contribution
select_j1_energy <- function(wavelet_object, energy_threshold = 0.95) {
  nlevels <- nlevelsWT(wavelet_object)
  total_energy <- sum(sapply(0:(nlevels-1), function(j) sum(accessD(wavelet_object, j)^2)))
  cumulative_energy <- 0
  
  for (j in 0:(nlevels-1)) {
    level_energy <- sum(accessD(wavelet_object, j)^2) / total_energy
    cumulative_energy <- cumulative_energy + level_energy
    
    if (cumulative_energy >= energy_threshold) {
      return(j)
    }
  }
  
  return(nlevels - 1)  # Fallback to the maximum level if threshold is not met
}

# Empirical wavelet transformations
vecd <- function(signal=NULL, 
                 filtro= NULL, 
                 waveletn= NULL, 
                 j1= NULL){
  
signal <- as.numeric( unlist(signal) ) # the signal enter as a list
decom <- wd(signal, filter.number= filtro, family= waveletn )
dj <- vector("list", j1 ) 
for ( j in  0:(j1-1) ) { dj[[j+1]] <-  accessD(decom, level=j) }
vec <- unlist(dj)
return(vec)

}

### Wavelet based curve estimation with thresholding 
mweth <- function( signal = NULL, 
                   filtro = NULL, 
                   waveletn = NULL,
                   j0=NULL,
                   j1= NULL){
  
  signal <- as.numeric( unlist(signal) ) # the signal enter as a list
  decom <- wd(signal, filter.number= filtro, family= waveletn )
  # j=1, ..., J
  decom <- nullevels(decom, (j1-1):(nlevelsWT(decom)-1) ) # Shrinkage
  decom.th <- threshold(decom, levels = (j0-1):(j1-2), 
                        type = "soft", 
                        policy = "sure", 
                        by.level= TRUE) # thresholding
  hatf <- wr(decom.th, 
             start.level = j1-1 ) # start.level com ruido
  
  return(hatf)
}

### Wavelet based curve estimation with thresholding 
mweth <- function( signal = NULL, 
                   filtro = NULL, 
                   waveletn = NULL,
                   j0=NULL,
                   j1= NULL){
  
  # Parte 0: Preparación de la señal y verificación (opcional, buena práctica)
  n <- length(signal)
  if (!log2(n) %% 1 == 0) {
    warning("La longitud de la señal no es una potencia de 2,
              la función puede no funcionar correctamente.")
  }
  
  signal_numeric <- as.numeric( unlist(signal) ) # la señal entra como una lista
  
  # Parte I: descomposicicón de la curva con ruido
  decom <- wd(signal_numeric, filter.number= filtro, family= waveletn )
  
  # Parte 2: "denoising" o "alisamiento de la curva" 
  decom_nulled <- nullevels(decom, (j1-1):(nlevelsWT(decom)-1) ) # Shrinkage
  decom_thresholded <- threshold(decom_nulled, levels = (j0-1):(j1-2), 
                                 type = "soft", 
                                 policy = "sure", 
                                 by.level= TRUE) # thresholding
  
  # Parte 3: reconstrucción de la curva \hat{f}(t)
  hatf <- wr(decom_thresholded, start.level = j1-1 ) # start.level com ruido
  
  # Parte 4: Obtener características del procesamiento
  procesamiento_caracteristicas <- list(
    filtro_usado = filtro,
    wavelet_usada = waveletn,
    nivel_j0 = j0,
    nivel_j1 = j1
  )
  
  # Parte 5: Crear la lista de resultados
  result <- list(
    curva_estimada = hatf,
    resumen_curva = summary(hatf), # Resumen de la curva estimada
    caracteristicas_procesamiento = procesamiento_caracteristicas # Características del procesamiento
  )
  
  class(result) <- "mweth_output" 
  
  return(result)
}

### Método de Impresión para la Clase S3 "mweth_output"
print.mweth_output <- function(x, ...) {
  cat("Estimación de Curva Basada en Ondeletas (mweth) - Resumen de Resultados\n")
  cat("========================================================================\n\n")
  
  cat("1. Curva Estimada (hatf):\n")
  print(summary(x$curva_estimada))
  cat("\n")
  
  cat("2. Características del Procesamiento Wavelets y Filtro:\n")
  cat("   - Filtro usado: ", x$caracteristicas_procesamiento$filtro_usado, "\n")
  cat("   - Wavelet usada: ", x$caracteristicas_procesamiento$wavelet_usada, "\n")
  cat("   - Nivel de inicio (j0): ", x$caracteristicas_procesamiento$nivel_j0, "\n")
  cat("   - Nivel de fin (j1): ", x$caracteristicas_procesamiento$nivel_j1, "\n\n")
  
  cat("3. Resumen Completo de la Curva Estimada:\n")
  print(x$resumen_curva)
  cat("\n")
}