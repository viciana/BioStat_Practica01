# ---------------------------------------------------------------------
# 18_rj_centralidad.R
# Ejecuta datos/centralidad.R (código R/Rj que se da a los alumnos) con
# datos/pacientes.omv, igual que lo haría Rj, y guarda el resultado:
#   img/rj_centralidad.pdf   (diapositiva «Medidas de tendencia central»)
# Ejecutar desde el directorio S1:   Rscript src/18_rj_centralidad.R
# ---------------------------------------------------------------------
data <- jmvReadWrite::read_omv("datos/pacientes.omv")   # en Rj: 'data'
cairo_pdf("img/rj_centralidad.pdf", width = 6, height = 2.7)
source("datos/centralidad.R")
dev.off()
