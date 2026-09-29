# Práctica 1 de Bioestadística: Estadística descriptiva con JAMOVI

Presentación (org-mode → beamer → PDF) de la primera práctica de
Bioestadística de 2º de Medicina, curso 2026-2027 (Fco. Viciana).
Contenidos: introducción a los datos y a JAMOVI, estadística descriptiva
de una y dos variables, correlación y regresión.

El repositorio contiene **solo las fuentes**. Los datos, los gráficos, las
capturas anotadas y el PDF se regeneran desde cero con `make`.

## Compilar

```sh
make          # datos, gráficos, capturas anotadas y practica01.pdf
make clean    # borra todo lo generado
```

`make datos`, `make graficos`, `make capturas` y `make pdf` generan cada
parte por separado (ver `Makefile`). Los datos se simulan con semillas
fijas: se obtienen siempre los mismos ficheros.

## Estructura

| Carpeta / fichero  | Contenido |
|--------------------|-----------|
| `practica01.org`   | La presentación (Org + beamer) |
| `myconfbeamer.org` | Configuración de beamer (tema, paquetes) |
| `Makefile`         | Encadena todo el proceso |
| `src/01…09`        | Simulación de los datos (`01`, `03`, `05`, `07`, `08`) y gráficos y tablas en R (`02`, `06`, `09`) |
| `src/04_anota_capturas.sh` | Recorta y anota las capturas de JAMOVI (ImageMagick) |
| `src/10…12_*.tex`  | Figuras y tablas en LaTeX + TikZ independientes (tipos de variables, tres patas, tabla de datos) |
| `src/13…29_rj_*.R` | Ejecutan los scripts de `datos/*.R` para obtener las figuras de la presentación |
| `src/captura.sh`, `src/rafaga.sh` | Utilidades para capturar la ventana de JAMOVI (X11) |
| `datos/*.R`        | Código R para los alumnos: reproduce cada gráfico en **R** o en el editor **Rj** de JAMOVI |
| `capturas/`        | Capturas de JAMOVI en bruto (hechas a mano; no regenerables) |
| `recursos/`        | Imágenes de la edición anterior e iconos de JAMOVI (no regenerables) |

## Datos (generados en `datos/`)

| Fichero | Contenido |
|---------|-----------|
| `pacientes.csv`, `pacientes.omv` | 200 pacientes simulados (sexo, edad, peso, talla, PAS, HTA…); el CSV va sin etiquetas, para prepararlo en JAMOVI |
| `analitica.csv` | Analítica de 180 de los pacientes (para explicar la fusión de tablas) |
| `soluciones.omv` | `pacientes` tras el Ejercicio 01, con variables calculadas y transformadas |
| `categorias.omv` | Cuatro variables nominales con distinta diversidad (C1–C4) |
| `forma.omv` | Ocho variables con distintas formas: asimetría, curtosis, bimodal, uniforme (V1–V8) |
| `nubes.omv` | Una X común y siete respuestas con distintas nubes de puntos (Y1–Y7) |

En la presentación los datos y los scripts `datos/*.R` se enlazan en
`https://epidemos.es/bs2026/`. Cada script funciona en Rj (usa la tabla
`data` que abre JAMOVI) y en R (descarga el `.omv` de esa dirección).

## Requisitos

- **R** (probado con 4.5.1) y los paquetes `jmvReadWrite`, `ggplot2`,
  `cowplot`, `e1071` y `jsonlite`.
- **Emacs** con **Org** y `ox-beamer` (probado con Emacs 28.2 / Org 9.5).
- **TeX Live** con `pdflatex`, `beamer` (tema Montpellier), `tikz`
  (bibliotecas `tikzmark` y `arrows.meta`), `booktabs`, `ctable`,
  `listings`, `multirow`, `mathpazo` y `tcolorbox` (probado con TeX Live 2022).
- **ImageMagick** 6 (`convert`) para anotar las capturas.
- Las capturas se hicieron con **JAMOVI 2.7.27** (interfaz en español).
