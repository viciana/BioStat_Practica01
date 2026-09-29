# ---------------------------------------------------------------------
# 24_rj_spearman.R
# Ejecuta datos/spearman.R (código R/Rj que se da a los alumnos) con
# datos/nubes.omv, igual que lo haría Rj, y guarda el resultado:
#   img/rj_spearman.pdf   (diapositiva «Coeficiente de correlación de
#   Spearman»)
# Ejecutar desde el directorio S1:   Rscript src/24_rj_spearman.R
# ---------------------------------------------------------------------
data <- jmvReadWrite::read_omv("datos/nubes.omv")       # en Rj: 'data'
cairo_pdf("img/rj_spearman.pdf", width = 6, height = 2.7)
source("datos/spearman.R")
dev.off()
