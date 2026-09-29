# nubes.omv: Y5 frente a X, recta frente a parábola (regresión polinómica)
# En Rj (JAMOVI) los datos ya están en 'data'; en R se descargan de la web
if (!is.data.frame(data)) {
  fic <- tempfile(fileext = ".omv")
  download.file("https://epidemos.es/bs2026/nubes.omv", fic, mode = "wb")
  data <- jmvReadWrite::read_omv(fic)
}
data$X2 <- data$X^2                                   # como la variable calculada X2 = X^2
m1 <- lm(Y5 ~ X, data)                                # recta
m2 <- lm(Y5 ~ X + X2, data)                           # parábola
op <- par(mar = c(3, 3, 0.5, 0.5), mgp = c(1.8, 0.6, 0), cex.axis = 0.8, cex.lab = 0.9)
plot(Y5 ~ X, data, pch = 21, bg = "#A8C6EE", col = "grey30", cex = 0.7, las = 1, bty = "l")
abline(m1, col = "steelblue", lwd = 2)
x <- seq(min(data$X), max(data$X), length.out = 200)
lines(x, predict(m2, data.frame(X = x, X2 = x^2)), col = "firebrick", lwd = 2)
legend("bottom", sprintf(c("Recta (R² = %.2f)", "Parábola (R² = %.2f)"),
                         c(summary(m1)$r.squared, summary(m2)$r.squared)),
       col = c("steelblue", "firebrick"), lwd = 2, bty = "n", cex = 0.8)
par(op)
