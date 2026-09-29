# ---------------------------------------------------------------------
# 06_graficos_descriptiva.R
# Gráficos y tablas del bloque 2 (estadística descriptiva), a partir de
# datos/pacientes.csv y datos/categorias.csv.  Genera en img/:
#   d_barras_pastel.pdf    GrupoSang: barras y pastel
#   d_concentracion.pdf    C1..C4: frecuencias relativas
#   tab_concentracion.tex  índices de variables nominales para C1..C4
#   d_histo_anchos.pdf     Colesterol: histogramas con 3 anchos de clase
#   d_histo_poligono.pdf   Talla: histograma, polígono y densidad
#   d_caja_anatomia.pdf    Triglicéridos: anatomía del diagrama de caja
#   d_centralidad.pdf      Triglicéridos: media, mediana, moda / dispersión
#   tab_dispersion.tex     estadísticos de centralidad y dispersión
#   d_estratos.pdf         Talla por Sexo: densidades y cajas/violines
#   tab_estratos.tex       descriptivos de Talla por Sexo
#   tab_contingencia.tex   Sobrepeso x HTA: frecuencias, %, RR, OR, chi2
#
# Ejecutar desde el directorio S1:   Rscript src/06_graficos_descriptiva.R
# ---------------------------------------------------------------------
source("src/estilo_jmv.R")
library(cowplot)
library(e1071)

pac <- read.csv("datos/pacientes.csv")
pac$Sexo <- factor(pac$Sexo, 1:2, c("Hombre", "Mujer"))
pac$IMC  <- pac$Peso / (pac$Talla / 100)^2
cat <- read.csv("datos/categorias.csv")
dir.create("img", showWarnings = FALSE)

moda_kde <- function(x) { d <- density(x, na.rm = TRUE); d$x[which.max(d$y)] }

## 1. Barras y pastel ---------------------------------------------------
gs <- as.data.frame(table(GrupoSang = factor(pac$GrupoSang,
                                             c("A", "B", "AB", "O"))))
gs$pct <- 100 * gs$Freq / sum(gs$Freq)
g1 <- ggplot(gs, aes(GrupoSang, Freq)) +
  geom_col(fill = azul_jmv, colour = borde, linewidth = 0.25, width = 0.7) +
  geom_text(aes(label = sprintf("%d (%.0f%%)", Freq, pct)), vjust = -0.4,
            size = 2.6) +
  scale_y_continuous(expand = expansion(c(0, 0.12))) +
  labs(x = "Grupo sanguíneo", y = "Frecuencia absoluta",
       title = "Diagrama de barras") + tema_jmv
g2 <- ggplot(gs, aes("", Freq, fill = GrupoSang)) +
  geom_col(colour = "white", linewidth = 0.6, width = 1) +
  geom_text(aes(label = sprintf("%s\n%.0f%%", GrupoSang, pct)),
            position = position_stack(vjust = 0.5), size = 2.6) +
  coord_polar(theta = "y") +
  scale_fill_manual(values = c("#A8C6EE", "#E3A33B", "#B9B9B9", "#6E9FD8")) +
  labs(title = "Diagrama de sectores (pastel)") +
  theme_void(base_size = 9) +
  theme(legend.position = "none",
        plot.title = element_text(size = 9, face = "bold", hjust = 0.5))
guarda(plot_grid(g1, g2, rel_widths = c(1.2, 1)), "d_barras_pastel.pdf")

## 2. Concentración de variables nominales -----------------------------
indices <- function(x) {
  p <- as.vector(table(x)) / length(x); k <- length(p)
  H <- -sum(p[p > 0] * log(p[p > 0]))
  c(pmoda = max(p), VR = 1 - max(p), GS = 1 - sum(p^2),
    IQV = k / (k - 1) * (1 - sum(p^2)), H = H, J = H / log(k),
    N2 = 1 / sum(p^2))
}
ind <- sapply(cat[-1], indices)
dc <- do.call(rbind, lapply(names(cat)[-1], function(v) {
  t <- as.data.frame(table(Cat = cat[[v]]))
  data.frame(var = sprintf("%s\nGS = %.2f   H = %.2f",
                           v, ind["GS", v], ind["H", v]),
             Cat = t$Cat, p = t$Freq / nrow(cat))
}))
g <- ggplot(dc, aes(Cat, p)) +
  geom_col(fill = azul_jmv, colour = borde, linewidth = 0.25, width = 0.7) +
  facet_wrap(~var, nrow = 1) +
  scale_y_continuous(limits = c(0, 1), expand = c(0, 0),
                     labels = function(y) paste0(100 * y, "%")) +
  labs(x = NULL, y = "Frecuencia relativa") + tema_jmv +
  theme(strip.text = element_text(size = 7, face = "bold"))
guarda(g, "d_concentracion.pdf", alto = 4.2)

tabla_tex(data.frame(
  Índice = c("Moda", "$p_{moda}$", "Razón de variación $1-p_{moda}$",
             "Gini-Simpson $1-\\sum p_i^2$", "IQV (Gini-Simpson normalizado)",
             "Entropía de Shannon $H$", "Pielou $J = H/\\ln k$",
             "Nº efectivo de categorías $1/\\sum p_i^2$"),
  rbind(rep("A", 4), apply(ind, 2, f2))), "tab_concentracion.tex",
  alin = "lrrrr")
# la primera fila (moda) de C1 no está definida: todas empatan
tab <- readLines("img/tab_concentracion.tex")
tab[grep("^Moda", tab)] <- "Moda & -- & A & A & A \\\\"
writeLines(tab, "img/tab_concentracion.tex")

## 3. Histogramas con distintos anchos de clase ------------------------
col <- na.omit(pac$Colesterol)
histo <- function(ancho, titulo)
  ggplot(data.frame(x = col), aes(x)) +
  geom_histogram(binwidth = ancho, boundary = 100, fill = azul_jmv,
                 colour = borde, linewidth = 0.2) +
  labs(x = "Colesterol (mg/dL)", y = NULL, title = titulo) + tema_jmv
guarda(plot_grid(histo(2,  "Ancho 2 mg/dL\ndemasiado ruido"),
                 histo(15, "Ancho 15 mg/dL\nadecuado"),
                 histo(60, "Ancho 60 mg/dL\nse pierde la forma"),
                 nrow = 1), "d_histo_anchos.pdf", alto = 4.2)

## 4. Histograma, polígono de frecuencias y densidad --------------------
ta <- data.frame(x = pac$Talla)
base <- ggplot(ta, aes(x)) + labs(x = "Talla (cm)", y = NULL) + tema_jmv
h <- geom_histogram(aes(y = after_stat(density)), binwidth = 4, boundary = 140,
                    fill = azul_jmv, colour = borde, linewidth = 0.2)
g1 <- base + h + labs(title = "Histograma")
g2 <- base + h +
  geom_freqpoly(aes(y = after_stat(density)), binwidth = 4, boundary = 140,
                colour = rojo, linewidth = 0.7) +
  geom_point(aes(y = after_stat(density)), stat = "bin", binwidth = 4,
             boundary = 140, colour = rojo, size = 0.8) +
  labs(title = "Polígono de frec.")
g3 <- base + geom_density(fill = azul_jmv, colour = borde, linewidth = 0.6,
                          alpha = 0.7) +
  labs(title = "Curva de densidad")
guarda(plot_grid(g1, g2, g3, nrow = 1), "d_histo_poligono.pdf", alto = 4.2)

## 5. Anatomía del diagrama de caja (Triglicéridos) ---------------------
tg <- na.omit(pac$Trigliceridos)
q <- quantile(tg, c(0.25, 0.5, 0.75)); ric <- q[3] - q[1]
big <- c(min(tg[tg >= q[1] - 1.5 * ric]), max(tg[tg <= q[3] + 1.5 * ric]))
g1 <- ggplot(data.frame(x = tg), aes(x, 0)) +
  geom_boxplot(width = 0.5, fill = azul_jmv, colour = borde,
               outlier.colour = rojo, outlier.size = 1.4) +
  annotate("text", x = q, y = c(0.36, 0.50, 0.36), size = 2.6,
           hjust = c(1, 0.5, 0), label = c("Q1", "Mediana", "Q3")) +
  annotate("segment", x = q[1], xend = q[3], y = -0.40, yend = -0.40,
           arrow = arrow(ends = "both", length = unit(1.5, "mm")),
           colour = azul_osc) +
  annotate("text", x = mean(q[c(1, 3)]), y = -0.52, size = 2.6,
           colour = azul_osc, label = "RIC = Q3 - Q1 (50% central)") +
  annotate("text", x = big[2], y = 0.20, hjust = 0.2, size = 2.4,
           label = "bigote: último dato\n< Q3 + 1.5 RIC") +
  annotate("text", x = max(tg), y = -0.2, hjust = 0.9, size = 2.4,
           colour = rojo, label = "atípicos") +
  scale_y_continuous(limits = c(-0.6, 0.55)) +
  labs(x = "Triglicéridos (mg/dL)", y = NULL,
       title = "Diagrama de caja y bigotes") +
  tema_jmv + theme(axis.text.y = element_blank(), axis.ticks.y = element_blank(),
                   axis.line.y = element_blank())
g2 <- ggplot(data.frame(x = tg), aes(x, 0)) +
  geom_violin(fill = azul_jmv, colour = borde, alpha = 0.7) +
  geom_boxplot(width = 0.12, fill = "white", colour = borde, outlier.shape = NA) +
  geom_jitter(height = 0.08, width = 0, size = 0.3, alpha = 0.4) +
  labs(x = "Triglicéridos (mg/dL)", y = NULL, title = "Violín (+ caja + puntos)") +
  tema_jmv + theme(axis.text.y = element_blank(), axis.ticks.y = element_blank(),
                   axis.line.y = element_blank())
guarda(plot_grid(g1, g2, nrow = 1, rel_widths = c(1.25, 1)),
       "d_caja_anatomia.pdf", alto = 4.6)

## 6. Centralidad y dispersión (Triglicéridos) --------------------------
est <- data.frame(estad = factor(c("Media", "Mediana", "Moda"),
                                 c("Media", "Mediana", "Moda")),
                  valor = c(mean(tg), median(tg), moda_kde(tg)))
hist_tg <- ggplot(data.frame(x = tg), aes(x)) +
  geom_histogram(aes(y = after_stat(density)), binwidth = 15, boundary = 0,
                 fill = azul_jmv, colour = borde, linewidth = 0.2) +
  geom_density(colour = borde, linewidth = 0.5, adjust = 1.3) +
  labs(x = "Triglicéridos (mg/dL)", y = NULL) + tema_jmv +
  theme(axis.text.y = element_blank(), axis.ticks.y = element_blank())
g1 <- hist_tg +
  geom_vline(data = est, aes(xintercept = valor, colour = estad,
                             linetype = estad), linewidth = 0.7) +
  scale_colour_manual(values = c(rojo, azul_osc, verde), name = NULL) +
  scale_linetype_manual(values = c("solid", "dashed", "dotted"), name = NULL) +
  labs(title = "Centralidad")
alto_d <- max(density(tg)$y)
## techo: la barra más alta del histograma (o la densidad, si es mayor)
techo <- max(alto_d, hist(tg, breaks = seq(0, max(tg) + 15, 15),
                          plot = FALSE)$density)
## Cota "de plano": flecha de doble punta entre x0 y x1 a la altura y,
## con un trazo vertical en cada extremo y la etiqueta a la derecha
cota <- function(x0, x1, y, col, etiqueta) {
  h <- 0.05 * alto_d
  list(annotate("segment", x = c(x0, x1), xend = c(x0, x1), y = y - h,
                yend = y + h, colour = col, linewidth = 0.4),
       annotate("segment", x = x0, xend = x1, y = y, yend = y, colour = col,
                linewidth = 0.5,
                arrow = arrow(ends = "both", type = "closed",
                              length = unit(1.4, "mm"), angle = 20)),
       annotate("text", x = x1 + 6, y = y, hjust = 0, size = 2.4,
                colour = col, label = etiqueta))
}
g2 <- hist_tg +
  annotate("rect", xmin = mean(tg) - sd(tg), xmax = mean(tg) + sd(tg),
           ymin = -Inf, ymax = 1.07 * techo, fill = rojo, alpha = 0.12) +
  cota(mean(tg) - sd(tg), mean(tg) + sd(tg), 1.07 * techo, rojo,
       "media ± DE") +
  cota(q[[1]], q[[3]], 1.20 * techo, azul_osc, "RIC (Q1 a Q3)") +
  labs(title = "Dispersión")
guarda(plot_grid(g1, g2, nrow = 1), "d_centralidad.pdf", alto = 4.6)

resumen <- function(x) {
  x <- na.omit(x); q <- quantile(x, c(0.25, 0.5, 0.75))
  c(N = length(x), Media = mean(x), Mediana = q[[2]],
    Rango = diff(range(x)), Q1 = q[[1]], Q3 = q[[3]],
    RIC = q[[3]] - q[[1]], Varianza = var(x), DE = sd(x),
    `CV (\\%)` = 100 * sd(x) / mean(x))
}
r <- sapply(pac[c("Talla", "Colesterol", "Trigliceridos")], resumen)
colnames(r)[3] <- "Triglicéridos"
tabla_tex(data.frame(` ` = rownames(r),
                     apply(r, 2, function(x) c(sprintf("%d", x[1]), f1(x[-1]))),
                     check.names = FALSE), "tab_dispersion.tex")

## 7. Estratificación: Talla por Sexo -----------------------------------
g1 <- ggplot(pac, aes(Talla, fill = Sexo, colour = Sexo)) +
  geom_density(alpha = 0.45, linewidth = 0.5) +
  scale_fill_manual(values = col_grupos) +
  scale_colour_manual(values = c("#2F5F9A", "#A86F12")) +
  labs(x = "Talla (cm)", y = NULL, title = "Densidades por sexo",
       fill = NULL, colour = NULL) + tema_jmv +
  theme(axis.text.y = element_blank(), axis.ticks.y = element_blank())
g2 <- ggplot(pac, aes(Sexo, Talla, fill = Sexo)) +
  geom_violin(alpha = 0.45, colour = NA) +
  geom_boxplot(width = 0.25, colour = borde, outlier.size = 0.8) +
  geom_jitter(width = 0.08, size = 0.3, alpha = 0.4) +
  scale_fill_manual(values = col_grupos) +
  labs(x = NULL, y = "Talla (cm)", title = "Cajas y violines por sexo") +
  tema_jmv + theme(legend.position = "none")
guarda(plot_grid(g1, g2, nrow = 1, rel_widths = c(1.3, 1)), "d_estratos.pdf")

por_sexo <- sapply(split(pac$Talla, pac$Sexo), function(x) {
  q <- quantile(x, c(0.25, 0.75))
  c(sprintf("%d", length(x)), f1(mean(x)), f1(median(x)), f2(sd(x)),
    f1(q[[2]] - q[[1]]), f2(skewness(x, type = 2)), f2(kurtosis(x, type = 2)))
})
tabla_tex(data.frame(Talla = c("N", "Media", "Mediana", "DE", "RIC",
                               "Asimetría", "Curtosis"), por_sexo,
                     check.names = FALSE), "tab_estratos.tex")

## 8. Tabla de contingencia: Sobrepeso x HTA ----------------------------
pac$Sobrepeso <- factor(pac$IMC >= 25, c(FALSE, TRUE),
                        c("No (IMC $<$ 25)", "Sí (IMC $\\ge$ 25)"))
pac$HTAf <- factor(pac$HTA, 0:1, c("No", "Sí"))
t <- table(pac$Sobrepeso, pac$HTAf)
pf <- prop.table(t, 1)
fila <- function(i) c(rownames(t)[i],
                      sprintf("%d (%.1f\\%%)", t[i, ], 100 * pf[i, ]),
                      sprintf("%d", sum(t[i, ])))
tot <- c("Total", sprintf("%d (%.1f\\%%)", colSums(t), 100 * colSums(t) / sum(t)),
         sprintf("%d", sum(t)))
r1  <- pf[2, 2]; r0 <- pf[1, 2]            # riesgo en expuestos / no expuestos
rr  <- r1 / r0; ra <- r1 - r0
or  <- (t[2, 2] * t[1, 1]) / (t[2, 1] * t[1, 2])
chi <- chisq.test(t, correct = FALSE)
tabla_tex(setNames(data.frame(rbind(fila(1), fila(2), tot)),
                   c("Sobrepeso", "HTA No", "HTA Sí", "Total")),
          "tab_contingencia.tex", alin = "lrrr")
writeLines(sprintf(paste0(
  "$R_1 = %d/%d = %.3f$ \\quad $R_0 = %d/%d = %.3f$ \\quad ",
  "$\\chi^2 = %.2f$ (gl = 1, p %s)\\\\[2mm]\n",
  "RR $= R_1 / R_0 = %.2f$ \\quad RA $= R_1 - R_0 = %.3f$ \\quad ",
  "OR $= \\frac{%d \\times %d}{%d \\times %d} = %.2f$"),
  t[2, 2], sum(t[2, ]), r1, t[1, 2], sum(t[1, ]), r0,
  chi$statistic, ifelse(chi$p.value < 0.001, "< 0.001",
                        sprintf("= %.3f", chi$p.value)),
  rr, ra, t[2, 2], t[1, 1], t[2, 1], t[1, 2], or), "img/tab_contingencia_ind.tex")
cat(sprintf("RR = %.2f  RA = %.3f  OR = %.2f  chi2 = %.2f\n", rr, ra, or, chi$statistic))
