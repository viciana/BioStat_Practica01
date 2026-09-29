# Triglicéridos (pacientes.omv): medidas de centralidad y de dispersión
# En Rj (JAMOVI) los datos ya están en 'data'; en R se descargan de la web
if (!is.data.frame(data)) {
  fic <- tempfile(fileext = ".omv")
  download.file("https://epidemos.es/bs2026/pacientes.omv", fic, mode = "wb")
  data <- jmvReadWrite::read_omv(fic)
}
x <- na.omit(data$Trigliceridos)
cortes <- seq(0, 330, by = 15); d <- density(x, adjust = 1.3)
m <- mean(x); s <- sd(x); q <- quantile(x, c(0.25, 0.75))
moda <- d$x[which.max(d$y)]                                   # moda: pico de la densidad
top <- max(d$y, hist(x, cortes, plot = FALSE)$density)        # barra más alta
fondo <- function(titulo) {                                   # histograma + densidad
  hist(x, cortes, freq = FALSE, col = "#A8C6EE", border = "grey30", axes = FALSE,
       ylab = "", ylim = c(0, 1.35 * top), xlab = "Triglicéridos (mg/dL)", main = titulo)
  axis(1); lines(d, lwd = 2)                                  # sin eje de densidades
}
cota <- function(x0, x1, y, col, texto) {                     # flecha doble con topes
  arrows(x0, y, x1, y, code = 3, length = 0.06, angle = 20, col = col, lwd = 1.5)
  segments(c(x0, x1), y - 0.04 * top, c(x0, x1), y + 0.04 * top, col = col, lwd = 1.5)
  text(x1, y, texto, pos = 4, col = col, cex = 0.8)
}
op <- par(mfrow = c(1, 2), mar = c(3, 0.5, 2, 0.5), mgp = c(1.8, 0.6, 0), xpd = NA,
          cex.axis = 0.8, cex.lab = 0.85, cex.main = 0.95)
# 1. Centralidad: media, mediana y moda
fondo("Centralidad")
segments(c(m, median(x), moda), 0, y1 = 1.1 * top, lwd = 2, lty = 1:3,
         col = c("firebrick", "steelblue", "darkgreen"))
legend("topright", c("Media", "Mediana", "Moda"), lty = 1:3, lwd = 2, bty = "n",
       col = c("firebrick", "steelblue", "darkgreen"), cex = 0.8)
# 2. Dispersión: media ± DE (franja) y RIC
fondo("Dispersión")
rect(m - s, 0, m + s, 1.1 * top, col = adjustcolor("firebrick", 0.15), border = NA)
cota(m - s, m + s, 1.12 * top, "firebrick", "media ± DE")
cota(q[1], q[2], 1.28 * top, "steelblue", "RIC (Q1 a Q3)")
par(op)
