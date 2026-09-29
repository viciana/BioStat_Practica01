# ---------------------------------------------------------------------
# 26_rj_recta.R
# Ejecuta datos/recta.R (código R/Rj que se da a los alumnos) con
# datos/nubes.omv, igual que lo haría Rj, y guarda el resultado:
#   img/rj_recta.pdf   (diapositiva «La recta de regresión»)
# Ejecutar desde el directorio S1:   Rscript src/26_rj_recta.R
# ---------------------------------------------------------------------
data <- jmvReadWrite::read_omv("datos/nubes.omv")       # en Rj: 'data'
cairo_pdf("img/rj_recta.pdf", width = 3.2, height = 2.6)
source("datos/recta.R")
dev.off()
