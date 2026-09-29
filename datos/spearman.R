# nubes.omv: Pearson frente a Spearman con atípicos (Y7) y la nube de los rangos
# En Rj (JAMOVI) los datos ya están en 'data'; en R se descargan de la web
if (!is.data.frame(data)) {
  fic <- tempfile(fileext = ".omv")
  download.file("https://epidemos.es/bs2026/nubes.omv", fic, mode = "wb")
  data <- jmvReadWrite::read_omv(fic)
}
x <- data$X; y <- data$Y7
o <- order(x); atip <- seq_along(x) %in% c(head(o, 3), tail(o, 3))  # 3 atípicos en cada extremo
col <- ifelse(atip, "firebrick", "#A8C6EE")
op <- par(mfrow = c(1, 2), mar = c(3, 3, 3, 0.5), mgp = c(1.8, 0.6, 0),
          cex.axis = 0.75, cex.lab = 0.85, cex.main = 0.85)
plot(x, y, pch = 21, bg = col, col = "grey30", cex = 0.8, las = 1, bty = "l",
     xlab = "X", ylab = "Y7",
     main = sprintf("Datos originales\nPearson r = %.2f   Spearman ρ = %.2f",
                    cor(x, y), cor(x, y, method = "spearman")))
# Spearman = Pearson calculado sobre los rangos (en JAMOVI: Calcular con RANK())
plot(rank(x), rank(y), pch = 21, bg = col, col = "grey30", cex = 0.8, las = 1, bty = "l",
     xlab = "RANK(X)", ylab = "RANK(Y7)",
     main = sprintf("Rangos\nPearson de los rangos = %.2f = ρ", cor(rank(x), rank(y))))
par(op)
