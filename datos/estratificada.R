# Peso según Talla por Sexo (pacientes.omv): nube estratificada y rectas de regresión
# En Rj (JAMOVI) los datos ya están en 'data'; en R se descargan de la web
if (!is.data.frame(data)) {
  fic <- tempfile(fileext = ".omv")
  download.file("https://epidemos.es/bs2026/pacientes.omv", fic, mode = "wb")
  data <- jmvReadWrite::read_omv(fic)
}
col <- c(Todos = "#E0302A", Hombre = "#6E9FD8", Mujer = "#E3A33B")
op <- par(mar = c(3, 3, 0.5, 0.5), mgp = c(1.8, 0.6, 0), cex.axis = 0.8, cex.lab = 0.85)
plot(Peso ~ Talla, data, pch = 21, bg = col[-1][data$Sexo], col = "grey30", cex = 0.8,
     las = 1, bty = "l", xlab = "Talla (cm)", ylab = "Peso (kg)",
     ylim = range(data$Peso) * c(1, 1.18))         # hueco arriba para la leyenda
leyenda <- character()
for (g in names(col)) {                            # recta de todos y de cada sexo
  d <- if (g == "Todos") data else data[data$Sexo == g, ]
  m <- lm(Peso ~ Talla, d); x <- range(d$Talla)
  lines(x, predict(m, data.frame(Talla = x)), col = col[g], lwd = if (g == "Todos") 3 else 2)
  leyenda[g] <- sprintf("%s: r = %.2f, pendiente = %.2f kg/cm", g, cor(d$Talla, d$Peso), coef(m)[2])
}
legend("topleft", leyenda, col = col, lwd = c(3, 2, 2), bty = "n", cex = 0.8)
par(op)
