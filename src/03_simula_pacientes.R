# ---------------------------------------------------------------------
# 03_simula_pacientes.R
# Simula el data.set "pacientes" para el bloque de carga y manipulación
# de datos en jamovi (y reutilizable en descriptiva y regresión).
# Genera:
#     datos/pacientes.csv  datos "en bruto": categorías con códigos
#                          numéricos, sin etiquetas (hay que arreglarlo
#                          en jamovi)
#     datos/pacientes.omv  la misma tabla ya tipada, etiquetada y con
#                          descripciones (fichero "de rescate")
#     datos/analitica.csv  segunda tabla con otras variables de parte de
#                          los mismos individuos (para hablar de "merge")
#
# Relaciones incorporadas (para usarlas en descriptiva y regresión):
#   Talla y Peso dependen del Sexo; Peso ~ Talla;  PAS ~ Edad + IMC;
#   Colesterol ~ Edad;  Triglicéridos (log-normal) ~ IMC;
#   Estudios más bajos en los de más edad;  Pulso algo mayor en fumadores.
#
# Ejecutar desde el directorio S1:   Rscript src/03_simula_pacientes.R
# ---------------------------------------------------------------------
library(jmvReadWrite)
set.seed(2026)
n <- 200

acota <- function(x, a, b) pmin(pmax(x, a), b)

Sexo  <- sample(1:2, n, replace = TRUE)                 # 1 Hombre, 2 Mujer
Edad  <- round(acota(18 + rgamma(n, 2.2, 1 / 12), 18, 85))
GrupoSang <- sample(c("A", "O", "B", "AB"), n, replace = TRUE,
                    prob = c(0.44, 0.40, 0.11, 0.05))

# Estudios (1 Sin estudios ... 5 Universitarios): peor nivel con la edad
lat <- rnorm(n, 3.4 - 0.03 * (Edad - 45), 1.1)
Estudios <- as.integer(cut(lat, c(-Inf, 1.5, 2.5, 3.3, 4.2, Inf)))

# Fumador (0 Nunca, 1 Exfumador, 2 Fumador): más exfumadores con la edad
p_ex <- plogis(-3.2 + 0.04 * Edad)
Fumador <- sapply(p_ex, \(p) sample(0:2, 1, prob = c(0.55 * (1 - p), p, 0.45 * (1 - p))))

Convivientes <- pmin(rpois(n, 2.1), 7)

Talla <- round(ifelse(Sexo == 1, rnorm(n, 176, 7), rnorm(n, 163, 6.5)))
IMC   <- acota(rnorm(n, 22 + 0.06 * (Edad - 18), 3.2), 16.5, 42)
Peso  <- round(IMC * (Talla / 100)^2)
IMC   <- Peso / (Talla / 100)^2                          # el que se observa

PAS   <- round(acota(95 + 0.45 * Edad + 1.1 * (IMC - 22) + 4 * (Sexo == 1) +
                     rnorm(n, 0, 11), 90, 200))
Pulso <- round(rnorm(n, 71 + 4 * (Fumador == 2), 8))
Temperatura <- round(rnorm(n, 36.6, 0.3), 1)
Colesterol  <- round(rnorm(n, 170 + 0.9 * Edad, 30))
Trigliceridos <- round(exp(rnorm(n, log(95) + 0.045 * (IMC - 22), 0.45)))

# Algunos datos faltantes (analítica no realizada): ~3 %
Colesterol[sample(n, 6)]    <- NA
Trigliceridos[sample(n, 6)] <- NA

## Segunda tabla: analítica de 180 de los pacientes, otro orden -------
ids <- sort(sample(n, 180))
analitica <- data.frame(
  ID         = ids,
  Glucosa    = round(rnorm(180, 88 + 0.25 * Edad[ids] + 0.8 * (IMC[ids] - 22), 12)),
  Hemoglobina = round(ifelse(Sexo[ids] == 1, rnorm(180, 15, 1), rnorm(180, 13.5, 0.9)), 1),
  Creatinina = round(ifelse(Sexo[ids] == 1, rnorm(180, 0.95, 0.15),
                            rnorm(180, 0.75, 0.12)), 2))
analitica <- analitica[sample(nrow(analitica)), ]        # desordenada

## HTA diagnosticada (añadida después: sus sorteos van al final para no
## alterar el resto de variables).  Riesgo creciente con edad, IMC y sexo
## masculino; prevalencia ~ 25 %.  Sirve para tablas 2x2 (con IMC >= 25)
## y para la regresión logística.  Efectos reforzados (28-09-2026; antes
## -5.1 + 0.065 Edad + 0.13 IMC): con ellos la curva logística se ve clara.
p_hta <- plogis(-7.7 + 0.12 * Edad + 0.35 * (IMC - 22) + 0.4 * (Sexo == 1))
HTA <- rbinom(n, 1, p_hta)

pacientes <- data.frame(ID = 1:n, Sexo, Edad, GrupoSang, Estudios,
                        Fumador, Convivientes, Peso, Talla, PAS, Pulso,
                        Temperatura, Colesterol, Trigliceridos, HTA)

dir.create("datos", showWarnings = FALSE)

## 1. CSV en bruto (códigos numéricos, NA como celda vacía) -------------
write.csv(pacientes, "datos/pacientes.csv", row.names = FALSE, na = "")

## 2. OMV tipado y etiquetado -------------------------------------------
omv <- pacientes
omv$Sexo     <- factor(omv$Sexo, 1:2, c("Hombre", "Mujer"))
omv$GrupoSang <- factor(omv$GrupoSang, c("A", "B", "AB", "O"))
omv$Estudios <- factor(omv$Estudios, 1:5,
                       c("Sin estudios", "Primarios", "Secundarios",
                         "FP", "Universitarios"), ordered = TRUE)
omv$Fumador  <- factor(omv$Fumador, 0:2,
                       c("Nunca", "Exfumador", "Fumador"))
omv$HTA      <- factor(omv$HTA, 0:1, c("No", "Sí"))
desc <- c(ID            = "Identificador del paciente",
          Sexo          = "Sexo biológico (1 Hombre, 2 Mujer)",
          Edad          = "Edad (años cumplidos)",
          GrupoSang     = "Grupo sanguíneo (sistema AB0)",
          Estudios      = "Nivel de estudios terminados (1 a 5)",
          Fumador       = "Hábito tabáquico (0 Nunca, 1 Exfumador, 2 Fumador)",
          Convivientes  = "Personas que conviven en el hogar (sin contar al paciente)",
          Peso          = "Peso (kg)",
          Talla         = "Talla (cm)",
          PAS           = "Presión arterial sistólica (mmHg)",
          Pulso         = "Frecuencia cardiaca en reposo (latidos/min)",
          Temperatura   = "Temperatura axilar (ºC)",
          Colesterol    = "Colesterol total (mg/dL)",
          Trigliceridos = "Triglicéridos (mg/dL)",
          HTA           = "Hipertensión arterial diagnosticada (0 No, 1 Sí)")
for (v in names(desc)) attr(omv[[v]], "jmv-desc") <- desc[[v]]
attr(omv$ID, "jmv-id") <- TRUE
write_omv(omv, "datos/pacientes.omv", frcWrt = TRUE)

## 3. Segunda tabla ------------------------------------------------------
write.csv(analitica, "datos/analitica.csv", row.names = FALSE)

## Comprobación rápida ---------------------------------------------------
print(summary(pacientes[-1]))
print(table(Estudios = omv$Estudios))
print(table(Fumador = omv$Fumador))
cat("HTA:", mean(HTA), "\n"); print(table(Sobrepeso = IMC >= 25, HTA))
cat("cor(Peso, Talla) =", round(cor(Peso, Talla), 2),
    "  cor(PAS, Edad) =", round(cor(PAS, Edad), 2), "\n")
