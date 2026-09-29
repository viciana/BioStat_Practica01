# ---------------------------------------------------------------------
# 20_rj_curtosis.R
# Ejecuta datos/curtosis.R (código R/Rj que se da a los alumnos) con
# datos/forma.omv, igual que lo haría Rj, y guarda el resultado:
#   img/rj_curtosis.pdf   (diapositiva «Coeficiente de apuntamiento»)
# Ejecutar desde el directorio S1:   Rscript src/20_rj_curtosis.R
# ---------------------------------------------------------------------
data <- jmvReadWrite::read_omv("datos/forma.omv")       # en Rj: 'data'
cairo_pdf("img/rj_curtosis.pdf", width = 6, height = 2.2)
source("datos/curtosis.R")
dev.off()
