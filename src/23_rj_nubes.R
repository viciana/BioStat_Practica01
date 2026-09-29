# ---------------------------------------------------------------------
# 23_rj_nubes.R
# Ejecuta datos/nubes.R (código R/Rj que se da a los alumnos) con
# datos/nubes.omv, igual que lo haría Rj, y guarda el resultado:
#   img/rj_nubes.pdf   (diapositiva «Diferentes formas de la nube de
#   puntos»)
# Ejecutar desde el directorio S1:   Rscript src/23_rj_nubes.R
# ---------------------------------------------------------------------
data <- jmvReadWrite::read_omv("datos/nubes.omv")       # en Rj: 'data'
cairo_pdf("img/rj_nubes.pdf", width = 6.5, height = 2.75)
source("datos/nubes.R")
dev.off()
