
%.tex: %.Rnw
	R CMD Sweave $<

%.pdf: %.tex
	pdflatex $<

analysis.pdf: analysis.tex

.PHONY: clean
clean:
	rm -f *.log *.aux *.tex *.out *.sty
