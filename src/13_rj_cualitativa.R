# ---------------------------------------------------------------------
# 13_rj_cualitativa.R
# Ejecuta datos/cualitativa.R (código para el editor Rj de JAMOVI, que se
# muestra en la presentación y se da a los alumnos) con pacientes.omv,
# igual que lo haría Rj, y guarda el resultado:  img/rj_cualitativa.pdf
# Ejecutar desde el directorio S1:   Rscript src/13_rj_cualitativa.R
# ---------------------------------------------------------------------
data <- jmvReadWrite::read_omv("datos/pacientes.omv")   # en Rj: 'data'
cairo_pdf("img/rj_cualitativa.pdf", width = 8, height = 3.3)
source("datos/cualitativa.R")
dev.off()
