# ---------------------------------------------------------------------
# 07_soluciones.R: fichero de soluciones de los bloques 1 y 2
#
#   datos/soluciones.omv
#
# Reproduce el estado de pacientes.csv tras las manipulaciones que hacen
# los alumnos en jamovi (Ejercicio 01 y bloque 2), con las variables
# calculadas, las transformaciones y el filtro *con sus fórmulas*, para
# que se puedan inspeccionar en jamovi.
#
# Como en jamovi tras importar el CSV, las categóricas son enteras con
# etiquetas (así `Estudios <= 2` o `Fumador == 2` usan el código).
#
# jmvReadWrite no escribe etiquetas de enteros ni transformaciones: se
# escribe el .omv y después se retocan metadata.json y xdata.json.
# Los valores de las columnas calculadas se calculan también en R (jamovi
# los recalcula al abrir el fichero).
#
# Ejecutar desde el directorio S1:   Rscript src/07_soluciones.R
# ---------------------------------------------------------------------
suppressMessages(library(jmvReadWrite))
library(jsonlite)

csv  <- read.csv("datos/pacientes.csv")
omv  <- read_omv("datos/pacientes.omv")                  # descripciones
desc <- sapply(omv, \(x) attr(x, "jmv-desc") %||% "")

## Columnas nuevas (valores calculados en R) -------------------------
d <- csv
IMC  <- d$Peso / (d$Talla / 100)^2
p    <- ave(rep(1, nrow(d)), d$GrupoSang, FUN = sum) / nrow(d)
FumaActual <- ifelse(d$Fumador == 2, 1L, 0L)
Filtro <- as.integer(d$Sexo == 2 & FumaActual == 0)

nuevas <- list(
  GruposEdad = factor(cut(d$Edad, c(-Inf, 35, 55, Inf), right = FALSE,
                          labels = c("< 35", "35-54", "55 y mas")),
                      ordered = TRUE),
  p  = p,
  GS = rep(1 - mean(p), nrow(d)),
  H  = rep(-mean(log(p)), nrow(d)),
  NivelEst = factor(ifelse(d$Estudios <= 2, "Bajo",
                           ifelse(d$Estudios <= 4, "Medio", "Alto"))),
  FumaActual = FumaActual,
  zPeso = (d$Peso - mean(d$Peso)) / sd(d$Peso),
  IMC = IMC,
  GruposIMC = factor(cut(IMC, c(-Inf, 18.5, 25, 30, Inf), right = FALSE,
                         labels = c("Bajo peso", "Normal", "Sobrepeso", "Obesidad")),
                     ordered = TRUE),
  Sobrepeso  = ifelse(IMC >= 25, 1L, 2L),
  SobrepesoD = ifelse(IMC >= 25, 1L, 2L),
  `Colesterol - Logaritmo decimal`    = log10(d$Colesterol),
  `Trigliceridos - Logaritmo decimal` = log10(d$Trigliceridos))

## Orden: cada columna nueva a la derecha de su origen (como jamovi) ---
orden <- c("Filtrar 1", "ID", "Sexo", "Edad", "GruposEdad", "GrupoSang",
           "p", "GS", "H", "Estudios", "NivelEst", "Fumador", "FumaActual",
           "Convivientes", "Peso", "zPeso", "Talla", "IMC", "GruposIMC",
           "Sobrepeso", "SobrepesoD", "PAS", "Pulso", "Temperatura",
           "Colesterol", "Trigliceridos", "HTA",
           "Colesterol - Logaritmo decimal", "Trigliceridos - Logaritmo decimal")
todo <- c(list(`Filtrar 1` = Filtro), as.list(d), nuevas)[orden]
sol  <- as.data.frame(todo, check.names = FALSE)

## Especificación jamovi de cada columna nueva -------------------------
## tipo: C = calculada, R = transformada (Recoded), F = filtro
esp <- list(
  `Filtrar 1` = list("F", "Nominal", 'Sexo == "Mujer" and FumaActual == 0', ""),
  GruposEdad  = list("R", "Ordinal", NA, "Edad agrupada (Transformar)"),
  p   = list("C", "Continuous", "VN(GrupoSang, group_by=GrupoSang) / VN(GrupoSang)",
             "Proporción de la categoría de GrupoSang"),
  GS  = list("C", "Continuous", "1 - VMEAN(p)", "Índice de Gini-Simpson de GrupoSang"),
  H   = list("C", "Continuous", "-VMEAN(LN(p))", "Entropía de Shannon de GrupoSang"),
  NivelEst   = list("C", "Nominal",
                    'IF(Estudios <= 2, "Bajo", IF(Estudios <= 4, "Medio", "Alto"))',
                    "Estudios agrupados (Bajo, Medio, Alto)"),
  FumaActual = list("C", "Nominal", "IF(Fumador == 2, 1, 0)",
                    "Fuma actualmente (1 sí, 0 no)"),
  zPeso = list("C", "Continuous", "Z(Peso)", "Peso estandarizado (media 0, DE 1)"),
  IMC   = list("C", "Continuous", "Peso / (Talla / 100)^2",
               "Índice de masa corporal (kg/m²)"),
  GruposIMC = list("R", "Ordinal", NA, "IMC agrupado (Transformar)"),
  Sobrepeso = list("C", "Nominal", "IF(IMC >= 25, 1, 2)",
                   "Sobrepeso: 1 si IMC >= 25, 2 si no (calculada)"),
  SobrepesoD = list("D", "Nominal", "",
                    "Copia de Sobrepeso como variable de datos (niveles reordenables)"),
  `Colesterol - Logaritmo decimal`    = list("R", "Continuous", NA, ""),
  `Trigliceridos - Logaritmo decimal` = list("R", "Continuous", NA, ""))

for (v in names(esp)) {
  e <- esp[[v]]
  attr(sol[[v]], "columnType")  <- switch(e[[1]], C = "Computed", R = "Recoded",
                                          F = "Filter", D = "Data")
  attr(sol[[v]], "measureType") <- e[[2]]
  if (!is.na(e[[3]])) attr(sol[[v]], "formula") <- e[[3]]
  desc[v] <- e[[4]]
}
for (v in names(sol)) attr(sol[[v]], "jmv-desc") <- unname(desc[v])

fic <- "datos/soluciones.omv"
write_omv(sol, fic, frcWrt = TRUE)

## Retoques en metadata.json y xdata.json -----------------------------
tmp <- tempfile(); dir.create(tmp)
unzip(fic, exdir = tmp)
mta <- read_json(file.path(tmp, "metadata.json"))
xda <- read_json(file.path(tmp, "xdata.json"))
if (length(xda) == 0) xda <- setNames(list(), character(0))

campos <- mta$dataSet$fields
nombre <- sapply(campos, `[[`, "name")
id     <- setNames(sapply(campos, `[[`, "id"), nombre)
fld    <- function(v) which(nombre == v)

## Enteros con etiquetas (orden de la lista = orden de los niveles)
etiquetas <- list(
  Sexo     = list(c(1, "Hombre"), c(2, "Mujer")),
  Estudios = list(c(1, "Sin estudios"), c(2, "Primarios"), c(3, "Secundarios"),
                  c(4, "FP"), c(5, "Universitarios")),
  Fumador  = list(c(0, "Nunca"), c(1, "Exfumador"), c(2, "Fumador")),
  HTA      = list(c(1, "Sí"), c(0, "No")),              # "Sí" primero (RR)
  FumaActual = list(c(0, "0"), c(1, "1")),
  Sobrepeso  = list(c(2, "2"), c(1, "1")),              # orden de aparición
  SobrepesoD = list(c(1, "1"), c(2, "2")),              # reordenada: 1 primero
  `Filtrar 1` = list(c(0, "0"), c(1, "1")))
for (v in names(etiquetas)) {
  i <- fld(v)
  campos[[i]]$dataType <- "Integer"
  campos[[i]]$type     <- "integer"
  campos[[i]]$measureType <- if (v == "Estudios") "Ordinal" else "Nominal"
  xda[[v]] <- list(labels = lapply(etiquetas[[v]], \(e)
    list(as.integer(e[1]), e[2], as.character(as.integer(e[1])), FALSE)))
}

## Transformaciones (Recoded): definición común + fórmula de la columna
mta$dataSet$transforms <- list(
  list(name = "Grupos de edad", id = 1L, suffix = "",
       formula = list("< 35", '"< 35"', "< 55", '"35-54"', '"55 y mas"'),
       formulaMessage = as.list(rep("", 5)), measureType = "Ordinal", description = ""),
  list(name = "Logaritmo decimal", id = 2L, suffix = "",
       formula = list("LOG10($source)"), formulaMessage = list(""),
       measureType = "Continuous", description = ""),
  list(name = "Grupos de IMC", id = 3L, suffix = "",
       formula = list("< 18.5", '"Bajo peso"', "< 25", '"Normal"', "< 30",
                      '"Sobrepeso"', '"Obesidad"'),
       formulaMessage = as.list(rep("", 7)), measureType = "Ordinal", description = ""))
recod <- list(
  GruposEdad = list(1L, "Edad",
    '_RECODE_ORD(`Edad`,`Edad` < 35,"< 35",`Edad` < 55,"35-54",IFMISS($source, NA, 1),"55 y mas")'),
  GruposIMC  = list(3L, "IMC",
    '_RECODE_ORD(`IMC`,`IMC` < 18.5,"Bajo peso",`IMC` < 25,"Normal",`IMC` < 30,"Sobrepeso",IFMISS($source, NA, 1),"Obesidad")'),
  `Colesterol - Logaritmo decimal` = list(2L, "Colesterol",
    "_RECODE_CONT(`Colesterol`,IFMISS($source, NA, 1),LOG10($source))"),
  `Trigliceridos - Logaritmo decimal` = list(2L, "Trigliceridos",
    "_RECODE_CONT(`Trigliceridos`,IFMISS($source, NA, 1),LOG10($source))"))
for (v in names(recod)) {
  i <- fld(v)
  campos[[i]]$transform <- recod[[v]][[1]]
  campos[[i]]$parentId  <- unname(id[recod[[v]][[2]]])
  campos[[i]]$formula   <- recod[[v]][[3]]
}

## Filtro: primera columna, inactivo (para no alterar los análisis)
i <- fld("Filtrar 1")
campos[[i]]$filterNo <- 0L
campos[[i]]$active   <- FALSE

mta$dataSet$fields <- campos
write_json(mta, file.path(tmp, "metadata.json"), auto_unbox = TRUE, null = "null")
write_json(xda, file.path(tmp, "xdata.json"),    auto_unbox = TRUE)

ficheros <- c("meta", setdiff(list.files(tmp), "meta"))
invisible(file.remove(fic))
old <- setwd(tmp); zip(file.path(old, fic), ficheros, flags = "-q -X"); setwd(old)
unlink(tmp, recursive = TRUE)

cat(sprintf("%s: %d filas, %d columnas; filtro (mujeres no fumadoras) = %d filas\n",
            fic, nrow(sol), ncol(sol), sum(Filtro)))
cat(sprintf("GS = %.3f  H = %.3f\n", sol$GS[1], sol$H[1]))
print(table(Sobrepeso = sol$SobrepesoD, HTA = sol$HTA))
