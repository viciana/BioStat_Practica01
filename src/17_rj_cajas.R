# ---------------------------------------------------------------------
# 17_rj_cajas.R
# Ejecuta datos/cajas.R (código R/Rj que se da a los alumnos) con
# datos/pacientes.omv, igual que lo haría Rj, y guarda el resultado:
#   img/rj_cajas.pdf   (diapositiva «Diagrama de caja y bigotes, y violín»)
# Ejecutar desde el directorio S1:   Rscript src/17_rj_cajas.R
# ---------------------------------------------------------------------
data <- jmvReadWrite::read_omv("datos/pacientes.omv")   # en Rj: 'data'
set.seed(1)                                              # solo el "jitter"
cairo_pdf("img/rj_cajas.pdf", width = 6, height = 2.95)
source("datos/cajas.R")
dev.off()
