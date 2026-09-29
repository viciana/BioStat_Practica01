# Triglicéridos (pacientes.omv): diagrama de caja y bigotes, y violín
# En Rj (JAMOVI) los datos ya están en 'data'; en R se descargan de la web
if (!is.data.frame(data)) {
  fic <- tempfile(fileext = ".omv")
  download.file("https://epidemos.es/bs2026/pacientes.omv", fic, mode = "wb")
  data <- jmvReadWrite::read_omv(fic)
}
x <- na.omit(data$Trigliceridos)
q <- quantile(x, c(0.25, 0.5, 0.75)); bigote <- max(x[x <= q[3] + 1.5 * (q[3] - q[1])])
op <- par(mfrow = c(1, 2), mar = c(3, 0.5, 2, 0.5), mgp = c(1.8, 0.6, 0), xpd = NA,
          cex.axis = 0.8, cex.lab = 0.85, cex.main = 0.95)
# 1. Caja y bigotes, con sus partes señaladas
boxplot(x, horizontal = TRUE, col = "#A8C6EE", outcol = "firebrick", outpch = 19,
        boxwex = 0.5, xlim = c(0.4, 1.6), ylim = c(0, 320), frame = FALSE,
        xlab = "Triglicéridos (mg/dL)", main = "Caja y bigotes")
text(q, c(1.3, 1.35, 1.3), c("Q1", "Mediana", "Q3"), pos = c(2, 3, 4), cex = 0.65)
text(bigote + 15, 1.1, "bigote: último dato\n< Q3 + 1.5 RIC", pos = 3, cex = 0.55)
text(max(x), 1, "atípicos", pos = 1, offset = 1, cex = 0.65, col = "firebrick")
arrows(q[1], 0.65, q[3], 0.65, code = 3, angle = 90, length = 0.04, col = "steelblue")
text(mean(q[-2]), 0.65, "RIC = Q3 - Q1 (50% central)", pos = 1, cex = 0.65, col = "steelblue")
# 2. Violín: la curva de densidad en espejo, con la caja y los puntos encima
d <- density(x); y <- 0.4 * d$y / max(d$y)
plot(NA, xlim = c(0, 320), ylim = c(0.5, 1.5), yaxt = "n", ylab = "", bty = "n",
     xlab = "Triglicéridos (mg/dL)", main = "Violín (+ caja + puntos)")
polygon(c(d$x, rev(d$x)), c(1 + y, rev(1 - y)), col = "#A8C6EE", border = "grey30")
boxplot(x, horizontal = TRUE, add = TRUE, boxwex = 0.2, col = "white", outline = FALSE, axes = FALSE)
points(x, 1 + runif(length(x), -0.06, 0.06), pch = 19, cex = 0.3, col = adjustcolor(1, 0.4))
par(op)
