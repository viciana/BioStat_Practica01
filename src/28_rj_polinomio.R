# ---------------------------------------------------------------------
# 28_rj_polinomio.R
# Ejecuta datos/polinomio.R (código R/Rj que se da a los alumnos) con
# datos/nubes.omv, igual que lo haría Rj, y guarda el resultado:
#   img/rj_polinomio.pdf   (diapositiva «Regresión con curvas polinómicas»)
# Ejecutar desde el directorio S1:   Rscript src/28_rj_polinomio.R
# ---------------------------------------------------------------------
data <- jmvReadWrite::read_omv("datos/nubes.omv")       # en Rj: 'data'
cairo_pdf("img/rj_polinomio.pdf", width = 3.2, height = 2.8)
source("datos/polinomio.R")
dev.off()
