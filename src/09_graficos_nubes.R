# ---------------------------------------------------------------------
# 09_graficos_nubes.R
# Gráficos y tablas del bloque 3 (correlación y regresión) a partir de
# datos/nubes.csv y datos/pacientes.csv.  Genera en img/:
#     n_formas.pdf       las 4 formas de nube del guion (Y1, Y2, Y3, Y5)
#     n_recta.pdf        recta de regresión de Y4 ~ X y su pendiente
#     n_transforma.pdf   Y6 ~ X antes y después de log10(Y6)
#     n_polinomio.pdf    Y5 ~ X: recta frente a parábola
#     n_atipicos.pdf     Y7 ~ X: Pearson frente a Spearman
#     n_estratos.pdf     Peso ~ Talla por Sexo (pacientes)
#     n_logistica.pdf    HTA (0/1) ~ Edad: recta frente a curva logística
#     tab_nubes.tex      r, rho y R² de cada nube
#
# Ejecutar desde el directorio S1:   Rscript src/09_graficos_nubes.R
# ---------------------------------------------------------------------
source("src/estilo_jmv.R")

nubes <- read.csv("datos/nubes.csv")
pac   <- read.csv("datos/pacientes.csv")

## Puntos como el gráfico de dispersión de jamovi
puntos <- geom_point(shape = 21, size = 1.3, stroke = 0.3,
                     fill = azul_jmv, colour = borde)
rotulo <- function(txt) annotate("label", x = -Inf, y = Inf, label = txt,
                                 hjust = -0.05, vjust = 1.1, size = 2.6,
                                 label.size = 0, fill = "white", alpha = 0.8)
r2   <- function(m) summary(m)$r.squared
decs <- function(x) formatC(x, format = "f", digits = 2, decimal.mark = ".")

## 1. Las cuatro formas del guion ---------------------------------------
titulos <- c(Y1 = "Ruido (sin relación)", Y2 = "Correlación positiva",
             Y3 = "Correlación negativa", Y5 = "Relación parabólica")
largo <- do.call(rbind, lapply(names(titulos), \(v)
  data.frame(v = v, X = nubes$X, Y = nubes[[v]])))
largo$v <- factor(largo$v, names(titulos),
                  sprintf("%s: %s", names(titulos), titulos))
etq <- do.call(rbind, lapply(split(largo, largo$v), \(d)
  data.frame(v = d$v[1], txt = sprintf("r = %s", decs(cor(d$X, d$Y))))))
g <- ggplot(largo, aes(X, Y)) + puntos +
  geom_label(data = etq, aes(x = -Inf, y = Inf, label = txt),
             hjust = -0.05, vjust = 1.1, size = 2.6, label.size = 0,
             fill = "white", alpha = 0.8) +
  facet_wrap(~ v, ncol = 2, scales = "free_y") +
  labs(x = "X", y = NULL) + tema_jmv
guarda(g, "n_formas.pdf", ancho = 11, alto = 7)

## 2. Recta de regresión Y4 ~ X y significado de la pendiente -----------
m4 <- lm(Y4 ~ X, nubes)
a <- coef(m4)[1]; b <- coef(m4)[2]
x0 <- 20; x1 <- 30                        # escalón de 10 en X (zona con pocos puntos)
esc <- data.frame(x = c(x0, x1, x1), y = a + b * c(x0, x0, x1))
g <- ggplot(nubes, aes(X, Y4)) + puntos +
  geom_smooth(method = "lm", formula = y ~ x, se = FALSE,
              colour = rojo, linewidth = 0.7) +
  geom_path(data = esc, aes(x, y), colour = azul_osc, linewidth = 0.6) +
  annotate("label", x = (x0 + x1) / 2, y = a + b * x0, vjust = 1.3, size = 2.6,
           colour = azul_osc, label = "+10 en X", label.size = 0) +
  annotate("label", x = x1, y = a + b * (x0 + x1) / 2, hjust = -0.08, size = 2.6,
           colour = azul_osc, label = sprintf("+%s en Y", decs(10 * b)), label.size = 0) +
  rotulo(sprintf("Y4 = %s + %s X\nR² = %s", decs(a), decs(b), decs(r2(m4)))) +
  tema_jmv
guarda(g, "n_recta.pdf", ancho = 7, alto = 5.5)

## 3. Transformación de escala: Y6 y log10(Y6) --------------------------
m6  <- lm(Y6 ~ X, nubes)
m6l <- lm(log10(Y6) ~ X, nubes)
recta <- geom_smooth(method = "lm", formula = y ~ x, se = FALSE,
                     colour = rojo, linewidth = 0.7)
g1 <- ggplot(nubes, aes(X, Y6)) + puntos + recta +
  rotulo(sprintf("R² = %s", decs(r2(m6)))) +
  labs(title = "Escala original") + tema_jmv
g2 <- ggplot(nubes, aes(X, log10(Y6))) + puntos + recta +
  rotulo(sprintf("R² = %s", decs(r2(m6l)))) +
  labs(title = "Escala logarítmica", y = "log10(Y6)") + tema_jmv
guarda(cowplot::plot_grid(g1, g2, nrow = 1), "n_transforma.pdf",
       ancho = 11, alto = 4.6)

## 4. Regresión polinómica: Y5 ~ X y Y5 ~ X + X² ------------------------
m5  <- lm(Y5 ~ X, nubes)
m5q <- lm(Y5 ~ X + I(X^2), nubes)
g <- ggplot(nubes, aes(X, Y5)) + puntos +
  geom_smooth(method = "lm", formula = y ~ x, se = FALSE,
              aes(colour = "Recta"), linewidth = 0.7) +
  geom_smooth(method = "lm", formula = y ~ x + I(x^2), se = FALSE,
              aes(colour = "Parábola"), linewidth = 0.7) +
  scale_colour_manual(NULL, values = c(Recta = azul_osc, "Parábola" = rojo),
                      breaks = c("Recta", "Parábola"),
                      labels = c(sprintf("Recta (R² = %s)", decs(r2(m5))),
                                 sprintf("Parábola (R² = %s)", decs(r2(m5q))))) +
  tema_jmv
guarda(g, "n_polinomio.pdf", ancho = 7, alto = 5.5)

## 5. Atípicos: Pearson frente a Spearman -------------------------------
o <- order(nubes$X)
nubes$atipico <- seq_len(nrow(nubes)) %in% c(head(o, 3), tail(o, 3))
g <- ggplot(nubes, aes(X, Y7)) +
  geom_point(aes(fill = atipico), shape = 21, size = 1.3, stroke = 0.3,
             colour = borde, show.legend = FALSE) +
  scale_fill_manual(values = c(`FALSE` = azul_jmv, `TRUE` = rojo)) +
  rotulo(sprintf("Pearson  r = %s\nSpearman ρ = %s",
                 decs(cor(nubes$X, nubes$Y7)),
                 decs(cor(nubes$X, nubes$Y7, method = "spearman")))) +
  tema_jmv
guarda(g, "n_atipicos.pdf", ancho = 7, alto = 5.5)

## 6. Nube estratificada: Peso ~ Talla por Sexo -------------------------
pac$Sexo <- factor(pac$Sexo, 1:2, c("Hombre", "Mujer"))
g <- ggplot(pac, aes(Talla, Peso, fill = Sexo, colour = Sexo)) +
  geom_point(shape = 21, size = 1.3, stroke = 0.3, colour = borde) +
  geom_smooth(method = "lm", formula = y ~ x, se = FALSE, linewidth = 0.7) +
  scale_fill_manual(values = col_grupos) +
  scale_colour_manual(values = col_grupos) +
  labs(x = "Talla (cm)", y = "Peso (kg)") + tema_jmv
guarda(g, "n_estratos.pdf", ancho = 7, alto = 5.5)

## 7. Regresión logística: HTA (0/1) ~ Edad -----------------------------
set.seed(1)                                    # solo para el "jitter"
gl <- glm(HTA ~ Edad, binomial, pac)
curva <- data.frame(Edad = seq(0, 110, 0.5))  # fuera del rango: la recta se sale de [0, 1]
curva$p <- predict(gl, curva, type = "response")
g <- ggplot(pac, aes(Edad, HTA)) +
  geom_jitter(width = 0, height = 0.04, shape = 21, size = 1.3, stroke = 0.3,
              fill = azul_jmv, colour = borde) +
  geom_smooth(method = "lm", formula = y ~ x, se = FALSE, fullrange = TRUE,
              aes(colour = "Recta"), linewidth = 0.7) +
  geom_line(data = curva, aes(Edad, p, colour = "Logística"), linewidth = 0.7) +
  geom_hline(yintercept = c(0, 1), linetype = "dotted", colour = "grey50") +
  scale_colour_manual(NULL, values = c(Recta = azul_osc, "Logística" = rojo),
                      breaks = c("Recta", "Logística")) +
  scale_x_continuous(limits = c(0, 110), breaks = seq(0, 100, 25)) +
  scale_y_continuous(breaks = c(0, 0.25, 0.5, 0.75, 1)) +
  labs(y = "HTA (0/1) y P(HTA)") + tema_jmv
guarda(g, "n_logistica.pdf", ancho = 7, alto = 5.5)

## 8. Tabla resumen de las nubes ----------------------------------------
ys <- paste0("Y", 1:7)
tab <- data.frame(
  Var      = ys,
  Pearson  = sapply(ys, \(v) f2(cor(nubes$X, nubes[[v]]))),
  Spearman = sapply(ys, \(v) f2(cor(nubes$X, nubes[[v]], method = "spearman"))),
  R2       = sapply(ys, \(v) f2(r2(lm(nubes[[v]] ~ nubes$X)))),
  R2q      = sapply(ys, \(v) f2(r2(lm(nubes[[v]] ~ nubes$X + I(nubes$X^2))))))
names(tab) <- c("Variable", "Pearson $r$", "Spearman $\\rho$",
                "$R^2$ recta", "$R^2$ parábola")
tabla_tex(tab, "tab_nubes.tex")
print(tab, row.names = FALSE)
