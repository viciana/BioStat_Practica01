# ---------------------------------------------------------------------
# estilo_jmv.R
# Estilo común de los gráficos (imita el aspecto de jamovi) y funciones
# auxiliares para escribir tablas LaTeX.  Se carga con source().
# ---------------------------------------------------------------------
library(ggplot2)

azul_jmv <- "#A8C6EE"                 # relleno de histogramas de jamovi
borde    <- "#333333"
rojo     <- "#C0392B"
azul_osc <- "#1F4E9A"
verde    <- "#1E8449"
# dos grupos (p. ej. Hombre / Mujer): azul y ámbar de jamovi
col_grupos <- c("#6E9FD8", "#E3A33B")

tema_jmv <- theme_classic(base_size = 9) +
  theme(strip.background = element_blank(),
        strip.text       = element_text(size = 8.5, face = "bold"),
        plot.title       = element_text(size = 9, face = "bold", hjust = 0.5),
        legend.position  = "bottom",
        legend.margin    = margin(0, 0, 0, 0),
        plot.margin      = margin(3, 6, 3, 3))

guarda <- function(g, fichero, ancho = 11, alto = 4.6)
  ggsave(file.path("img", fichero), g, width = ancho, height = alto,
         units = "cm", device = cairo_pdf)

## Tabla LaTeX (booktabs) a partir de un data.frame de texto -----------
tabla_tex <- function(df, fichero, alin = NULL, nota = NULL) {
  if (is.null(alin)) alin <- paste0("l", strrep("r", ncol(df) - 1))
  tex <- c(sprintf("\\begin{tabular}{%s}", alin), "\\toprule",
           paste(paste(names(df), collapse = " & "), "\\\\"), "\\midrule",
           apply(df, 1, function(f) paste(paste(f, collapse = " & "), "\\\\")),
           "\\bottomrule", "\\end{tabular}", nota)
  writeLines(tex, file.path("img", fichero))
}

## Formato numérico con punto decimal, como lo muestra jamovi en clase
f1 <- function(x) sprintf("%.1f", x)
f2 <- function(x) sprintf("%.2f", x)
f3 <- function(x) sprintf("%.3f", x)
