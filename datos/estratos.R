# Talla según Sexo (pacientes.omv): densidades superpuestas y cajas con violines
# En Rj (JAMOVI) los datos ya están en 'data'; en R se descargan de la web
if (!is.data.frame(data)) {
  fic <- tempfile(fileext = ".omv")
  download.file("https://epidemos.es/bs2026/pacientes.omv", fic, mode = "wb")
  data <- jmvReadWrite::read_omv(fic)
}
g <- split(data$Talla, data$Sexo); d <- lapply(g, density)   # un grupo por sexo
col <- c("#6E9FD8", "#E3A33B"); transp <- adjustcolor(col, 0.45)
layout(matrix(1:2, 1), widths = c(1.3, 1))
op <- par(mar = c(3, 0.5, 2, 0.5), mgp = c(1.8, 0.6, 0), cex.axis = 0.8, cex.lab = 0.85,
          cex.main = 0.95)
# 1. Densidades superpuestas: comparan forma y posición
plot(NA, xlim = c(140, 200), ylim = c(0, max(sapply(d, function(k) max(k$y)))),
     yaxt = "n", bty = "n", xlab = "Talla (cm)", ylab = "", main = "Densidades por sexo")
for (i in 1:2) polygon(d[[i]], col = transp[i], border = col[i], lwd = 2)
legend("topright", names(g), fill = transp, border = col, bty = "n", cex = 0.8)
# 2. Violines (densidad en espejo) con la caja y los puntos
par(mar = c(3, 3, 2, 0.5))
plot(NA, xlim = c(0.5, 2.5), ylim = c(140, 200), xaxt = "n", bty = "n", las = 1,
     xlab = "", ylab = "Talla (cm)", main = "Cajas y violines por sexo")
for (i in 1:2) {
  w <- 0.4 * d[[i]]$y / max(d[[i]]$y)
  polygon(c(i + w, rev(i - w)), c(d[[i]]$x, rev(d[[i]]$x)), col = transp[i], border = NA)
}
boxplot(g, add = TRUE, boxwex = 0.25, col = col, las = 1, outcex = 0.6, frame = FALSE)
points(jitter(rep(1:2, lengths(g)), 0.4), unlist(g), pch = 19, cex = 0.3,
       col = adjustcolor(1, 0.4))
par(op)
