# ---------------------------------------------------------------------
# 29_rj_logistica.R
# Ejecuta datos/logistica.R (código R/Rj que se da a los alumnos) con
# datos/pacientes.omv, igual que lo haría Rj, y guarda el resultado:
#   img/rj_logistica.pdf   (diapositiva «Cuando la variable dependiente es
#   binaria (0/1)»)
# Ejecutar desde el directorio S1:   Rscript src/29_rj_logistica.R
# ---------------------------------------------------------------------
data <- jmvReadWrite::read_omv("datos/pacientes.omv")   # en Rj: 'data'
set.seed(1)                                              # solo el "jitter"
cairo_pdf("img/rj_logistica.pdf", width = 3.2, height = 2.8)
source("datos/logistica.R")
dev.off()
