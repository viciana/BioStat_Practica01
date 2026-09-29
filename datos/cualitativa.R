# Gráficos de GrupoSang en el editor Rj de JAMOVI (los datos están en 'data')
x <- table(data$GrupoSang); n <- sum(x); f <- as.vector(x) / n; k <- seq_along(f)
layout(matrix(1:2, 1), widths = c(2, 1))          # puntos: el doble de ancho
op <- par(mar = c(4, 4, 2, 7))                    # margen dcho.: separa el pastel
# 1. Puntos con líneas: frecuencia relativa (eje izquierdo) y absoluta (derecho)
plot(k, f, type = "h", lwd = 3, col = "grey60", xaxt = "n", xlim = c(0.5, max(k) + 0.5),
     ylim = c(0, 1.1 * max(f)), xlab = "Grupo sanguíneo", ylab = "Frecuencia relativa")
points(k, f, pch = 19, cex = 2.2, col = "steelblue"); axis(1, k, names(x))
axis(4, pretty(c(0, x)) / n, pretty(c(0, x))); mtext("Frecuencia absoluta", 4, 2.5)
# 2. Diagrama de sectores (girado: los sectores pequeños a la derecha)
par(mar = c(1, 0, 2, 0), xpd = NA)
pie(x, labels = sprintf("%s\n%.0f%%", names(x), 100 * f), col = hcl.colors(length(x), "Set 2"),
    border = "white", clockwise = TRUE, init.angle = 180, radius = 0.72,
    main = "Grupo sanguíneo")
par(op)
