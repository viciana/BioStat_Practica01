# forma.omv: curtosis leptocúrtica (V4), mesocúrtica (V5) y platicúrtica (V6)
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
vars <- c(V4 = "Leptocúrtica", V5 = "Mesocúrtica", V6 = "Platicúrtica")
op <- par(mfrow = c(1, 3), mar = c(2.5, 0.5, 3, 0.5), cex.axis = 0.8, cex.main = 0.95)
for (v in names(vars)) {
  x <- data[[v]]
  hist(x, breaks = seq(0, 101.5, by = 3.5), freq = FALSE, col = "#A8C6EE",
       border = "grey30", axes = FALSE, xlim = c(0, 100), ylim = c(0, 0.07),
       xlab = "", ylab = "", main = sprintf("%s: %s\nG2 = %.2f", v, vars[v], G2(x)))
  axis(1); lines(density(x, adjust = 1.3), lwd = 2)
  curve(dnorm(x, mean(data[[v]]), sd(data[[v]])), add = TRUE,   # normal de referencia
        col = "firebrick", lty = 2, lwd = 2)
}
par(op)
