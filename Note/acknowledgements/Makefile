# Makefile for creating ATLAS Acknowledegments

TEXLIVE  = 2016
LATEX    = latex
PDFLATEX = pdflatex
BIBTEX   = biber
DVIPS    = dvips
DVIPDF   = dvipdf

BASENAME = Acknowledgements-main

.PHONY: clean cleanpdf

run_pdflatex: $(BASENAME).pdf
	@echo "Made $<"

# Change TeX Live version
texlive: $(BASENAME).tex
	if [ $(TEXLIVE) -ge 2007 -a $(TEXLIVE) -lt 2100 ]; then \
	  echo "Changing texlive value in $$file"; \
	  sed -i'.bak' 's/texlive=20[0-9][0-9]/texlive=$(TEXLIVE)/' $<; \
	else echo "Invalid value for TEXLIVE: $(TEXLIVE)"; fi; \

# Standard LaTeX targets
$(BASENAME).pdf: $(BASENAME).tex
	$(PDFLATEX) $<
	-$(BIBTEX)  $(basename $<)
	$(PDFLATEX) $<
	$(PDFLATEX) $<

%.bbl: %.tex *.bib
	$(PDFLATEX) $*
	$(BIBTEX) $*

clean:
	-rm *.dvi *.toc *.aux *.log *.out *.blg *.bbl *.bcf *-blx.bib \
	 *.run.xml *.synctex.gz *~

cleanpdf:
	-rm $(BASENAME).pdf

cleanall: clean cleanpdf
