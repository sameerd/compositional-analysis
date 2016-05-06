
%.tex: %.Rnw
	R CMD Sweave $<

%.pdf: %.tex
	pdflatex $<
	make clean
	mv $@ /tmp
	make very-clean
	mv /tmp/$@ .

analysis.pdf: analysis.tex

.PHONY: clean very-clean
clean:
	rm -f *.log *.aux *.tex *.out

very-clean: clean
	rm -f *.pdf
