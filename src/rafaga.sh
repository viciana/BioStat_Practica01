#!/bin/sh
# Ráfaga de capturas de la ventana de jamovi: una cada <intervalo> s
# durante <n> fotogramas, en <dir>/fNNN.png (para menús desplegables que
# se cierran al cambiar de ventana).
# Uso:  sh src/rafaga.sh <dir> [n=60] [intervalo=3]
D=${1:?Uso: sh src/rafaga.sh <dir> [n] [intervalo]}; N=${2:-60}; T=${3:-3}
W=$(xwininfo -root -tree | awk '/\("jamovi" "jamovi"\)/ && /[0-9]+x[0-9]+/ {print $1; exit}')
[ -z "$W" ] && { echo "No encuentro la ventana de jamovi"; exit 1; }
mkdir -p "$D"; rm -f "$D"/f*.png
i=1; while [ $i -le $N ]; do
  import -window "$W" "$D/f$(printf %03d $i).png"; sleep "$T"; i=$((i+1))
done
