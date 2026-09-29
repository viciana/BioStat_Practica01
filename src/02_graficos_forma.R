# ---------------------------------------------------------------------
# 02_graficos_forma.R
# Gráficos y tabla para las diapositivas de medidas de forma, a partir
# de datos/forma.csv (generado por 01_simula_forma.R).  Genera en img/:
#     asimetria.pdf   V2 / V1 / V3 con media, mediana y moda
#     curtosis.pdf    V4 / V5 / V6 frente a la normal de igual media y DE
#     otras.pdf       V7 / V8 (bimodal y uniforme) con diagrama de caja
#     tab_forma.tex   tabla de descriptivos al estilo de jamovi
#
# Ejecutar desde el directorio S1:   Rscript src/02_graficos_forma.R
# ---------------------------------------------------------------------
library(ggplot2)
library(e1071)

forma <- read.csv("datos/forma.csv")
dir.create("img", showWarnings = FALSE)

## Estilo "jamovi" -----------------------------------------------------
azul_jmv <- "#A8C6EE"                 # relleno de histogramas de jamovi
borde    <- "#333333"
col_est  <- c(Media = "#C0392B", Mediana = "#1F4E9A", Moda = "#1E8449")
lty_est  <- c(Media = "solid",   Mediana = "dashed",  Moda = "dotted")
tema <- theme_classic(base_size = 9) +
  theme(strip.background = element_blank(),
        strip.text       = element_text(size = 8.5, face = "bold"),
        axis.text.y      = element_blank(),
        axis.ticks.y     = element_blank(),
        legend.position  = "bottom",
        legend.key.width = unit(1.2, "lines"),
        legend.margin    = margin(0, 0, 0, 0),
        legend.box.spacing = unit(1, "pt"),
        plot.margin      = margin(2, 4, 2, 2))
lim_x <- range(forma[-1]) + c(-3, 3)          # eje común a todos
cortes <- seq(lim_x[1], lim_x[2] + 3.5, by = 3.5)

G1 <- function(x) skewness(x, type = 2)   # como jamovi / SPSS
G2 <- function(x) kurtosis(x, type = 2)
moda_kde <- function(x) { d <- density(x, adjust = 1.3); d$x[which.max(d$y)] }

## Pasa a formato largo las variables elegidas, con etiqueta de panel
largo <- function(vars, etiquetas, stat, fmt) {
  do.call(rbind, lapply(seq_along(vars), function(i) {
    x <- forma[[vars[i]]]
    data.frame(panel = sprintf(fmt, vars[i], etiquetas[i], stat(x)), x = x)
  })) |> transform(panel = factor(panel, levels = unique(panel)))
}

## Curva normal de igual media y DE para cada panel
normal_ref <- function(d) {
  do.call(rbind, lapply(split(d, d$panel), function(s) {
    xx <- seq(lim_x[1], lim_x[2], length.out = 300)
    data.frame(panel = s$panel[1], x = xx,
               y = dnorm(xx, mean(s$x), sd(s$x)))
  }))
}

histo <- function(d) {
  ggplot(d, aes(x)) +
    geom_histogram(aes(y = after_stat(density)), breaks = cortes,
                   fill = azul_jmv, colour = borde, linewidth = 0.2) +
    geom_density(colour = borde, linewidth = 0.6, adjust = 1.3) +
    coord_cartesian(xlim = lim_x, expand = FALSE, clip = "off") +
    scale_x_continuous(breaks = seq(20, 80, by = 20)) +
    labs(x = NULL, y = NULL) + tema
}

## 1. Asimetría --------------------------------------------------------
d_as <- largo(c("V2", "V1", "V3"),
              c("Asimetría positiva", "Simétrica", "Asimetría negativa"),
              G1, "%s: %s\nG1 = %.2f")
est <- do.call(rbind, lapply(split(d_as, d_as$panel), function(s)
  data.frame(panel = s$panel[1],
             estad = names(col_est),
             valor = c(mean(s$x), median(s$x), moda_kde(s$x)))))
est$estad <- factor(est$estad, levels = names(col_est))

g <- histo(d_as) +
  geom_vline(data = est, aes(xintercept = valor, colour = estad,
                             linetype = estad), linewidth = 0.7) +
  scale_colour_manual(values = col_est, name = NULL) +
  scale_linetype_manual(values = lty_est, name = NULL) +
  facet_wrap(~panel, nrow = 1) +
  theme(legend.position = "none")   # la leyenda va en el texto de la diapositiva
ggsave("img/asimetria.pdf", g, width = 12, height = 3.9, units = "cm",
       device = cairo_pdf)

## 2. Curtosis ---------------------------------------------------------
d_cu <- largo(c("V4", "V5", "V6"),
              c("Leptocúrtica", "Mesocúrtica", "Platicúrtica"),
              G2, "%s: %s  (G2 = %.2f)")
g <- histo(d_cu) +
  geom_line(data = normal_ref(d_cu), aes(x, y), colour = "#C0392B",
            linetype = "dashed", linewidth = 0.6) +
  facet_wrap(~panel, ncol = 1)
ggsave("img/curtosis.pdf", g, width = 6.2, height = 7, units = "cm",
       device = cairo_pdf)

## 3. Otras formas: bimodal y uniforme ---------------------------------
d_ot <- largo(c("V7", "V8"), c("Bimodal", "Uniforme"),
              G2, "%s: %s  (G2 = %.2f)")
alto <- max(density(forma$V7)$y, density(forma$V8)$y)
g <- histo(d_ot) +
  geom_line(data = normal_ref(d_ot), aes(x, y), colour = "#C0392B",
            linetype = "dashed", linewidth = 0.6) +
  # diagrama de caja horizontal bajo cada histograma (como en jamovi)
  geom_boxplot(aes(y = -0.18 * alto), width = 0.14 * alto, fill = azul_jmv,
               colour = borde, linewidth = 0.3, outlier.size = 0.6) +
  geom_jitter(aes(y = -0.18 * alto), height = 0.04 * alto, width = 0,
              size = 0.25, alpha = 0.5, colour = borde) +
  facet_wrap(~panel, nrow = 1)
ggsave("img/otras.pdf", g, width = 11, height = 5, units = "cm",
       device = cairo_pdf)

## 4. Tabla de descriptivos (como la muestra jamovi) -------------------
vars <- paste0("V", 1:8)
n <- nrow(forma)
ee_g1 <- sqrt(6 * n * (n - 1) / ((n - 2) * (n + 1) * (n + 3)))
ee_g2 <- 2 * ee_g1 * sqrt((n^2 - 1) / ((n - 3) * (n + 5)))
filas <- list(
  "N"                   = sapply(vars, \(v) sprintf("%d", n)),
  "Media"               = sapply(vars, \(v) sprintf("%.1f", mean(forma[[v]]))),
  "Mediana"             = sapply(vars, \(v) sprintf("%.1f", median(forma[[v]]))),
  "Desviación estándar" = sapply(vars, \(v) sprintf("%.2f", sd(forma[[v]]))),
  "Asimetría"           = sapply(vars, \(v) sprintf("%.2f", G1(forma[[v]]))),
  "EE asimetría"        = sapply(vars, \(v) sprintf("%.3f", ee_g1)),
  "Curtosis"            = sapply(vars, \(v) sprintf("%.2f", G2(forma[[v]]))),
  "EE curtosis"         = sapply(vars, \(v) sprintf("%.3f", ee_g2))
)
tex <- c("\\begin{tabular}{l*{8}{r}}", "\\toprule",
         paste0(" & ", paste(vars, collapse = " & "), " \\\\"), "\\midrule",
         sprintf("%s & %s \\\\", names(filas),
                 sapply(filas, paste, collapse = " & ")),
         "\\bottomrule", "\\end{tabular}")
writeLines(tex, "img/tab_forma.tex")
