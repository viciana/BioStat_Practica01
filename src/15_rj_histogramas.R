# ---------------------------------------------------------------------
# 15_rj_histogramas.R
# Ejecuta datos/histogramas.R (código R/Rj que se da a los alumnos) con
# datos/pacientes.omv, igual que lo haría Rj, y guarda el resultado:
#   img/rj_histogramas.pdf   (diapositiva «Histogramas: la elección del
#   ancho de clase»)
# Ejecutar desde el directorio S1:   Rscript src/15_rj_histogramas.R
# ---------------------------------------------------------------------
data <- jmvReadWrite::read_omv("datos/pacientes.omv")   # en Rj: 'data'
cairo_pdf("img/rj_histogramas.pdf", width = 6.5, height = 2.6)
source("datos/histogramas.R")
dev.off()
