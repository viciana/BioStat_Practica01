# ---------------------------------------------------------------------
# 14_rj_diversidad.R
# Ejecuta datos/diversidad.R (código R/Rj que se da a los alumnos) con
# datos/categorias.omv, igual que lo haría Rj, y guarda el resultado:
#   img/rj_diversidad.pdf   (diapositiva «Diversidad: cuatro variables...»)
# Ejecutar desde el directorio S1:   Rscript src/14_rj_diversidad.R
# ---------------------------------------------------------------------
data <- jmvReadWrite::read_omv("datos/categorias.omv")  # en Rj: 'data'
cairo_pdf("img/rj_diversidad.pdf", width = 6, height = 2.3)
source("datos/diversidad.R")
dev.off()
