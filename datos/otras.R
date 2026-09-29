# forma.omv: dos formas muy distintas con curtosis parecida: bimodal (V7) y uniforme (V8)
# En Rj (JAMOVI) los datos ya están en 'data'; en R se descargan de la web
if (!is.data.frame(data)) {
  fic <- tempfile(fileext = ".omv")
  download.file("https://epidemos.es/bs2026/forma.omv", fic, mode = "wb")
  data <- jmvReadWrite::read_omv(fic)
}
G2 <- function(x) {                                   # exceso de curtosis, como JAMOVI
  n <- length(x); z <- x - mean(x); g2 <- mean(z^4) / mean(z^2)^2 - 3
  ((n + 1) * g2 + 6) * (n - 1) / ((n - 2) * (n - 3))
}
vars <- c(V7 = "Bimodal", V8 = "Uniforme")
op <- par(mfrow = c(1, 2), mar = c(2.5, 0.5, 3, 0.5), cex.axis = 0.8, cex.main = 0.95)
for (v in names(vars)) {
  x <- data[[v]]; y0 <- -0.012                       # altura del diagrama de caja
  hist(x, breaks = seq(25, 75, by = 2.5), freq = FALSE, col = "#A8C6EE", border = "grey30",
       axes = FALSE, xlim = c(25, 75), ylim = c(-0.02, 0.056), xlab = "", ylab = "",
       main = sprintf("%s: %s\nG2 = %.2f", v, vars[v], G2(x)))
  axis(1); lines(density(x, adjust = 1.3), lwd = 2)
  curve(dnorm(x, mean(data[[v]]), sd(data[[v]])), add = TRUE,   # normal de referencia
        col = "firebrick", lty = 2, lwd = 2)
  boxplot(x, horizontal = TRUE, add = TRUE, at = y0, boxwex = 0.015, col = "#A8C6EE", axes = FALSE)
  points(x, y0 + runif(length(x), -0.003, 0.003), pch = 19, cex = 0.3, col = adjustcolor(1, 0.4))
}
par(op)
