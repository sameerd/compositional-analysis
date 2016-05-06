
%.tex: %.Rnw
	R CMD Sweave $<

%.pdf: %.tex
	pdflatex $<

analysis.pdf: analysis.tex

.PHONY: clean very-clean
clean:
	rm -f *.log *.aux *.tex *.out

very-clean: clean
	rm -f *.pdf
