# Práctica 1 de Bioestadística (2º Medicina): estado del proyecto

*Última actualización: 06-10-2026. Documento pensado para retomar el
trabajo (en otro equipo, u otra sesión de Claude) sin perder contexto.
Vive en este repositorio porque es la única copia que se mantiene: no
depende de la carpeta de trabajo `S1` donde se gestó el proyecto.*

> **PROYECTO EN MANTENIMIENTO.** La presentación tiene el visto bueno
> del usuario desde el 29-09-2026. Estado de referencia:
>
> - **Presentación:** `practica01.org` → `practica01.pdf` (76 págs., con
>   índice), «1º Práctica bioestadística: Estadística descriptiva con
>   JAMOVI», 9 secciones.
> - **Repositorio:** este mismo (git, rama `main`, autor «viciana»,
>   licencia CC BY 4.0), publicado en
>   https://github.com/viciana/BioStat_Practica01 (remoto SSH `origin`,
>   clave `~/.ssh/id_ed25519` del equipo original). Solo fuentes y
>   recursos no regenerables; `make` lo regenera todo desde cero (≈ 30 s;
>   probado en un clon limpio: PDF idéntico, datos idénticos byte a
>   byte).
> - **Web del alumno:** los 24 ficheros enlazados en el PDF (7 de datos y
>   17 scripts R/Rj) están en `https://epidemos.es/bs2026/` y coinciden
>   con los que genera `make` (comprobado el 29-09; `nubes.omv` solo
>   difiere en la versión de `jmvReadWrite` que lo escribió).
>
> **Para retocar algo:** trabajar en este repositorio (idealmente en una
> rama), ejecutar `make`, revisar el PDF y hacer `git commit` + `git
> push` cuando esté aprobado; si cambian datos o scripts `datos/*.R`,
> volver a subirlos a `bs2026`.
>
> **La carpeta `S1`** (fuera de este repositorio) fue el taller donde se
> gestó el proyecto: guarda la presentación del curso anterior
> (`anterior/`), material de referencia (`ejemplos/`), pruebas antiguas
> de simulación (`Simulaciones/`) y versiones descartadas (`retirado/`,
> con los antiguos `bloque1-3.org`; en este documento «bloque 1/2/3» se
> refiere a las tres partes de `practica01.org`, separadas por
> comentarios `# Parte 1/2/3`). No se mantiene ni se sincroniza con este
> repositorio: es solo historial, por si hace falta consultarlo.

> **Para retomar con Claude Code:** abre Claude en este repositorio y
> pídele que lea `CLAUDE.md` y `ESTADO_PROYECTO.md` (ambos aquí). La
> carpeta `S1` solo hace falta si quieres consultar el historial
> descrito arriba. La "memoria" interna de Claude está en el equipo
> original y **no se sincroniza** con la carpeta: todo lo importante
> está recogido aquí.

---

## 1. Objetivo

Preparar las diapositivas (org-mode → beamer → PDF) de una práctica de 4 h
de estadística descriptiva con **jamovi** para 2º de Medicina, siguiendo el
guion `guion_practica01.org`, que tiene tres bloques:

1. Introducción a jamovi: carga y manipulación de datos.
2. Estadística descriptiva.
3. Correlación y regresión.

Cada bloque lleva **ficheros de datos simulados en R** (en formato `.omv`,
listos para jamovi) para que los alumnos hagan comprobaciones en clase,
**gráficos generados en R** con estilo jamovi y **capturas de jamovi**
recortadas y anotadas.

## 2. Estado actual

| Parte | Fichero | Estado |
|---|---|---|
| Piloto: medidas de forma | `S1/retirado/prueba01.org` | **Retirado** (28-09, tarde): sus 3 diapositivas ya están en el bloque 2 |
| Bloque 1: introducción a jamovi | `bloque1.org` → `bloque1.pdf` (25 págs.) | Hecho; 29-09: nueva sección inicial «Análisis de datos» (tres patas y tabla de datos, de `S1/anterior/Muestra01.org`) y tabla de tipos de variables rehecha |
| Bloque 2: estadística descriptiva | `bloque2.org` → `bloque2.pdf` (29 págs.) | Hecho (j06 y j07 quitadas el 28-09) |
| Bloque 3: correlación y regresión | `bloque3.org` → `bloque3.pdf` (22 págs.) | Hecho, con capturas j08–j12 |
| Presentación final unida | `practica01.org` → `practica01.pdf` (76 págs., con índice) | **Hecha** (29-09): portada común, 9 secciones; referencias a «bloque anterior» cambiadas por «Ejercicio 01» |
| Repositorio y publicación | `../practica01/` → GitHub `viciana/BioStat_Practica01` | **Hecho** (29-09): fuentes + CC BY 4.0; datos y scripts en `bs2026` al día |

## 3. Requisitos de software (equipo original)

- **R 4.5.1** con los paquetes `jmvReadWrite` (0.4.12), `ggplot2` (3.5.2),
  `e1071` (1.7.17) y `cowplot` (1.1.3).
- En el **segundo equipo** (R 4.5.3) hubo que instalar `jmvReadWrite`
  (0.4.14), `e1071` y `cowplot` en la librería de usuario. No hace falta
  `latexmk` (Org compila con pdflatex). No hay `xdotool`: jamovi lo
  maneja el usuario.
- **Emacs 28.2 / Org 9.5.5** con `ox-beamer`. En `~/.emacs` hay
  `(with-eval-after-load 'org (require 'ox-beamer))` y el título de índice
  en español; el Makefile carga `ox-beamer` explícitamente.
- **TeX Live 2022** (pdflatex, latexmk, beamer, booktabs).
- **ImageMagick 6** (`convert`, `import`, `montage`) y `xwininfo` (X11),
  `pdftoppm` (poppler) para revisar las diapositivas como imágenes.
- **jamovi 2.7.27** (flatpak `org.jamovi.jamovi`), interfaz en español.
- Escritorio **GNOME sobre X11** (las capturas usan `import -window`; en
  Wayland no funcionarían así).

## 4. Estructura del repositorio

La tabla «Estructura» de `README.md` resume las carpetas para quien solo
quiera compilar. Aquí va el detalle por script, útil para mantenimiento:

### Scripts de `src/`

| Script | Qué hace | Salida |
|---|---|---|
| `01_simula_forma.R` | Simula `forma` (V1–V8) | `datos/forma.{csv,omv}` |
| `02_graficos_forma.R` | Gráficos de asimetría y curtosis y tabla | `img/asimetria.pdf`, `curtosis.pdf`, `otras.pdf`, `tab_forma.tex` |
| `03_simula_pacientes.R` | Simula `pacientes` y `analitica` | `datos/pacientes.{csv,omv}`, `datos/analitica.csv` |
| `04_anota_capturas.sh` | Recorta y anota las capturas de jamovi | `img/c*.png`, `img/j*.png` |
| `05_simula_categorias.R` | Simula `categorias` (C1–C4) | `datos/categorias.{csv,omv}` |
| `06_graficos_descriptiva.R` | Gráficos y tablas del bloque 2 | `img/d_*.pdf`, `img/tab_*.tex` |
| `08_simula_nubes.R` | Simula `nubes` (X, Y1–Y7) | `datos/nubes.{csv,omv}` |
| `09_graficos_nubes.R` | Gráficos y tabla del bloque 3 | `img/n_*.pdf`, `img/tab_nubes.tex` |
| `07_soluciones.R` | Fichero de soluciones de los bloques 1 y 2 (con fórmulas) | `datos/soluciones.omv` |
| `10_tipos_variables.tex` | Tabla de clasificación de variables con iconos de JAMOVI y flechas de degradación (LaTeX + TikZ, standalone; dos pasadas por `tikzmark`) | `img/tipos_variables.pdf` (bloque 1, pág. 10) |
| `11_tres_patas.tex` | Diagrama de Venn «Las tres patas del análisis de datos» (TikZ; etiquetas en lugar de iconos; adaptado de @AnaBayes) | `img/tres_patas.pdf` (bloque 1, pág. 3) |
| `12_tabla_datos.tex` | Esquema de tabla de datos individuos × variables, traducido y en kg/cm | `img/tabla_datos.pdf` (bloque 1, pág. 4) |
| `13_rj_cualitativa.R` | Ejecuta `datos/cualitativa.R` (código para el editor **Rj** de JAMOVI, solo R base: puntos con líneas con doble eje y sectores en color, sin 3D (demasiado complejo); puntos el doble de ancho que el pastel (layout)) con `pacientes.omv`. **Probado por el usuario en Rj (29-09): funciona** | `img/rj_cualitativa.pdf` (pág. 30) |
| `14_rj_diversidad.R` | Ejecuta `datos/diversidad.R` (R base; funciona en Rj con `data` y en R descargando `categorias.omv` de la web) con `categorias.omv`: C1–C4 como puntos con líneas, GS y H en los títulos. El gráfico de la diapositiva enlaza a `diversidad.R` | `img/rj_diversidad.pdf` (pág. 32; sustituye a `d_concentracion.pdf`, que ya no se usa) |
| `15_rj_histogramas.R` | Ejecuta `datos/histogramas.R` (R base; Rj con `data` o R descargando `pacientes.omv`): Colesterol con anchos 2, 15 y 60 mg/dL; el gráfico enlaza al script | `img/rj_histogramas.pdf` (pág. 36; sustituye a `d_histo_anchos.pdf`) |
| `16_rj_densidad.R` | Ejecuta `datos/densidad.R` (R base; Rj o R): Talla con histograma, polígono de frecuencias y densidad; en los dos últimos, histograma sin relleno de fondo y área transparente (`adjustcolor`) | `img/rj_densidad.pdf` (pág. 37; sustituye a `d_histo_poligono.pdf`) |
| `17_rj_cajas.R` | Ejecuta `datos/cajas.R` (R base; Rj o R): Triglicéridos, caja y bigotes anotada (cota del RIC) y violín hecho con la densidad en espejo | `img/rj_cajas.pdf` (pág. 38; sustituye a `d_caja_anatomia.pdf`) |
| `18_rj_centralidad.R` | Ejecuta `datos/centralidad.R` (R base; Rj o R): Triglicéridos, centralidad (media, mediana, moda) y dispersión (media ± DE y RIC como cotas) | `img/rj_centralidad.pdf` (pág. 39; sustituye a `d_centralidad.pdf`) |
| `19_rj_asimetria.R` | Ejecuta `datos/asimetria.R` (R base; Rj o R): V2/V1/V3 de `forma.omv` con media, mediana y moda; G1 calculado como JAMOVI (sin `e1071`) | `img/rj_asimetria.pdf` (pág. 41; sustituye a `asimetria.pdf`) |
| `20_rj_curtosis.R` | Ejecuta `datos/curtosis.R` (R base; Rj o R): V4/V5/V6 de `forma.omv` con densidad y normal de referencia, eje vertical común; G2 como JAMOVI | `img/rj_curtosis.pdf` (pág. 42; sustituye a `curtosis.pdf`) |
| `21_rj_otras.R` | Ejecuta `datos/otras.R` (R base; Rj o R): V7 bimodal y V8 uniforme de `forma.omv` con densidad, normal de referencia y caja + puntos debajo; G2 como JAMOVI | `img/rj_otras.pdf` (pág. 43; sustituye a `otras.pdf`) |
| `22_rj_estratos.R` | Ejecuta `datos/estratos.R` (R base; Rj o R): Talla por Sexo, densidades superpuestas y violines (densidad en espejo) con caja y puntos | `img/rj_estratos.pdf` (pág. 48; sustituye a `d_estratos.pdf`) |
| `23_rj_nubes.R` | Ejecuta `datos/nubes.R` (R base; Rj o R): Y1/Y2/Y3/Y5 frente a X de `nubes.omv` en una fila, con r de Pearson | `img/rj_nubes.pdf` (pág. 58; sustituye a `n_formas.pdf`) |
| `24_rj_spearman.R` | Ejecuta `datos/spearman.R` (R base; Rj o R): X–Y7 de `nubes.omv` con los 6 atípicos en rojo (Pearson 0.29, Spearman 0.03) y la nube RANK(X)–RANK(Y7), cuyo Pearson = ρ | `img/rj_spearman.pdf` (pág. 60; sustituye a `n_atipicos.pdf`) |
| `25_rj_estratificada.R` | Ejecuta `datos/estratificada.R` (R base; Rj o R): Peso–Talla por Sexo con recta de cada sexo y de todos (rojo claro, continua, más gruesa); r y pendientes en la leyenda (sustituye a la tabla) | `img/rj_estratificada.pdf` (pág. 62; sustituye a `n_estratos.pdf`) |
| `26_rj_recta.R` | Ejecuta `datos/recta.R` (R base; Rj o R): Y4 frente a X de `nubes.omv`, recta de regresión, escalón +10 en X / +8.46 en Y, ecuación y R² | `img/rj_recta.pdf` (pág. 65, en columna; sustituye a `n_recta.pdf`) |
| `27_rj_transforma.R` | Ejecuta `datos/transforma.R` (R base; Rj o R): Y6 frente a X en escala original y log10, con recta y R² | `img/rj_transforma.pdf` (pág. 68; sustituye a `n_transforma.pdf`) |
| `28_rj_polinomio.R` | Ejecuta `datos/polinomio.R` (R base; Rj o R): Y5 frente a X con recta y parábola (X2 = X^2, como en JAMOVI) y sus R² | `img/rj_polinomio.pdf` (pág. 69, en columna; sustituye a `n_polinomio.pdf`) |
| `29_rj_logistica.R` | Ejecuta `datos/logistica.R` (R base; Rj o R): HTA (0/1, a partir de «Sí») frente a Edad con recta (se sale de [0, 1]) y curva logística (`glm`) | `img/rj_logistica.pdf` (pág. 74, en columna; sustituye a `n_logistica.pdf`) |
| `estilo_jmv.R` | Estilo común de gráficos (imita jamovi) y `tabla_tex()` | (se carga con `source`) |
| `captura.sh` | Captura la ventana de jamovi | `capturas/<nombre>.png` |
| `rafaga.sh` | Ráfaga de capturas cada N s (para menús desplegables) | `<dir>/fNNN.png` |

Todos se ejecutan **desde este repositorio**; `make` los encadena. `make`
regenera los datos de forma reproducible (semillas fijas; comprobado: los
CSV salen idénticos byte a byte).

## 5. Data.sets (carpeta `datos/`)

Criterio de nombres (**decisión del usuario**): una palabra corta en
minúsculas, fácil de escribir, recordar e identificar, y el mismo nombre
para `.csv` y `.omv`. La metainformación (descripciones de variables) **no
se esconde**.

### `forma.omv` (n = 200): ID, V1–V8

Variables abstractas **sin contexto clínico** (decisión del usuario: dar un
contexto retrasaría la práctica). Todas con media ≈ 50 y DE ≈ 10, para que
solo cambie la **forma**.

| Var | Forma | G1 | G2 |
|---|---|---|---|
| V1 | Simétrica (normal) | −0.01 | −0.08 |
| V2 | Asimetría positiva (gamma, forma 2) | 1.45 | 3.05 |
| V3 | Asimetría negativa (gamma reflejada) | −1.43 | 2.91 |
| V4 | Leptocúrtica (Laplace) | −0.03 | 3.06 |
| V5 | Mesocúrtica (normal) | 0.04 | 0.02 |
| V6 | Platicúrtica (beta 1.5–1.5) | 0.00 | −0.99 |
| V7 | Bimodal (mezcla de dos normales) | 0.00 | −1.42 |
| V8 | Uniforme | 0.00 | −1.20 |

Decisiones:
- **Muestreo estratificado:** se toma un u en cada intervalo [(i−1)/n, i/n)
  y se aplica x = F⁻¹(u); luego se baraja. Con n = 200 y muestreo puro, V6 y
  V8 no se distinguían de la normal. Sigue siendo aleatorio, pero los
  histogramas quedan "de libro".
- **Búsqueda de semilla:** cada variable se re-simula hasta que G1 y G2
  caen a ±0.05 / ±0.10 del valor buscado, para que los resultados en clase
  sean limpios.
- **Asimetría ≈ ±1.4** (no ±1): con ±1 media, mediana y moda casi se
  solapaban en el gráfico.
- G1 y G2 se calculan **como jamovi/SPSS** (`e1071`, `type = 2`).

### `pacientes.csv` / `pacientes.omv` (n = 200)

**Contexto clínico mínimo** (aprobado por el usuario: aquí sí hace falta,
porque el IMC y las recodificaciones no tienen sentido con V1..Vn).

Variables: `ID, Sexo (1 Hombre, 2 Mujer), Edad, GrupoSang (A/B/AB/O),
Estudios (1–5: Sin estudios, Primarios, Secundarios, FP, Universitarios),
Fumador (0 Nunca, 1 Exfumador, 2 Fumador), Convivientes, Peso, Talla, PAS,
Pulso, Temperatura, Colesterol, Trigliceridos, HTA (0 No, 1 Sí)`.

- El **CSV va "en bruto"**: categorías como códigos numéricos, sin
  etiquetas. Es a propósito: los alumnos deben corregir tipos y etiquetas
  en jamovi. El **OMV** es la misma tabla ya tipada y etiquetada, con
  descripciones (fichero "de rescate").
- Hay 6 faltantes en Colesterol y 6 en Triglicéridos.
- Relaciones incorporadas: Talla y Peso dependen del sexo; Peso ~ Talla
  (r = 0.67); PAS ~ Edad + IMC (r con la edad = 0.56); Colesterol ~ Edad;
  Triglicéridos log-normal ~ IMC; menos estudios a más edad; pulso más alto
  en fumadores.
- **HTA se añadió después**, generada al **final** del script para no
  alterar las demás variables. Las 14 originales y `analitica.csv` siguen
  idénticas, así que las capturas del bloque 1 siguen valiendo. Motivo: la
  HTA definida como PAS ≥ 140 salía en un 7 % y sin asociaciones útiles.
  **Efectos reforzados el 28-09 (tarde)**: `plogis(-7.7 + 0.12 Edad +
  0.35 (IMC − 22) + 0.4 Hombre)`; antes era -5.1 + 0.065 Edad + 0.13 IMC y
  la curva logística casi no se distinguía de la recta. Prevalencia
  26.5 %. Tabla **Sobrepeso (IMC ≥ 25) × HTA: 30/63 frente a 23/137,
  RR = 2.84, RA = 0.308, OR = 4.51, χ² = 21.1 (p < 0.001)**. Logística
  HTA ~ Edad + IMC: OR 1.123 (Edad) y 1.408 (IMC), R²McF = 0.381;
  P(HTA | 60 años, IMC 25) ≈ 0.66. FumaActual × HTA sin asociación
  (p = 0.15).
- `analitica.csv`: 180 de los 200 ID, desordenados, con Glucosa,
  Hemoglobina y Creatinina. Sirve para explicar que jamovi no hace *merge*
  y cómo resolverlo desde R (`jmvReadWrite::merge_cols_omv`, probado).
- `S1/retirado/pacientes_soluciones.omv`: lo guardó el usuario desde jamovi tras las
  manipulaciones del bloque 1. **Ojo: es anterior a la variable HTA.**
  Queda como histórico; lo sustituye el siguiente.
- `soluciones.omv` (**generado en R**, `src/07_soluciones.R`):
  estado de `pacientes.csv` tras el Ejercicio 01 y el bloque 2, con las
  **fórmulas reales** de jamovi (29 columnas). Filtro `Filtrar 1`
  (`Sexo == "Mujer" and FumaActual == 0`, 65 filas) **inactivo**;
  GruposEdad, NivelEst, FumaActual, zPeso, IMC, GruposIMC, Sobrepeso
  (`IF(IMC >= 25, 1, 2)`), SobrepesoD (variable de datos, 1 primero),
  p / GS / H y los LOG10 de Colesterol y Triglicéridos; HTA con "Sí"
  primero (se hizo para el RR corregido, ya quitado; no molesta). Las categóricas son **enteras con etiquetas**,
  como tras importar el CSV (en `pacientes.omv` son *Text* y fórmulas
  como `Estudios <= 2` no funcionarían).
  Técnica: `write_omv()` sí guarda los atributos `columnType` y
  `formula`, pero no las etiquetas de enteros, el `measureType` de las
  enteras ni las transformaciones: se retocan `metadata.json`
  (`dataSet$transforms`, `parentId`, `transform`, `active`) y
  `xdata.json`, y se vuelve a comprimir. Comprobado en jamovi: abre sin
  errores y recalcula todas las fórmulas con los mismos valores.

### `categorias.omv` (n = 200): ID, C1–C4

Cuatro variables nominales con las mismas categorías A–D y frecuencias
**exactas** (no aleatorias; solo se baraja el orden), para comparar índices
de diversidad:

| Var | Frecuencias A/B/C/D | Gini-Simpson | Shannon H |
|---|---|---|---|
| C1 | 50/50/50/50 | 0.75 | 1.39 |
| C2 | 80/60/40/20 | 0.70 | 1.28 |
| C3 | 140/20/20/20 | 0.48 | 0.94 |
| C4 | 188/4/4/4 | 0.12 | 0.29 |

### `nubes.omv` (n = 200): ID, X, Y1–Y7 (bloque 3)

Una **X común** (normal estratificada, media 50, DE 10) y siete respuestas
abstractas, sin contexto clínico. Semillas buscadas hasta cumplir el
objetivo (como en `forma`):

| Var | Nube | Pearson r | Spearman ρ | R² recta | R² parábola |
|---|---|---|---|---|---|
| Y1 | Ruido | 0.00 | −0.02 | 0.00 | 0.01 |
| Y2 | Positiva media | 0.62 | 0.61 | 0.38 | 0.38 |
| Y3 | Negativa media | −0.60 | −0.62 | 0.36 | 0.37 |
| Y4 | Positiva fuerte (recta: Y4 = 7.87 + 0.85 X) | 0.90 | 0.89 | 0.81 | 0.81 |
| Y5 | Parabólica ∩ (r ≈ 0 pero relación fuerte) | −0.01 | −0.01 | 0.00 | 0.85 |
| Y6 | Exponencial: log10(Y6) lineal (R² 0.91) | 0.89 | 0.95 | 0.78 | 0.90 |
| Y7 | Ruido + 6 atípicos (3 en cada extremo de X) | 0.29 | 0.03 | 0.08 | 0.08 |

Usos: Y1/Y2/Y3/Y5 = las 4 formas del guion; Y4 = recta y pendiente;
Y5 = regresión polinómica; Y6 = transformación de escala y Spearman >
Pearson en relación monótona no lineal; Y7 = Pearson sensible a atípicos.
(Con 3 atípicos en un solo extremo, r solo llegaba a ≈ 0.17.)

## 6. Convenciones de las diapositivas (org → beamer)

- Todas usan `#+SETUPFILE: myconfbeamer.org` (tema Montpellier/beaver del
  curso anterior), `#+OPTIONS: H:2` y `\usepackage{booktabs}`.
- **Estilo de gráficos:** imita jamovi (relleno azul `#A8C6EE`, borde gris
  oscuro, `theme_classic`). Colores media / mediana / moda: rojo `#C0392B`
  continua, azul `#1F4E9A` discontinua, verde `#1E8449` punteada; paleta
  validada para daltonismo. Los gráficos se guardan en PDF vectorial.
- **Código en línea:** usar `~código~` y **no** `=código=` cuando el código
  contiene `==` o `<=`, porque el `=` rompe el marcado de org.
- `\circled{n}`: etiqueta roja numerada, igual que las de las capturas
  anotadas. Se define en la cabecera de cada bloque. No se usa tikz: choca
  con `ctable`, que ya carga `myconfbeamer.org`.
- `\captura{fichero}{ancho}` (bloque 2): incluye la imagen si existe y, si
  no, un recuadro "Captura pendiente". Permite compilar antes de tener
  todas las capturas.
- Cada bloque lleva `#+OPTIONS: toc:nil ^:{}`: sin `^:{}` un guion bajo
  (p. ej. `pacientes_soluciones.omv`) se exporta como subíndice. (En
  `myconfbeamer.org` pone `_:{}`, que es una clave errónea que Org ignora.)
- Los caracteres `☰` y `⋮` no compilan en pdflatex: se usan `$\equiv$` y
  `$\vdots$`. Un `%` en tablas generadas debe escaparse (`\%`).
- Los ejercicios se numeran de forma correlativa: Ejercicio 01 (bloque 1),
  02–05 (bloque 2). El bloque 3 empezará en el **06**.

## 7. Procedimiento de capturas de jamovi

No hay "computer use" en Linux, así que se hace en **modo mixto**: el usuario
maneja jamovi y Claude captura la ventana, la recorta y la anota.

1. Claude abre jamovi con el fichero: `flatpak run org.jamovi.jamovi "$PWD/datos/xxx.omv" &`
2. El usuario deja jamovi en el estado pedido, **hace clic en la ventana de
   Claude** y escribe "ya". En GNOME el foco va con el clic: si no se hace
   clic, el "ya" se escribe dentro de jamovi, y ya ocurrió dos veces.
3. Claude ejecuta `sh src/captura.sh <nombre> [id_ventana]` (el id hace
   falta si hay varias ventanas de jamovi; se obtiene con
   `xwininfo -root -tree | grep '("jamovi" "jamovi")'`).
4. Para **menús desplegables**, que se cierran al cambiar de ventana:
   `sh src/rafaga.sh <dir> 60 3` (una captura cada 3 s durante 3 min). El
   usuario abre el menú, espera sin tocar nada y Claude elige el fotograma.
5. Añadir la línea correspondiente en `src/04_anota_capturas.sh`: nombre,
   h/v, trozos a recortar (`WxH+X+Y`) y recuadros (x0,y0,x1,y1 en
   coordenadas de la captura original). Se juntan varios trozos, por
   ejemplo el panel de fórmula y la tira de columnas, para que el texto se
   lea bien.

**Ojo al cerrar jamovi:** cerrar *sin guardar*. El 28-09 se guardó por
error `datos/pacientes.omv` con el estado de la captura j05 (IMC,
Sobrepeso y el análisis) y `07_soluciones.R` dejó de funcionar. Se
regeneró con `Rscript src/03_simula_pacientes.R` (sale idéntico) y la
copia guardada está en `S1/retirado/pacientes_guardado_j05.omv`. Si `make`
falla en `07_soluciones.R`, revisar primero esto.

**Tamaño de ventana recomendado:** unos **1280×800 con el zoom de jamovi al
125 %** (menú ⋮ → Zoom), sin maximizar. El texto de jamovi tiene un tamaño
fijo en píxeles: en una ventana maximizada el contenido ocupa poco y en el
PDF sale pequeño. Las capturas del bloque 1 se hicieron maximizadas y al
100 %, pero con recortes ajustados se leen bien.

## 8. Comportamientos de jamovi comprobados (útiles para el texto de las diapositivas)

- **Calcular / Transformar** insertan la columna nueva **a la derecha de
  la columna seleccionada** (corrección del usuario).
- En las fórmulas, una variable entera con etiquetas se comporta como el
  par (código, etiqueta): `Estudios <= 2` usa el **código**, pero
  `VALUE(Estudios)` convierte primero a texto (la etiqueta) y devuelve
  **celdas vacías sin ningún mensaje de error**. En los filtros funcionan
  tanto `Sexo == "Mujer"` como `Sexo == 2`.
- Las **variables calculadas** no tienen cuadro de niveles: no se pueden
  etiquetar ni **reordenar**, y sus niveles salen por **orden de
  aparición** (`IF(IMC >= 25, 1, 2)` salió con el 2 primero). **No hay
  opción en el interfaz para convertirlas en variable de datos** (revisado
  en el código de jamovi). La solución, que encontró el usuario, es copiar
  la columna (Ctrl+C) y pegarla en una **variable de datos** nueva
  (`SobrepesoD`), que sí se puede reordenar y etiquetar.
- En Transformar sin condiciones, la fórmula va directamente junto a *fx*
  (`LOG10($source)`); no aparece la línea "si no usar".
- La edición de niveles deja la pantalla atenuada hasta hacer clic fuera
  del cuadro.
- Las funciones de columna como `Z()` **se recalculan con el filtro
  activo** (zPeso cambió al filtrar mujeres).
- La ayuda de una función solo aparece en el menú *fx* al **seleccionarla**.
  `Z(x, group_by=g)` estandariza dentro de cada grupo.
- **Gini-Simpson y Shannon con variables calculadas** (comprobado):
  `p = VN(GrupoSang, group_by=GrupoSang) / VN(GrupoSang)`,
  `GS = 1 - VMEAN(p)` = 0.668 y `H = -VMEAN(LN(p))` = 1.205.
- En *Descriptivas* la opción se llama **"Separa por"**.
- **Tablas de contingencia:** jamovi calcula RR = riesgo de la fila 1 /
  riesgo de la fila 2, con el evento en la **columna 1** ("Comparar: filas").
  Con el orden por defecto sale **RR = 1.59** (riesgo de *no* tener HTA).
  No calcula la RA. **Decisión del usuario (28-09): se quitan las
  diapositivas del RR de jamovi (j06) y de su corrección (j07)**; RR, RA
  y OR se calculan a mano con los % por fila, en la forma habitual en
  epidemiología (RR = R₁/R₀, RA = R₁ − R₀).
- **Gráfico de barras de Tablas de contingencia:** con *Porcentajes de
  filas* y *Eje X = Filas* dibuja bien el % de HTA en cada grupo de
  Sobrepeso, pero rotula el eje Y como «Porcentajes de Sobrepeso». Se
  señala con un «¡Ojo!» en la diapositiva de j05.
- Al crear `Sobrepeso = IF(IMC >= 25, 1, 2)` desde `pacientes.omv`, los
  niveles salen 2, 1 (el primer paciente no tiene sobrepeso).
- El código de las fórmulas de jamovi está en
  `/var/lib/flatpak/app/org.jamovi.jamovi/.../site-packages/jamovi/server/compute/functions.py`,
  útil para comprobar el comportamiento de una función.

- **Nombres de menús comprobados (bloque 3):** *Exploración → Gráfico de
  dispersión* (opciones *Línea de regresión → Mostrar línea*, método
  *Lineal*; *Variables de agrupación*); *Regresión → Matriz de
  correlación* (*Señalar correlaciones significativas* pone asteriscos;
  *Gráfico → Matriz de correlación*); *Regresión → Regresión lineal*
  (*Medidas de Ajuste del Modelo*, *Coeficientes del Modelo*, *R²
  corregida*); *Regresión → Regresión logística binomial* (*Niveles de
  Referencia*, *Razón de odds*, secciones *Predicción* y *Guardar*).
- **Logística y nivel de referencia:** en `soluciones.omv`
  HTA tiene «Sí» primero (para el RR del bloque 2). En la logística el
  usuario prefiere la referencia HTA = «No» (OR > 1, lo natural): se fija
  en *Niveles de Referencia* del propio análisis, **sin reordenar** la
  variable. La nota de jamovi dice «log odds de "HTA = Sí" vs. "HTA = No"».
- `04_anota_capturas.sh` admite ahora el modo `g`: grupos de trozos
  separados por `|`; cada grupo se apila en vertical y los grupos se
  ponen uno al lado del otro (usado en j12).
- `d_centralidad.pdf` (bloque 2, pág. 13): el RIC y la media ± DE se
  dibujan como **cotas de plano** (flecha de doble punta con trazos
  verticales en los extremos, función `cota()` en
  `06_graficos_descriptiva.R`), por encima de la barra más alta.
- **Modelo de diapositiva con gráfico R/Rj** (págs. 32, 36–39, 41–43, 48, 58, 60, 62, 65, 68, 69, 74; decisión del
  usuario): script `datos/<tema>.R` en R base que funciona en Rj (`data`)
  y en R (descarga el .omv de la web); la figura la genera
  `src/NN_rj_<tema>.R` ejecutando ese mismo script; en la diapositiva el
  gráfico va **maximizado** (`\makebox` a 1.08\textwidth, `\vspace*{-3mm}`),
  entero enlazado al script, sin marcos (`bty="n"`/`frame=FALSE`), márgenes
  de R mínimos, y los puntos de texto en `\tiny` con un último punto
  «Con R: código X.R (R o Rj; clic en el gráfico) y datos Y.omv».
- `04_anota_capturas.sh` admite `SAL=nombre` antes de `anota` para sacar
  varias imágenes de una misma captura (se pasan todos los recuadros en
  cada llamada para que la numeración coincida). Se usa en j05, que se
  divide en `j05a_opciones.png` y `j05b_resultados.png`. La diapositiva
  va en tres columnas: opciones (0.31), resultados a `0.80\textheight`
  con `:center nil` (el entorno center de Org hace que la imagen se salga
  por abajo) y texto en `\tiny` (0.31).

## 9. Decisiones de alcance tomadas por el usuario

- Validó el piloto tal cual: muestreo estratificado, escala común,
  estilo jamovi y tabla LaTeX.
- **Variable binaria FumaActual codificada 0/1**, no VERDADERO/FALSO, porque
  jamovi no tiene tipo lógico, la media de una 0/1 es la proporción y es la
  codificación de la regresión logística.
- **Bloque 2, se QUITAN:** medias geométrica y armónica, índices ordinales
  (Leik), desviación absoluta media y tablas de frecuencia de variables
  agrupadas.
- **Regresión logística:** se queda en el bloque 3, con un **desarrollo
  mínimo**: una variante de la regresión con variable dependiente 0/1.
- **Truco Gini/Shannon** con variables calculadas: incluido, porque
  funcionó al probarlo.
- ~~RR invertido en jamovi~~: **sustituido** (28-09) por el cálculo a mano
  de RR, RA y OR a partir de los % por fila; jamovi solo da χ², la tabla
  y el gráfico (j05).

## 10. Cierre (29-09-2026)

Todo lo pendiente quedó resuelto:

1. ~~Bloque 3~~: hecho (28-09). Ejercicios 06–08; capturas j08–j12
   (j05 y j12 rehechas con la HTA re-simulada).
2. ~~Unir los bloques en `practica01.org`~~: hecho (29-09), con índice.
3. ~~Revisión de estilo del usuario~~: hecha diapositiva a diapositiva
   (títulos, reordenaciones, tabla de tipos de variables, sección inicial
   «Análisis de datos», capturas c12, j05…).
4. ~~Gráficos reproducibles~~: 17 gráficos rehechos en R base con su
   script en `datos/*.R` (R y Rj) y enlazados desde la diapositiva.
5. ~~Subir datos y scripts a `bs2026`~~: los 24 ficheros enlazados están
   subidos y al día.
6. ~~Repositorio git y publicación en GitHub~~: hecho, con licencia
   CC BY 4.0.

Ideas no abordadas (opcionales, por si hay una segunda edición):

- Rehacer con capturas de JAMOVI 2.7 las diapositivas reutilizadas del
  curso anterior (`DatosEnJamovi.pdf`, `PanoramaJAMOVI.pdf`,
  `TipoDatoMedida.pdf`, en `recursos/`) y las capturas del bloque 1 a
  1280×800 con zoom 125 %.
- `src/06`, `src/09` y `src/02` siguen generando figuras que ya no usa la
  presentación (sustituidas por las versiones `rj_*`): se podrían podar.
- Para cambiar la dirección de la web:
  `sed -i 's|https://epidemos.es/bs2026/|NUEVA/|g' practica01.org`
  (y en `datos/*.R`, que descargan los `.omv` de esa dirección).
