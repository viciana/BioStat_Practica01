# nubes.omv: recta de regresión de Y4 sobre X y significado de la pendiente
# En Rj (JAMOVI) los datos ya están en 'data'; en R se descargan de la web
if (!is.data.frame(data)) {
  fic <- tempfile(fileext = ".omv")
  download.file("https://epidemos.es/bs2026/nubes.omv", fic, mode = "wb")
  data <- jmvReadWrite::read_omv(fic)
}
m <- lm(Y4 ~ X, data); a <- coef(m)[1]; b <- coef(m)[2]     # ordenada y pendiente
op <- par(mar = c(3, 3, 0.5, 0.5), mgp = c(1.8, 0.6, 0), cex.axis = 0.8, cex.lab = 0.9)
plot(Y4 ~ X, data, pch = 21, bg = "#A8C6EE", col = "grey30", cex = 0.7, las = 1, bty = "l")
abline(m, col = "firebrick", lwd = 2)
x0 <- 20; x1 <- 30                                         # escalón: +10 en X
lines(c(x0, x1, x1), a + b * c(x0, x0, x1), col = "steelblue", lwd = 2)
text(mean(c(x0, x1)), a + b * x0, "+10 en X", pos = 1, cex = 0.75, col = "steelblue")
text(x1, a + b * mean(c(x0, x1)), sprintf("+%.2f en Y", 10 * b), pos = 4, cex = 0.75,
     col = "steelblue")
legend("topleft", sprintf("Y4 = %.2f + %.2f X\nR² = %.2f", a, b, summary(m)$r.squared),
       bty = "n", cex = 0.8)
par(op)
