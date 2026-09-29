# ---------------------------------------------------------------------
# 05_simula_categorias.R
# Data.set "categorias" para comparar índices de variables nominales
# (moda, razón de variación, Gini-Simpson, IQV, entropía de Shannon).
# Genera:  datos/categorias.omv  y  datos/categorias.csv
#
# Cuatro variables con las MISMAS 4 categorías (A, B, C, D) y distinto
# grado de concentración.  Las frecuencias son exactas (no aleatorias)
# para que los índices salgan "redondos"; solo se baraja el orden.
#
# Ejecutar desde el directorio S1:   Rscript src/05_simula_categorias.R
# ---------------------------------------------------------------------
library(jmvReadWrite)
set.seed(2027)
n <- 200

frecuencias <- list(
  C1 = list(f = c(50, 50, 50, 50),  desc = "Equiprobable: máxima diversidad"),
  C2 = list(f = c(80, 60, 40, 20),  desc = "Diversidad moderada"),
  C3 = list(f = c(140, 20, 20, 20), desc = "Concentrada en una categoría"),
  C4 = list(f = c(188, 4, 4, 4),    desc = "Casi toda en una categoría")
)

categorias <- data.frame(ID = 1:n)
for (v in names(frecuencias))
  categorias[[v]] <- factor(sample(rep(LETTERS[1:4], frecuencias[[v]]$f)),
                            levels = LETTERS[1:4])

dir.create("datos", showWarnings = FALSE)
write.csv(categorias, "datos/categorias.csv", row.names = FALSE)

attr(categorias$ID, "jmv-id")   <- TRUE
attr(categorias$ID, "jmv-desc") <- "Identificador del individuo"
for (v in names(frecuencias))
  attr(categorias[[v]], "jmv-desc") <- frecuencias[[v]]$desc
write_omv(categorias, "datos/categorias.omv", frcWrt = TRUE)

print(sapply(categorias[-1], table))
