#!/bin/sh
# Captura la ventana de jamovi (esté en el monitor que esté) y la guarda
# en capturas/<nombre>.png  (captura en bruto, sin anotar).
# Uso, desde S1:   sh src/captura.sh <nombre> [id_ventana]
# (id_ventana, p. ej. 0x2400003, si hay varias ventanas de jamovi abiertas)
[ -z "$1" ] && { echo "Uso: sh src/captura.sh <nombre>"; exit 1; }
W=${2:-$(xwininfo -root -tree | awk '/\("jamovi" "jamovi"\)/ && $NF !~ /^\+0\+0$/ && /[0-9]+x[0-9]+/ {print $1; exit}')}
[ -z "$W" ] && { echo "No encuentro la ventana de jamovi"; exit 1; }
mkdir -p capturas
import -window "$W" "capturas/$1.png" && identify "capturas/$1.png"
