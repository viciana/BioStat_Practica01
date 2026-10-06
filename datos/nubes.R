# nubes.omv: cuatro formas de la nube de puntos (Y frente a X) y su r de Pearson
# En Rj (JAMOVI) los datos ya están en 'data'; en R se descargan de la web
if (!is.data.frame(data)) {
  fic <- tempfile(fileext = ".omv")
  download.file("https://epidemos.es/bs2026/nubes.omv", fic, mode = "wb")
  data <- jmvReadWrite::read_omv(fic)
}
vars <- c(Y1 = "Ruido (sin relación)", Y2 = "Correlación positiva",
          Y3 = "Correlación negativa", Y5 = "Relación parabólica")
op <- par(mfrow = c(1, 4), mar = c(3, 2, 3, 0.5), mgp = c(1.8, 0.6, 0),
          cex.axis = 0.75, cex.lab = 0.85, cex.main = 0.85)
for (v in names(vars)) {
  m <- lm(data[[v]] ~ data$X)
  plot(data$X, data[[v]], pch = 21, bg = "#A8C6EE", col = "grey30", cex = 0.8,
       las = 1, bty = "l", xlab = "X", ylab = "",
       main = sprintf("%s: %s\nr = %.2f (b = %.2f)", v, vars[v],
                       cor(data$X, data[[v]]), coef(m)[2]))
  abline(m, col = "#C0392B", lwd = 2)
}
par(op)
