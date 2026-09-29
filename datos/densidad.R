# Talla (pacientes.omv): histograma, polígono de frecuencias y curva de densidad
# En Rj (JAMOVI) los datos ya están en 'data'; en R se descargan de la web
if (!is.data.frame(data)) {
  fic <- tempfile(fileext = ".omv")
  download.file("https://epidemos.es/bs2026/pacientes.omv", fic, mode = "wb")
  data <- jmvReadWrite::read_omv(fic)
}
x <- na.omit(data$Talla)
h <- hist(x, breaks = seq(140, 200, by = 4), plot = FALSE)   # clases de 4 cm
d <- density(x)                                              # curva suavizada
fondo <- function(titulo, relleno = NA)                      # histograma de fondo
  plot(h, freq = FALSE, col = relleno, border = "grey40", las = 1, ylab = "",
       ylim = c(0, 1.05 * max(h$density, d$y)), xlab = "Talla (cm)", main = titulo)
op <- par(mfrow = c(1, 3), mar = c(4, 3, 3, 1))
fondo("Histograma", "#A8C6EE")
fondo("Polígono de frecuencias")                             # une los puntos medios
m <- h$mids; a <- 4
polygon(c(m[1] - a, m, max(m) + a), c(0, h$density, 0),
        col = adjustcolor("firebrick", 0.3), border = "firebrick", lwd = 2)
points(m, h$density, pch = 19, col = "firebrick")
fondo("Curva de densidad")
polygon(d, col = adjustcolor("steelblue", 0.4), border = "steelblue", lwd = 2)
par(op)
