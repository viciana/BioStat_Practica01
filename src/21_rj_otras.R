# ---------------------------------------------------------------------
# 21_rj_otras.R
# Ejecuta datos/otras.R (código R/Rj que se da a los alumnos) con
# datos/forma.omv, igual que lo haría Rj, y guarda el resultado:
#   img/rj_otras.pdf   (diapositiva «Curtosis y asimetría no explican
#   todas las formas»)
# Ejecutar desde el directorio S1:   Rscript src/21_rj_otras.R
# ---------------------------------------------------------------------
data <- jmvReadWrite::read_omv("datos/forma.omv")       # en Rj: 'data'
set.seed(1)                                              # solo el "jitter"
cairo_pdf("img/rj_otras.pdf", width = 6, height = 2.8)
source("datos/otras.R")
dev.off()
