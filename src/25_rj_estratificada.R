# ---------------------------------------------------------------------
# 25_rj_estratificada.R
# Ejecuta datos/estratificada.R (código R/Rj que se da a los alumnos) con
# datos/pacientes.omv, igual que lo haría Rj, y guarda el resultado:
#   img/rj_estratificada.pdf   (diapositiva «Nube de puntos estratificada»)
# Ejecutar desde el directorio S1:   Rscript src/25_rj_estratificada.R
# ---------------------------------------------------------------------
data <- jmvReadWrite::read_omv("datos/pacientes.omv")   # en Rj: 'data'
cairo_pdf("img/rj_estratificada.pdf", width = 6, height = 3)
source("datos/estratificada.R")
dev.off()
