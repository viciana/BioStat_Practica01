# ---------------------------------------------------------------------
# 19_rj_asimetria.R
# Ejecuta datos/asimetria.R (código R/Rj que se da a los alumnos) con
# datos/forma.omv, igual que lo haría Rj, y guarda el resultado:
#   img/rj_asimetria.pdf   (diapositiva «Medida de forma: coeficiente de
#   asimetría»)
# Ejecutar desde el directorio S1:   Rscript src/19_rj_asimetria.R
# ---------------------------------------------------------------------
data <- jmvReadWrite::read_omv("datos/forma.omv")       # en Rj: 'data'
cairo_pdf("img/rj_asimetria.pdf", width = 6, height = 2.2)
source("datos/asimetria.R")
dev.off()
