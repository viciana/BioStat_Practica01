# Histogramas del Colesterol (pacientes.omv) con tres anchos de clase
# En Rj (JAMOVI) los datos ya están en 'data'; en R se descargan de la web
if (!is.data.frame(data)) {
  fic <- tempfile(fileext = ".omv")
  download.file("https://epidemos.es/bs2026/pacientes.omv", fic, mode = "wb")
  data <- jmvReadWrite::read_omv(fic)
}
x <- na.omit(data$Colesterol)
anchos <- c("demasiado ruido" = 2, "adecuado" = 15, "se pierde la forma" = 60)
op <- par(mfrow = c(1, 3), mar = c(4, 3, 3, 1))
for (i in seq_along(anchos)) {
  a <- anchos[i]                                     # ancho de clase (mg/dL)
  hist(x, breaks = seq(100, max(x) + a, by = a),     # límites de las clases
       col = "#A8C6EE", border = if (a < 5) NA else "grey30", las = 1, ylab = "",
       xlim = c(100, 340), xlab = "Colesterol (mg/dL)",
       main = sprintf("Ancho %g mg/dL\n%s", a, names(anchos)[i]))
}
par(op)
