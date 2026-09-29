#!/bin/sh
# ---------------------------------------------------------------------
# 04_anota_capturas.sh
# Anota y recorta las capturas en bruto de jamovi (capturas/*.png,
# 1920x1043).  Resultado en img/<nombre>.png
#
#  1. Dibuja recuadros rojos numerados (1, 2, 3...) sobre la captura
#     COMPLETA (coordenadas x0,y0,x1,y1 de la captura original).
#  2. Recorta uno o varios trozos (WxH+X+Y) y los junta en una sola
#     imagen, en horizontal (h) o en vertical (v), con un borde fino.
#     Así el texto de jamovi se lee mejor que con un recorte grande.
#
# Uso de la función:  anota nombre h|v "trozo1 trozo2..." recuadro...
# Con SAL=otro_nombre antes de la llamada, el resultado se guarda como
# img/otro_nombre.png (para sacar varias imágenes de una misma captura;
# conviene pasar todos los recuadros en cada llamada para que la
# numeración coincida).
# Ejecutar desde el directorio S1:   sh src/04_anota_capturas.sh
# ---------------------------------------------------------------------
ROJO='#C0392B'
TMP=${TMPDIR:-/tmp}/anota$$
mkdir -p img "$TMP"

anota() {
  nombre=$1; disp=$2; trozos=$3; shift 3
  dib=""; n=1
  for r in "$@"; do
    set -- $(echo "$r" | tr ',' ' ')
    cx=$(($1 - 2)); cy=$(($2 - 2))
    dib="$dib -fill none -stroke '$ROJO' -strokewidth 4 -draw 'roundrectangle $1,$2 $3,$4 6,6'"
    dib="$dib -fill '$ROJO' -stroke '$ROJO' -strokewidth 1 -draw 'circle $cx,$cy $((cx + 13)),$cy'"
    dib="$dib -fill white -stroke none -pointsize 20 -font DejaVu-Sans-Bold -draw 'text $((cx - 6)),$((cy + 7)) \"$n\"'"
    n=$((n + 1))
  done
  eval convert "capturas/$nombre.png" $dib "$TMP/completa.png"
  # entre pieza y pieza, un separador blanco de 14 px
  convert -size 14x14 xc:white "$TMP/sep.png"
  # disp = g: grupos separados por "|"; cada grupo en vertical y los
  # grupos, uno al lado del otro
  if [ "$disp" = g ]; then grupos=$(echo "$trozos" | tr '|' '\n' | tr ' ' ','); modo=+append
  else grupos=$(echo "$trozos" | tr ' ' '\n')
       if [ "$disp" = h ]; then modo=+append; else modo=-append; fi; fi
  piezas=""; i=1
  for g in $grupos; do
    sub=""
    for t in $(echo "$g" | tr ',' ' '); do
      convert "$TMP/completa.png" -crop "$t" +repage \
              -bordercolor '#9A9A9A' -border 1 "$TMP/p$i.png"
      sub="$sub $TMP/sep.png $TMP/p$i.png"; i=$((i + 1))
    done
    convert -background white -gravity northwest $(echo $sub | cut -d' ' -f2-) -append "$TMP/g$i.png"
    piezas="$piezas $TMP/g$i.png"
  done
  lista=$(for p in $piezas; do printf '%s %s ' "$TMP/sep.png" "$p"; done | cut -d' ' -f2-)
  sal=${SAL:-$nombre}; SAL=
  convert -background white -gravity northwest $lista $modo "img/$sal.png"
  echo "img/$sal.png  $(identify -format '%wx%h' img/$sal.png)"
}

# Panel superior (configuración/fórmula) y tiras de columnas de datos
P1=620x265+640+130          # panel de variable de datos / calculada
P2=650x290+650+130          # panel de transformación

anota c01_csv_importado       h "600x250+0+125"                    26,130,598,150
anota c02_config_sexo         h "$P1 232x130+0+433"                655,225,865,310   890,225,1215,387
anota c03_etiquetas_sexo      h "$P1 232x130+0+433"                660,190,1223,214  890,248,1215,340  127,452,227,560
anota c04a_editando_niveles   h "632x265+640+130"                  890,225,1250,387
anota c04_estudios_ordinal    h "$P1 212x130+320+433"              655,226,860,248   660,190,1223,214  427,452,527,560
anota c05_binariza_fumador    h "$P1 212x130+520+433"              808,224,1250,274  627,452,727,560
anota c06_if_estudios         h "$P1 212x130+420+433"              808,224,1250,274  527,452,627,560
anota c07_transforma_edad     h "$P2 212x130+220+433"              715,272,1155,366  705,393,910,415   327,452,427,560
anota c08_transforma_multiple v "$P2 412x130+970+433"              750,275,1155,300  1125,158,1212,182 1177,452,1377,560
anota c09_funciones           h "$P1 212x130+470+433"              808,224,1250,274  577,452,677,560
anota c09a_ayuda_Z            h "520x300+770+210"                  805,425,1258,492
anota c09b_ayuda_RANK         h "520x300+770+210"                  805,425,1258,492
anota c09c_ayuda_LOG10        h "520x300+770+210"                  805,425,1258,492
anota c10_filtro              v "580x100+685+150 830x230+0+433 235x26+1030+1018"  700,165,1245,242  1055,1020,1250,1042
anota c11_omv_variables       h "505x512+0+97"                     135,163,492,606
anota c12_soluciones_derivadas  h "722x846+0+156"                     28,218,54,998



## Bloque 2: resultados de jamovi (ventanas de distinto tamaño, zoom ~125 %)
anota j01_tabla_frecuencias   h "680x315+22+240 420x210+782+358"  448,512,632,540   1082,388,1192,553
anota j02_gini_shannon        h "660x260+300+145 450x285+65+475"  474,245,958,300   180,478,510,758
anota j03_opciones_estadisticas h "580x420+25+420 240x540+630+255" 385,610,565,690   638,570,848,662
anota j04_dividir_por         h "300x450+565+120"                 678,142,728,562
J05="262,166,476,250 245,489,312,512 240,606,428,737 513,478,543,664"
SAL=j05a_opciones;   anota j05_contingencia v "240x100+246+154 470x305+10+440" $J05
SAL=j05b_resultados; anota j05_contingencia v "362x282+497+116 362x312+497+436" $J05

## Bloque 3: correlación y regresión (ventanas ~1600x1000, zoom 125 %)
anota j08_dispersion          h "770x650+20+172 740x740+820+260"  40,688,300,815    440,418,780,478
anota j09_matriz_correlaciones h "780x670+20+260 690x420+835+335" 55,598,200,662    438,630,745,660  420,810,650,842
anota j10_regresion_lineal    h "400x520+372+250 490x350+822+325"  435,275,768,520   842,545,1300,650 842,360,1105,440
anota j11_regresion_multiple  h "400x520+372+250 490x370+822+325"  435,345,768,520
anota j12_logistica           g "310x196+272+200 565x286+10+560|465x352+618+196" 322,220,574,392 315,740,420,766 638,520,1074,546 28,576,572,602
rm -rf "$TMP"
