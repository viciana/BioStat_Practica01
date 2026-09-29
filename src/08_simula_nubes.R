# ---------------------------------------------------------------------
# 08_simula_nubes.R
# Simula el data.set "nubes" para el bloque 3 (correlación y regresión).
# Genera:
#     datos/nubes.omv   (para abrir directamente en jamovi)
#     datos/nubes.csv   (copia en texto plano)
#
# Una variable X común (media ~ 50, DE ~ 10) y siete respuestas Y1..Y7
# con distintas formas de nube.  Así, en jamovi basta una matriz de
# correlaciones (X con Y1..Y7) y un gráfico de dispersión por pareja.
# Variables abstractas, sin contexto clínico (como en "forma").
#
# Como en 01_simula_forma.R, cada Y se re-simula (cambiando la semilla)
# hasta que sus índices muestrales caen cerca del valor buscado, para
# que los resultados en clase sean "limpios".
#
# Ejecutar desde el directorio S1:   Rscript src/08_simula_nubes.R
# ---------------------------------------------------------------------
suppressMessages(library(jmvReadWrite))

n  <- 200
mu <- 50
de <- 10

## X: muestreo estratificado de una normal (ver 01_simula_forma.R) -----
set.seed(3000)
zx <- qnorm(sample(((1:n) - runif(n)) / n))
X  <- round(mu + de * zx, 1)
z  <- (X - mu) / de                      # X en unidades de DE teóricas

lineal <- function(rho) function()       # Y = 50 + 10 (rho z + ruido)
  mu + de * (rho * z + sqrt(1 - rho^2) * rnorm(n))
r   <- function(y) cor(X, y)
rho <- function(y) cor(X, y, method = "spearman")
R2q <- function(y) summary(lm(y ~ X + I(X^2)))$r.squared

## Modelos: gen() devuelve Y; ok(y) comprueba que la muestra es "limpia"
modelos <- list(
  Y1 = list(desc = "Nube aleatoria (ruido): sin relación con X",
            gen = lineal(0),     ok = \(y) abs(r(y)) < 0.02),
  Y2 = list(desc = "Correlación positiva media con X",
            gen = lineal(0.6),   ok = \(y) abs(r(y) - 0.6) < 0.02),
  Y3 = list(desc = "Correlación negativa media con X",
            gen = lineal(-0.6),  ok = \(y) abs(r(y) + 0.6) < 0.02),
  Y4 = list(desc = "Correlación positiva fuerte con X",
            gen = lineal(0.9),   ok = \(y) abs(r(y) - 0.9) < 0.01),
  Y5 = list(desc = "Relación parabólica con X (U invertida): r casi nulo",
            gen = \() mu + de * (-sqrt(0.85 / 2) * (z^2 - 1) + sqrt(0.15) * rnorm(n)),
            ok  = \(y) abs(r(y)) < 0.02 && abs(R2q(y) - 0.85) < 0.02),
  Y6 = list(desc = "Relación exponencial con X (log(Y6) es lineal en X)",
            gen = \() exp(log(30) + 0.5 * (0.95 * z + sqrt(1 - 0.95^2) * rnorm(n))),
            ok  = \(y) abs(cor(X, log10(y)) - 0.95) < 0.01),
  Y7 = list(desc = "Nube aleatoria con 6 valores atípicos (3 en cada extremo de X)",
            gen = \() {                        # con 3 en un solo extremo, r ~ 0.17
              y <- lineal(0)()
              o <- order(X)
              y[tail(o, 3)] <- 100 + rnorm(3, 0, 3)     # 3 X más altas: Y muy alta
              y[head(o, 3)] <-   0 + rnorm(3, 0, 3)     # 3 X más bajas: Y muy baja
              y
            },
            ok  = \(y) abs(r(y) - 0.3) < 0.02 && abs(rho(y)) < 0.03))

simula <- function(m, semilla0) {
  for (s in semilla0 + 0:20000) {
    set.seed(s)
    y <- round(m$gen(), 1)
    if (m$ok(y)) return(structure(y, semilla = s))
  }
  stop("No se encontró semilla adecuada")
}

nubes <- data.frame(ID = seq_len(n), X = X)
for (i in seq_along(modelos)) {
  v <- names(modelos)[i]
  y <- simula(modelos[[v]], semilla0 = 3000 + 1000 * i)
  cat(sprintf("%s  semilla=%5d  media=%5.1f  DE=%5.2f  r=%6.3f  rho=%6.3f  R2q=%5.3f\n",
              v, attr(y, "semilla"), mean(y), sd(y), r(y), rho(y), R2q(y)))
  nubes[[v]] <- as.numeric(y)
}
cat(sprintf("X   media=%5.1f  DE=%5.2f;  r(X, log10 Y6) = %.3f\n",
            mean(X), sd(X), cor(X, log10(nubes$Y6))))

## Salida --------------------------------------------------------------
dir.create("datos", showWarnings = FALSE)
write.csv(nubes, "datos/nubes.csv", row.names = FALSE)

attr(nubes$ID, "jmv-id")   <- TRUE
attr(nubes$ID, "jmv-desc") <- "Identificador del individuo"
attr(nubes$X,  "jmv-desc") <- "Variable explicativa común a todas las nubes"
for (v in names(modelos)) attr(nubes[[v]], "jmv-desc") <- modelos[[v]]$desc
write_omv(nubes, "datos/nubes.omv", frcWrt = TRUE)
