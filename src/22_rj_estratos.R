# ---------------------------------------------------------------------
# 22_rj_estratos.R
# Ejecuta datos/estratos.R (código R/Rj que se da a los alumnos) con
# datos/pacientes.omv, igual que lo haría Rj, y guarda el resultado:
#   img/rj_estratos.pdf   (diapositiva «Comparando la distribución entre
#   grupos»)
# Ejecutar desde el directorio S1:   Rscript src/22_rj_estratos.R
# ---------------------------------------------------------------------
data <- jmvReadWrite::read_omv("datos/pacientes.omv")   # en Rj: 'data'
set.seed(1)                                              # solo el "jitter"
cairo_pdf("img/rj_estratos.pdf", width = 6, height = 2.9)
source("datos/estratos.R")
dev.off()
