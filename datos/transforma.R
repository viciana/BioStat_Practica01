# nubes.omv: Y6 crece de forma exponencial; con log10(Y6) la nube se vuelve recta
# En Rj (JAMOVI) los datos ya están en 'data'; en R se descargan de la web
if (!is.data.frame(data)) {
  fic <- tempfile(fileext = ".omv")
  download.file("https://epidemos.es/bs2026/nubes.omv", fic, mode = "wb")
  data <- jmvReadWrite::read_omv(fic)
}
op <- par(mfrow = c(1, 2), mar = c(3, 3, 2, 0.5), mgp = c(1.8, 0.6, 0),
          cex.axis = 0.8, cex.lab = 0.85, cex.main = 0.95)
for (esc in c("Escala original", "Escala logarítmica")) {
  y <- if (esc == "Escala original") data$Y6 else log10(data$Y6)
  m <- lm(y ~ data$X)                                        # recta de regresión
  plot(data$X, y, pch = 21, bg = "#A8C6EE", col = "grey30", cex = 0.7, las = 1,
       bty = "l", xlab = "X", ylab = if (esc == "Escala original") "Y6" else "log10(Y6)",
       main = esc)
  abline(m, col = "firebrick", lwd = 2)
  legend("topleft", sprintf("R² = %.2f", summary(m)$r.squared), bty = "n", cex = 0.8)
}
par(op)
