# pacientes.omv: HTA (0/1) según la Edad; la recta se sale de [0, 1], la logística no
# En Rj (JAMOVI) los datos ya están en 'data'; en R se descargan de la web
if (!is.data.frame(data)) {
  fic <- tempfile(fileext = ".omv")
  download.file("https://epidemos.es/bs2026/pacientes.omv", fic, mode = "wb")
  data <- jmvReadWrite::read_omv(fic)
}
y <- as.numeric(data$HTA == "Sí"); x <- data$Edad          # HTA: 1 = Sí, 0 = No
recta <- lm(y ~ x); logis <- glm(y ~ x, family = binomial)
op <- par(mar = c(3, 3, 0.5, 0.5), mgp = c(1.8, 0.6, 0), cex.axis = 0.8, cex.lab = 0.9)
plot(x, y + runif(length(y), -0.04, 0.04), xlim = c(0, 110), ylim = c(-0.2, 1.2),
     pch = 21, bg = "#A8C6EE", col = "grey30", cex = 0.7, las = 1, bty = "l",
     xlab = "Edad", ylab = "HTA (0/1) y P(HTA)")
abline(h = 0:1, lty = 3, col = "grey50")
abline(recta, col = "steelblue", lwd = 2)                   # se sale de [0, 1]
e <- 0:110
lines(e, predict(logis, data.frame(x = e), type = "response"), col = "firebrick", lwd = 2)
legend(66, 0.45, c("Recta", "Logística"), col = c("steelblue", "firebrick"), lwd = 2,
       bty = "n", cex = 0.8)
par(op)
