#--------------------------------------------------
# Paquetes necesarios

library(car)
library(coin)
library(ARTool)
library(npmv)
library(vegan)
library(wavethresh)
library(rgl)
library(timetk) #paquetes para series temporales
library(Cairo)
library(ggplot2)
#------------------------------------------------
# Parte I: procesamiento de datos

## Lectura 
setwd("C:/Users/Acer/Desktop/Curso de R/R project Jaime 2025")
series <- read.csv("datos_lima_raw_mp2.5.csv", sep = ",")


## Seleccion de series com menos datos faltantes
series <- series[, -c(1,2,4,7, 10,11)]
str(series)

## Proceso de imputación de Nas
library(imputeTS)
#?imputeTS
for (j in 1:dim(series)[2]) {
series[, j] <-  na_interpolation(series[,j], option = "linear")  
}

## Agregamos la columna de indices 
series$Hora <- seq(1:10178) # seq(1:dim(series)[1])
# Extract outliers

for (j in 1:dim(series)[2]) {
  
  series[, j] <-  ts_clean_vec(series[,j], period = 1, lambda = NULL)
}

## Grafico de la serie de mp2.5 imputada y sin outliers 
plot.ts(series, main="Niveles de mp2.5 de diferentes estaciones de Lima")

## Proceso de espejeamiento de los datos
# para completar un serie de largo n*=2^N 
# (potencia de dos)

k= (2^14 - dim(series)[1])/2
k
## Los datos precisan k=3103 datos para completar una potencia de 2

## Espejeamiento de los datos

n1 = floor(3103/2)
n2 <- k- n1
print(c(n1,n2))
k == n1+n2


n1= 3103 ; n2 = 3103

HEAD <- rev( head( series, n = n1 ) )
TAIL <- rev( tail( series, n = n2 ) )

# Combine the data frames
library(dplyr)
sserie <- bind_rows(HEAD, series, TAIL)
dim(sserie)
plot.ts(sserie) 
dev.off()

#--------------------------------------------------------------

str(sserie)




data_long <- sserie %>%
  pivot_longer(cols = SMP:SBJ, names_to = "Variable", values_to = "Value")
ggplot(data_long, aes(x = Hora, y = Value, color = Variable)) +
  geom_line() +
  labs(#title = "Gráfico de Variables SMP, SJL, VMT, STA y SBJ",
       x = "Tiempo",
       y = "Valor",
       color = "Variable") +
  theme_minimal()
#CairoPNG("01.Comparación_curvas_limpias.png", width = 800, height = 600)

#--------------------------------------------------------
# Parte 2: Analisis exploratorio de los datos

#----------------------------------------------------------------
# Parte 3: Estimación de el promedio de las series mu(t)

str(sserie)
average <- rowMeans(sserie[,-c(1)])
dev.off()

plot(average, type = "l")

library(wavethresh)
decom <- wd(average, 
            filter.number= 7, 
            family= "DaubLeAsymm" )

plot(decom, main = "")
#CairoPNG("02.Descomposicion_wavelet.png", width = 800, height = 600)

nlevelsWT(decom)
# j=1, ..., J
j1 <- select_j1_energy(decom, energy_threshold = 0.45)  ; j0 <- 1  



decom.th <- nullevels(decom, (j1-1):(nlevelsWT(decom)-1) ) # Shrinkage
decom.th <- threshold(decom.th, levels = (j0-1):(j1-2), 
                      type = "soft", 
                      policy = "cv", 
                      by.level= FALSE) # thresholding

hatf_average <- wr(decom.th, 
                   start.level = j1-1 ) # start.level com ruido




#CairoPNG("03.Media_media.png", width = 800, height = 600)
plot(average, type="l", col = 2, 
     ylab="Promedio de mp2.5",
     xlab = "Tiempo")
lines(hatf_average, type = "l", col="blue", lwd=2)
legend("topright",                         # Posición de la leyenda
       legend = c("Observado", "Estimado"),  # Nombres de las líneas
       col = c(2, "blue"),                 # Colores correspondientes
       lty = 1,                            # Tipo de línea (1 = sólida)
       lwd = c(1, 2),
      cex=0.85)    


dev.off()


# Testing 1: H0: mu(t)=0 against mu(t) diff 0 for some l
# Estimation of the wavelets coefficients


#plot(hatf_average, type = "l", col="blue", lwd=2)


coefs1 <- vecd(signal = average, 
               filtro = 7,
               waveletn= "DaubLeAsymm",
               j1=14)

length(coefs1) ; length(average)

# Selecciono j 1 con maxima energia
j1 <- select_j1_energy(decom, energy_threshold = 0.95) 
plot(decom)


sum(2^{0:13})

lista <- list()
for (j in 0:(j1-1)) {
  lista[[j+1]] <- rep(j+1, 2^{j}) 
}

lista
jotas <- unlist(lista)
jotas
length(jotas)

datax <- data.frame(d=coefs1[1:length(jotas)]^2, j= jotas) #-------------------
#View(datax)

# Extraemos los coefs del primer, segundo y tercer nivel de resolución
datax <- datax[-c(1,2,3),]

boxplot(d~j, data=datax)

#-------------------------------------------------------------------------------

#CairoPNG("04.Resol_coef.png", width = 800, height = 600)
boxplot(d ~ j, data = datax,
        main = "Coeficientes de ondaletas de curva media por j",
        col = 2,       
        border = "black",         
        xlab = "Nivel de resolución j",     
        ylab = "Valores de coeficientes d" )
        
      #  main = "Boxplot de coeficientes por nivel de resolución")  
dev.off()

# test
library(psych)

# Step 1: Add an id column for reshaping
datax$id <- ave(datax$j, datax$j, FUN = seq_along)
# Step 2: Reshape the data from long to wide format using reshape()
reshaped_df <- reshape(datax, timevar = "j", idvar = "id", direction = "wide")
# Remove the 'id' column after reshaping (optional)
reshaped_df <- reshaped_df[, -1]
# Piar wise
cor_results <- corr.test(reshaped_df, method = "spearman")
print(cor_results$n)

#

bartlett <- bartlett.test(d ~ j, data = datax)
print(bartlett)
# Diferent variances by group


# Testing
kruskal.test(d~j, data=datax)

kruskal_test(d ~ factor(j), data = datax, 
             distribution = approximate(nresample = 10000))

# art_model <- art(d ~ factor(j), data = datax)
# anova_result <- anova(art_model)
# print(anova_result)

# Rechazo mu(t) = cte.
# Existe una media global mu(t) en L2

############################################################################
# Testing 2: H0: g_i=cte

dim(sserie)
str(sserie)
centrada <- sserie[c(-1)] - average
plot.ts(centrada)

#--------------------------------------------------------
ccentrada <- centrada
ccentrada$Hora <- seq_len(nrow(ccentrada))
str(ccentrada)

ddata_long <- ccentrada %>%
  pivot_longer(cols = SMP:SBJ, names_to = "Variable", values_to = "Value")

#CairoPNG("05.Datos_centrados.png", width = 800, height = 600)
ggplot(ddata_long, aes(x = Hora, y = Value, color = Variable)) +
  geom_line() +
  labs(#title = "Datos centrados de SMP, SJL, VMT, STA y SBJ",
       x = "Tiempo",
       y = "Valor de MP2.5",
       color = "Estación:") +
  theme_minimal()
dev.off()
#--------------------------------------------------------


coefs2 <- apply( centrada, 2, function(x) vecd(signal = x, 
                                                filtro = 5,
                                                waveletn= "DaubExPhase",
                                                j1= 14))
dim(centrada) ; dim(coefs2)
str(centrada)

# Estimación de el efecto por curva g_i(t) for i=1,2,3,4,5.

j1 <- select_j1_energy(decom, energy_threshold = 0.4) 

hat_curves <- apply( centrada, 2,
                      function(x) mweth( signal = x, 
                                         filtro = 5,
                                         waveletn= "DaubLeAsymm",
                                         j0=1,
                                         j1=j1) )


str(hat_curves)
curve_names <- c("SMP", "SJL", "VMT", "STA", "SBJ")


plot.ts(hat_curves)

#----------------------------------------------------------------
if (is.list(hat_curves)) {
  hhat_curves <- do.call(cbind, hat_curves)
}


curve_names <- c("SMP", "SJL", "VMT", "STA", "SBJ")

# Ajusta los márgenes para hacer espacio a la derecha
par(mar = c(5, 4, 4, 8), xpd = TRUE)

# Dibuja las curvas con líneas gruesas
matplot(hat_curves, type = 'l',
        col = 1:ncol(hat_curves), lty = 1, lwd = 2,
        xlab = 'Tiempo', ylab = 'Valor')

# Coloca la leyenda fuera del área de dibujo, a la derecha
legend("topright", inset = c(-0.25, 0),      # posición fuera del margen
       legend = curve_names,
       col = 1:ncol(hat_curves),
       lty = 1, lwd = 2, cex = 0.9, bty = "n")  # bty = "n" quita el borde

dev.off()


#---------------------------------------------------------


# Test

lista <- list()
for (j in 0:13) {
  lista[[j+1]] <- rep(j+1, 2^{j}) 
}

jotass <- unlist(lista)
jotass
length(jotass)
2^{0:7}

dataxx <- cbind(coefs2^2, jotass)
#dataxx <- dataxx[-c(1,2,3),]
dataxx <- dataxx[-c(1,2,3),]
dataxx <- as.data.frame(dataxx)

library(tidyverse)

# Prepara los datos
colnames(dataxx) <- c("SMP", "SJL", "VMT", "STA", "SBJ", "jotass")

# Convierte a formato largo para ggplot2
data_long <- dataxx %>%
  pivot_longer(cols = c(SMP, SJL, VMT, STA, SBJ),
               names_to = "zona",
               values_to = "valor")

# Grafica en grid con ejes independientes
ggplot(data_long, aes(x = as.factor(jotass), y = valor)) +
  geom_boxplot(outlier.size = 0.8, width = 0.5) +
  facet_wrap(~ zona, scales = "free_y") +
  labs(x = "", y = "Coeficiente²", title = "Distribución de coeficientes por zona") +
  theme_minimal(base_size = 12) +
  theme(axis.text.x = element_text(angle = 45, hjust = 1))



#View(dataxx)

# Manova con datos no balanceados
manova_1 <- manova( cbind(dataxx$SMP, 
                           dataxx$SJL, 
                           dataxx$VMT,
                           dataxx$STA,
                           dataxx$SBJ)~jotass, 
                     data = dataxx)

summary(manova_1, tol=0)

# Manova no parametrico
# https://f-santos.gitlab.io/2020-05-07-npmanova.html
Y <- dataxx[, c("SMP","SJL","VMT","STA","SBJ")]

manova_2 <- adonis2(Y~ dataxx$jotass, method = "euclidean",
                    permutations = 100)

summary(manova_2, tol=0)


manova_2 <- nonpartest( SMP|SJL|VMT|STA|SBJ~jotass, 
                     data = dataxx, permreps=1000, plots=FALSE)

summary(manova_2, tol=0)

# Rechazo H0: gi(t)= cte.
# NO rechaco H1: g_i()
# Manova con datos balanceados
library(groupdata2)
balanced_data2 <- balance(dataxx, 30, cat_col = "jotass")

df_long <- reshape2::melt(balanced_data2, id.vars = "jotass")
ggplot(df_long, aes(x = jotass, y = value)) +
  geom_boxplot() + facet_wrap(~ variable, scales = "free")

#######################################################

manova_bal <- manova( cbind( balanced_data2$SMP, 
                             balanced_data2$SJL, 
                             balanced_data2$VMT,
                             balanced_data2$STA,
                             balanced_data2$SBJ)~jotass, 
                      data = balanced_data2)

summary(manova_bal, tol=0)

# Rechazo gi(t)=cte,  

##############################

