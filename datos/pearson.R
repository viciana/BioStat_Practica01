# Misma recta (misma a y b) con distinta dispersión alrededor: r mide
# el ajuste a la recta, no la recta en sí. No usa ningún data.set de la
# práctica: la nube se simula aquí mismo, con semilla fija.
set.seed(42)
n <- 120
a <- 50; b <- 1.5
x <- rnorm(n, 50, 10)

sd1 <- 6    # dispersión pequeña -> r alto
sd2 <- 40   # dispersión grande  -> r bajo

y1 <- a + b * x + rnorm(n, 0, sd1)
y2 <- a + b * x + rnorm(n, 0, sd2)

r1 <- cor(x, y1)
r2 <- cor(x, y2)

op <- par(mfrow = c(1, 2), oma = c(0, 0, 2.2, 0),
          mar = c(3, 3.2, 1.6, 0.8), mgp = c(1.8, 0.6, 0),
          cex.axis = 0.8, cex.lab = 0.9)

ylim <- range(c(y1, y2))

plot(x, y1, pch = 21, bg = "#A8C6EE", col = "grey30", cex = 0.8, las = 1,
     bty = "l", ylim = ylim, xlab = "X", ylab = "Y",
     main = sprintf("r = %.2f", r1))
abline(a, b, col = "#C0392B", lwd = 2)

plot(x, y2, pch = 21, bg = "#A8C6EE", col = "grey30", cex = 0.8, las = 1,
     bty = "l", ylim = ylim, xlab = "X", ylab = "Y",
     main = sprintf("r = %.2f", r2))
abline(a, b, col = "#C0392B", lwd = 2)

mtext(sprintf("Misma recta en los dos paneles: Y = %.0f + %.1f X", a, b),
      outer = TRUE, side = 3, line = 0.6, cex = 0.95, font = 2)
par(op)
