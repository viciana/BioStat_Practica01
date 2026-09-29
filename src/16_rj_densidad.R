# ---------------------------------------------------------------------
# 16_rj_densidad.R
# Ejecuta datos/densidad.R (código R/Rj que se da a los alumnos) con
# datos/pacientes.omv, igual que lo haría Rj, y guarda el resultado:
#   img/rj_densidad.pdf   (diapositiva «Histograma, polígono de
#   frecuencias y curva de densidad»)
# Ejecutar desde el directorio S1:   Rscript src/16_rj_densidad.R
# ---------------------------------------------------------------------
data <- jmvReadWrite::read_omv("datos/pacientes.omv")   # en Rj: 'data'
cairo_pdf("img/rj_densidad.pdf", width = 6.5, height = 2.6)
source("datos/densidad.R")
dev.off()
