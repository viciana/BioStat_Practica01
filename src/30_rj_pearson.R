# ---------------------------------------------------------------------
# 30_rj_pearson.R
# Ejecuta datos/pearson.R (código R/Rj que se da a los alumnos; no usa
# ningún data.set, la nube se simula con semilla fija) y guarda el
# resultado:
#   img/pearson_r_demo.pdf   (diapositiva «Coeficiente de correlación
#   de Pearson»)
# Ejecutar desde el directorio del repositorio:
#   Rscript src/30_rj_pearson.R
# ---------------------------------------------------------------------
cairo_pdf("img/pearson_r_demo.pdf", width = 6.4, height = 3.3)
source("datos/pearson.R")
dev.off()
