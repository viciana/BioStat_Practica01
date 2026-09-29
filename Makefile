# Práctica 1 de Bioestadística (2º Medicina): Estadística descriptiva con JAMOVI
# Regenera desde cero datos, gráficos, capturas anotadas y la presentación.
# Ejecutar desde esta carpeta:
#   make          -> todo (datos, gráficos y practica01.pdf)
#   make datos    -> datos/*.csv, datos/*.omv (simulaciones en R)
#   make graficos -> img/*.pdf, img/tab_*.tex (gráficos y tablas en R y LaTeX)
#   make capturas -> img/c*.png, img/j*.png (capturas de JAMOVI recortadas y anotadas)
#   make pdf      -> practica01.pdf (org -> beamer, Emacs en modo batch)
#   make clean    -> borra todo lo generado
# Las capturas en bruto (capturas/*.png) NO se regeneran: se hicieron a mano
# con JAMOVI (src/captura.sh, src/rafaga.sh).

$(shell mkdir -p img)

EXPORTA = emacs --batch $< --eval "(progn (require 'ox-beamer) (org-beamer-export-to-pdf))"

all: datos graficos pdf

## Datos -----------------------------------------------------------------
datos/forma.csv datos/forma.omv: src/01_simula_forma.R
	Rscript $<
datos/pacientes.csv datos/pacientes.omv datos/analitica.csv: src/03_simula_pacientes.R
	Rscript $<
datos/categorias.csv datos/categorias.omv: src/05_simula_categorias.R
	Rscript $<
datos/nubes.csv datos/nubes.omv: src/08_simula_nubes.R
	Rscript $<
datos/soluciones.omv: src/07_soluciones.R datos/pacientes.csv datos/pacientes.omv
	Rscript $<

datos: datos/forma.omv datos/pacientes.omv datos/categorias.omv datos/nubes.omv datos/soluciones.omv

## Gráficos y tablas -----------------------------------------------------
img/tab_forma.tex: src/02_graficos_forma.R datos/forma.csv
	Rscript $<
img/tab_contingencia.tex: src/06_graficos_descriptiva.R src/estilo_jmv.R datos/pacientes.csv datos/categorias.csv
	Rscript $<

img/tab_nubes.tex: src/09_graficos_nubes.R src/estilo_jmv.R datos/nubes.csv datos/pacientes.csv
	Rscript $<

## Figuras y tablas en LaTeX independiente (standalone; TikZ choca con
## ctable en la presentación).  Dos pasadas por tikzmark.
STANDALONE = d=$$(mktemp -d) && \
	pdflatex -interaction=nonstopmode -halt-on-error -output-directory=$$d $< >/dev/null && \
	pdflatex -interaction=nonstopmode -halt-on-error -output-directory=$$d $< >/dev/null && \
	cp $$d/$(basename $(notdir $<)).pdf $@ && rm -r $$d
ICONOS = $(addprefix recursos/,cardinal.png ID.png numerica.png ordinal.png)
img/tipos_variables.pdf: src/10_tipos_variables.tex $(ICONOS)
	$(STANDALONE)
img/tres_patas.pdf: src/11_tres_patas.tex
	$(STANDALONE)
img/tabla_datos.pdf: src/12_tabla_datos.tex
	$(STANDALONE)
LATEX_IMG = img/tipos_variables.pdf img/tres_patas.pdf img/tabla_datos.pdf

img/rj_cualitativa.pdf: src/13_rj_cualitativa.R datos/cualitativa.R datos/pacientes.omv
	Rscript $<

img/rj_diversidad.pdf: src/14_rj_diversidad.R datos/diversidad.R datos/categorias.omv
	Rscript $<

img/rj_histogramas.pdf: src/15_rj_histogramas.R datos/histogramas.R datos/pacientes.omv
	Rscript $<

img/rj_densidad.pdf: src/16_rj_densidad.R datos/densidad.R datos/pacientes.omv
	Rscript $<

img/rj_cajas.pdf: src/17_rj_cajas.R datos/cajas.R datos/pacientes.omv
	Rscript $<

img/rj_centralidad.pdf: src/18_rj_centralidad.R datos/centralidad.R datos/pacientes.omv
	Rscript $<

img/rj_asimetria.pdf: src/19_rj_asimetria.R datos/asimetria.R datos/forma.omv
	Rscript $<

img/rj_curtosis.pdf: src/20_rj_curtosis.R datos/curtosis.R datos/forma.omv
	Rscript $<

img/rj_otras.pdf: src/21_rj_otras.R datos/otras.R datos/forma.omv
	Rscript $<

img/rj_estratos.pdf: src/22_rj_estratos.R datos/estratos.R datos/pacientes.omv
	Rscript $<

img/rj_nubes.pdf: src/23_rj_nubes.R datos/nubes.R datos/nubes.omv
	Rscript $<

img/rj_spearman.pdf: src/24_rj_spearman.R datos/spearman.R datos/nubes.omv
	Rscript $<

img/rj_estratificada.pdf: src/25_rj_estratificada.R datos/estratificada.R datos/pacientes.omv
	Rscript $<

img/rj_recta.pdf: src/26_rj_recta.R datos/recta.R datos/nubes.omv
	Rscript $<

img/rj_transforma.pdf: src/27_rj_transforma.R datos/transforma.R datos/nubes.omv
	Rscript $<

img/rj_polinomio.pdf: src/28_rj_polinomio.R datos/polinomio.R datos/nubes.omv
	Rscript $<

img/rj_logistica.pdf: src/29_rj_logistica.R datos/logistica.R datos/pacientes.omv
	Rscript $<

graficos: img/tab_forma.tex img/tab_contingencia.tex img/tab_nubes.tex $(LATEX_IMG) img/rj_cualitativa.pdf img/rj_diversidad.pdf img/rj_histogramas.pdf img/rj_densidad.pdf img/rj_cajas.pdf img/rj_centralidad.pdf img/rj_asimetria.pdf img/rj_curtosis.pdf img/rj_otras.pdf img/rj_estratos.pdf img/rj_nubes.pdf img/rj_spearman.pdf img/rj_estratificada.pdf img/rj_recta.pdf img/rj_transforma.pdf img/rj_polinomio.pdf img/rj_logistica.pdf

## Capturas de jamovi anotadas -------------------------------------------
img/c01_csv_importado.png: src/04_anota_capturas.sh $(wildcard capturas/*.png)
	sh $<

capturas: img/c01_csv_importado.png

## Presentaciones --------------------------------------------------------
practica01.pdf: practica01.org myconfbeamer.org img/c01_csv_importado.png \
                img/tab_forma.tex img/tab_contingencia.tex img/tab_nubes.tex $(LATEX_IMG) \
                img/rj_cualitativa.pdf datos/cualitativa.R img/rj_diversidad.pdf img/rj_histogramas.pdf img/rj_densidad.pdf img/rj_cajas.pdf img/rj_centralidad.pdf img/rj_asimetria.pdf img/rj_curtosis.pdf img/rj_otras.pdf img/rj_estratos.pdf img/rj_nubes.pdf img/rj_spearman.pdf img/rj_estratificada.pdf img/rj_recta.pdf img/rj_transforma.pdf img/rj_polinomio.pdf img/rj_logistica.pdf
	$(EXPORTA)

pdf: practica01.pdf

clean:
	rm -rf img practica01.pdf practica01.tex src/descripciones.rds \
	       datos/*.csv datos/*.omv

.PHONY: all datos graficos capturas pdf clean
