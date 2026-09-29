# ---------------------------------------------------------------------
# 27_rj_transforma.R
# Ejecuta datos/transforma.R (código R/Rj que se da a los alumnos) con
# datos/nubes.omv, igual que lo haría Rj, y guarda el resultado:
#   img/rj_transforma.pdf   (diapositiva «Transformaciones de escala para
#   mejorar el ajuste»)
# Ejecutar desde el directorio S1:   Rscript src/27_rj_transforma.R
# ---------------------------------------------------------------------
data <- jmvReadWrite::read_omv("datos/nubes.omv")       # en Rj: 'data'
cairo_pdf("img/rj_transforma.pdf", width = 5.2, height = 2.4)
source("datos/transforma.R")
dev.off()
