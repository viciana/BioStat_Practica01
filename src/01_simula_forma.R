# ---------------------------------------------------------------------
# 01_simula_forma.R
# Simula el data.set "forma" para la práctica de medidas de forma
# (asimetría y curtosis).  Genera:
#     datos/forma.omv   (para abrir directamente en jamovi)
#     datos/forma.csv   (copia en texto plano)
#
# Todas las variables están en una escala común (media ~ 50, DE ~ 10)
# para que las diferencias entre ellas sean SOLO de forma.
#
# Para que los resultados en clase sean "limpios", cada variable se
# re-simula (cambiando la semilla) hasta que sus coeficientes muestrales
# de asimetría (G1) y curtosis (G2) caen cerca del valor buscado.
# G1 y G2 se calculan como en jamovi/SPSS (e1071, type = 2).
#
# Ejecutar desde el directorio S1:   Rscript src/01_simula_forma.R
# ---------------------------------------------------------------------
library(e1071)
library(jmvReadWrite)

n   <- 200        # tamaño muestral
mu  <- 50         # media común
de  <- 10         # desviación estándar común
tol <- c(G1 = 0.05, G2 = 0.10)   # tolerancia respecto al objetivo

## Estandariza teóricamente (con la media y DE de la población) -------
## (no con la muestral: así la muestra conserva su variabilidad natural)
escala <- function(x, m, s) mu + de * (x - m) / s

## Muestreo estratificado ---------------------------------------------
## En lugar de u ~ U(0,1) independientes, tomamos un u en cada uno de los
## n intervalos [(i-1)/n, i/n) y aplicamos la función cuantil de la
## población: x = F^-1(u).  Sigue siendo una muestra aleatoria (se
## barajan al final), pero el histograma se parece mucho más a la forma
## teórica: con n = 200 el muestreo puro añade demasiado "ruido".
u_estrat <- function(n) sample(((1:n) - runif(n)) / n)

## Modelos de población ------------------------------------------------
##   gen : función que devuelve n valores
##   G1, G2 : valores objetivo de asimetría y exceso de curtosis
k_gamma <- 2                      # gamma(2): asimetría 2/sqrt(2) = 1.41
a_beta  <- 1.5                    # beta(1.5,1.5): curtosis -6/(2a+3) = -1
q_laplace <- function(u) ifelse(u < 0.5, log(2 * u), -log(2 * (1 - u)))
modelos <- list(
  V1 = list(desc = "Simétrica (normal)",
            gen  = function() escala(qnorm(u_estrat(n)), 0, 1),
            G1 = 0, G2 = 0),
  V2 = list(desc = "Asimetría positiva (gamma, cola a la derecha)",
            gen  = function() escala(qgamma(u_estrat(n), k_gamma),
                                     k_gamma, sqrt(k_gamma)),
            G1 = 1.41, G2 = 3),
  V3 = list(desc = "Asimetría negativa (gamma reflejada, cola a la izquierda)",
            gen  = function() escala(-qgamma(u_estrat(n), k_gamma),
                                     -k_gamma, sqrt(k_gamma)),
            G1 = -1.41, G2 = 3),
  V4 = list(desc = "Leptocúrtica (Laplace: pico alto y colas pesadas)",
            gen  = function() escala(q_laplace(u_estrat(n)), 0, sqrt(2)),
            G1 = 0, G2 = 3),
  V5 = list(desc = "Mesocúrtica (normal)",
            gen  = function() escala(qnorm(u_estrat(n)), 0, 1),
            G1 = 0, G2 = 0),
  V6 = list(desc = "Platicúrtica (beta 1.5-1.5: aplanada, colas cortas)",
            gen  = function() escala(qbeta(u_estrat(n), a_beta, a_beta), 0.5,
                                     sqrt(1 / (4 * (2 * a_beta + 1)))),
            G1 = 0, G2 = -1),
  V7 = list(desc = "Bimodal (mezcla de dos normales)",
            gen  = function() {       # mitad de cada componente
              x <- c(qnorm(u_estrat(n / 2), -1.25, 0.55),
                     qnorm(u_estrat(n / 2),  1.25, 0.55))
              escala(sample(x), 0, sqrt(1.25^2 + 0.55^2))
            },
            G1 = 0, G2 = -1.4),
  V8 = list(desc = "Uniforme (plana, sin moda)",
            gen  = function() escala(u_estrat(n), 0.5, sqrt(1 / 12)),
            G1 = 0, G2 = -1.2)
)

## Simulación con búsqueda de semilla ---------------------------------
simula <- function(m, semilla0) {
  for (s in semilla0 + 0:5000) {
    set.seed(s)
    x <- round(m$gen(), 1)
    if (abs(skewness(x, type = 2) - m$G1) < tol["G1"] &&
        abs(kurtosis(x, type = 2) - m$G2) < tol["G2"])
      return(structure(x, semilla = s))
  }
  stop("No se encontró semilla adecuada")
}

forma <- data.frame(ID = seq_len(n))
for (i in seq_along(modelos)) {
  v <- names(modelos)[i]
  x <- simula(modelos[[v]], semilla0 = 1000 * i)
  cat(sprintf("%s  semilla=%5d  media=%5.1f  DE=%5.2f  G1=%6.2f  G2=%6.2f\n",
              v, attr(x, "semilla"), mean(x), sd(x),
              skewness(x, type = 2), kurtosis(x, type = 2)))
  forma[[v]] <- as.numeric(x)
}

## Salida --------------------------------------------------------------
dir.create("datos", showWarnings = FALSE)
write.csv(forma, "datos/forma.csv", row.names = FALSE)

# Meta-información para jamovi: descripción de cada variable
attr(forma$ID, "jmv-id")   <- TRUE
attr(forma$ID, "jmv-desc") <- "Identificador del individuo"
for (v in names(modelos)) attr(forma[[v]], "jmv-desc") <- modelos[[v]]$desc
write_omv(forma, "datos/forma.omv", frcWrt = TRUE)

# Guardamos también las descripciones para los gráficos
saveRDS(lapply(modelos, `[[`, "desc"), "src/descripciones.rds")
