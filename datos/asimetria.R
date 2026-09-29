# forma.omv: asimetría positiva (V2), simétrica (V1) y negativa (V3)
# En Rj (JAMOVI) los datos ya están en 'data'; en R se descargan de la web
if (!is.data.frame(data)) {
  fic <- tempfile(fileext = ".omv")
  download.file("https://epidemos.es/bs2026/forma.omv", fic, mode = "wb")
  data <- jmvReadWrite::read_omv(fic)
}
G1 <- function(x) {                                   # asimetría, como la da JAMOVI
  n <- length(x); z <- x - mean(x)
  mean(z^3) / mean(z^2)^1.5 * sqrt(n * (n - 1)) / (n - 2)
}
vars <- c(V2 = "Asimetría positiva", V1 = "Simétrica", V3 = "Asimetría negativa")
op <- par(mfrow = c(1, 3), mar = c(2.5, 0.5, 3, 0.5), cex.axis = 0.8, cex.main = 0.95)
for (v in names(vars)) {
  x <- data[[v]]; d <- density(x, adjust = 1.3)
  est <- c(mean(x), median(x), d$x[which.max(d$y)])   # media, mediana y moda
  hist(x, breaks = seq(0, 101.5, by = 3.5), freq = FALSE, col = "#A8C6EE",
       border = "grey30", axes = FALSE, xlim = c(0, 100), xlab = "", ylab = "",
       main = sprintf("%s: %s\nG1 = %.2f", v, vars[v], G1(x)))
  axis(1); lines(d, lwd = 2)
  abline(v = est, col = c("firebrick", "steelblue", "darkgreen"), lty = 1:3, lwd = 2)
}
par(op)
