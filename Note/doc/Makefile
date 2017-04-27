# Makefile for creating documentation for ATLAS LaTeX
# Usually called from a subdirectory

TEXLIVE  = 2016
LATEX    = latex
PDFLATEX = pdflatex
BIBTEX   = biber
DVIPS    = dvips
DVIPDF   = dvipdf

BASENAME = dummy

.PHONY: clean cleanpdf

run_pdflatex: $(BASENAME).pdf
	@echo "Made $<"

run_latex: $(BASENAME).dvi
	$(DVIPDF) -sPAPERSIZE=a4 -dPDFSETTINGS=/prepress $<
	@echo "Made $< and $(basename $<).pdf"

# Change TeX Live version
texlive: $(BASENAME).tex
	if [ $(TEXLIVE) -ge 2007 -a $(TEXLIVE) -lt 2100 ]; then \
	  echo "Changing texlive value in $$file"; \
	  sed -i'.bak' 's/texlive=20[0-9][0-9]/texlive=$(TEXLIVE)/' $<; \
	else echo "Invalid value for TEXLIVE: $(TEXLIVE)"; fi; \

# Standard LaTeX targets
$(BASENAME).pdf: $(BASENAME).tex *.bib
	$(PDFLATEX) $<
	-$(BIBTEX)  $(basename $<)
	$(PDFLATEX) $<
	$(PDFLATEX) $<

$(BASENAME).dvi: $(BASENAME).tex *.bib
	$(LATEX)    $<
	-$(BIBTEX)  $(basename $<)
	$(LATEX)    $<
	$(LATEX)    $<

%.bbl: %.tex *.bib
	$(PDFLATEX) $*
	$(BIBTEX) $*

clean:
	-rm *.dvi *.toc *.aux *.log *.out *.blg *.bbl *.bcf *-blx.bib \
	 *.run.xml *.synctex.gz *.fls *.fdb_latexmk .*.lb *~

cleanpdf:
	-rm $(BASENAME).pdf
