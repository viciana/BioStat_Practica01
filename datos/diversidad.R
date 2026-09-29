# Diversidad de C1-C4 (categorias.omv): masas de probabilidad con puntos y líneas
# En Rj (JAMOVI) los datos ya están en 'data'; en R se descargan de la web
if (!is.data.frame(data)) {
  fic <- tempfile(fileext = ".omv")
  download.file("https://epidemos.es/bs2026/categorias.omv", fic, mode = "wb")
  data <- jmvReadWrite::read_omv(fic)
}
op <- par(mfrow = c(1, 4), mar = c(3, 3, 4, 1), mgp = c(2, 0.7, 0))
for (v in c("C1", "C2", "C3", "C4")) {
  t  <- table(data[[v]]); p <- as.vector(t) / sum(t)
  GS <- 1 - sum(p^2); H <- -sum(p * log(p))       # Gini-Simpson y Shannon
  plot(seq_along(p), p, type = "h", lwd = 3, col = "grey60", xaxt = "n", las = 1,
       xlim = c(0.5, length(p) + 0.5), ylim = c(0, 1), xlab = "",
       ylab = if (v == "C1") "Frecuencia relativa" else "",
       main = sprintf("%s\nGS = %.2f   H = %.2f", v, GS, H), cex.main = 0.9)
  points(seq_along(p), p, pch = 19, cex = 1.8, col = "steelblue")
  axis(1, seq_along(p), names(t))
}
par(op)
