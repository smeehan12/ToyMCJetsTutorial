# Makefile for creating an ATLAS LaTeX document
#------------------------------------------------------------------------------
# By default makes mydocument.pdf using target run_pdflatex.
# Replace mydocument with your main filename or add another target set.
# Adjust TEXLIVE if it is not correct, or pass it to "make new".
# Replace BIBTEX = bibtex with BIBTEX = biber if you use biber instead of bibtex.
# Adjust FIGSDIR for your figures directory tree.
# Adjust the %.pdf dependencies according to your directory structure.
# Use "make clean" to cleanup.
# Use "make cleanpdf" to delete $(BASENAME).pdf.
# "make cleanall" also deletes the PDF file $(BASENAME).pdf.
# Use "make cleanepstopdf" to rmeove PDF files created automatically from EPS files.
#   Note that FIGSDIR has to be set properly for this to work.

# If you have to run latex rather than pdflatex adjust the dependencies of %.dvi target
#   and use the command "make run_latex" to compile.
# Specify dvipdf or dvips as the run_latex dependency,
#   depending on which you want to use.

#-------------------------------------------------------------------------------
# Check which TeX Live installation you have with the command pdflatex --version
TEXLIVE  = 2016
LATEX    = latex
PDFLATEX = pdflatex
BIBTEX   = bibtex
# BIBTEX = biber
DVIPS    = dvips
DVIPDF   = dvipdf

#-------------------------------------------------------------------------------
# The main document filename
BASENAME = ToyMCJetTutorial
#-------------------------------------------------------------------------------
# Adjust this according to your top-level figures directory
# This directory tree is used by the "make cleanepstopdf" command
FIGSDIR  = figs
#-------------------------------------------------------------------------------

# EPSTOPDFFILES = `find . -name \*eps-converted-to.pdf`
rwildcard=$(foreach d,$(wildcard $1*),$(call rwildcard,$d/,$2) $(filter $(subst *,%,$2),$d))
EPSTOPDFFILES = $(call rwildcard, $(FIGSDIR), *eps-converted-to.pdf)

# Default target - make mydocument.pdf with pdflatex
default: run_pdflatex

.PHONY: new newtexmf newbook newbooktexmf draftcover preprintcover auxmat \
	clean cleanpdf help

# Standard pdflatex target
run_pdflatex: $(BASENAME).pdf
	@echo "Made $<"

#-------------------------------------------------------------------------------
# Specify the tex and bib file dependencies for running pdflatex
# If your bib files are not in the main directory adjust this target accordingly
#%.pdf:	%.tex *.tex bibtex/bib/*.bib
%.pdf:	%.tex *.tex *.bib
	$(PDFLATEX) $<
	-$(BIBTEX)  $(basename $<)
	$(PDFLATEX) $<
	$(PDFLATEX) $<
#-------------------------------------------------------------------------------

new:
	if [ $(TEXLIVE) -ge 2007 -a $(TEXLIVE) -lt 2100 ]; then \
	  sed s/atlas-document/$(BASENAME)/ template/atlas-document.tex | \
	    sed 's/texlive=20[0-9][0-9]/texlive=$(TEXLIVE)/' >$(BASENAME).tex; \
	else \
	  echo "Invalid value for TEXLIVE: $(TEXLIVE)"; \
	  sed s/atlas-document/$(BASENAME)/ template/atlas-document.tex >$(BASENAME).tex; \
	fi
	cp template/atlas-document-metadata.tex $(BASENAME)-metadata.tex
	touch $(BASENAME).bib
	touch $(BASENAME)-defs.sty

newtexmf:
	if [ $(TEXLIVE) -ge 2007 -a $(TEXLIVE) -lt 2100 ]; then \
	  sed s/atlas-document/$(BASENAME)/ template/atlas-document-texmf.tex | \
	    sed 's/texlive=20[0-9][0-9]/texlive=$(TEXLIVE)/' >$(BASENAME).tex; \
	else \
	  echo "Invalid value for TEXLIVE: $(TEXLIVE)"; \
	  sed s/atlas-document/$(BASENAME)/ template/atlas-document-texmf.tex >$(BASENAME).tex; \
	fi
	cp template/atlas-document-metadata.tex $(BASENAME)-metadata.tex
	touch $(BASENAME).bib
	touch $(BASENAME)-defs.sty

newbook:
	if [ $(TEXLIVE) -ge 2007 -a $(TEXLIVE) -lt 2100 ]; then \
	  sed s/atlas-document/$(BASENAME)/ template/atlas-book.tex | \
	    sed 's/texlive=20[0-9][0-9]/texlive=$(TEXLIVE)/' >$(BASENAME).tex; \
	else \
	  echo "Invalid value for TEXLIVE: $(TEXLIVE)"; \
	  sed s/atlas-document/$(BASENAME)/ template/atlas-book.tex >$(BASENAME).tex; \
	fi
	cp template/atlas-document-metadata.tex $(BASENAME)-metadata.tex
	touch $(BASENAME).bib
	touch $(BASENAME)-defs.sty

newbooktexmf:
	if [ $(TEXLIVE) -ge 2007 -a $(TEXLIVE) -lt 2100 ]; then \
	  sed s/atlas-document/$(BASENAME)/ template/atlas-book-texmf.tex | \
	    sed 's/texlive=20[0-9][0-9]/texlive=$(TEXLIVE)/' >$(BASENAME).tex; \
	else \
	  echo "Invalid value for TEXLIVE: $(TEXLIVE)"; \
	  sed s/atlas-document/$(BASENAME)/ template/atlas-book-texmf.tex >$(BASENAME).tex; \
	fi
	cp template/atlas-document-metadata.tex $(BASENAME)-metadata.tex
	touch $(BASENAME).bib
	touch $(BASENAME)-defs.sty

draftcover:
	if [ $(TEXLIVE) -ge 2007 -a $(TEXLIVE) -lt 2100 ]; then \
	  sed 's/texlive=20[0-9][0-9]/texlive=$(TEXLIVE)/' template/atlas-draft-cover.tex \
	    >$(BASENAME)-draft-cover.tex; \
	else \
	  echo "Invalid value for TEXLIVE: $(TEXLIVE)"; \
	  cp  template/$(BASENAME)-draft-cover.tex $(BASENAME)-draft-cover.tex; \
	fi

preprintcover:
	sed 's/texlive=20[0-9][0-9]/texlive=$(TEXLIVE)/' template/atlas-preprint-cover.tex >$(BASENAME)-preprint-cover.tex
	#cp template/atlas-preprint-cover.tex $(BASENAME)-preprint-cover.tex

auxmat:
	sed s/atlas-document/$(BASENAME)/ template/atlas-auxmat.tex | \
	sed 's/texlive=20[0-9][0-9]/texlive=$(TEXLIVE)/' >$(BASENAME)-auxmat.tex

run_latex: dvipdf

# Targets if you run latex instead of pdflatex
dvipdf:	$(BASENAME).dvi
	$(DVIPDF) -sPAPERSIZE=a4 -dPDFSETTINGS=/prepress $<
	@echo "Made $(basename $<).pdf"

dvips:	$(BASENAME).dvi
	$(DVIPS) $<
	@echo "Made $(basename $<).ps"

# Specify dependencies for running latex
#%.dvi:	%.tex tex/*.tex bibtex/bib/*.bib
%.dvi:	%.tex *.tex *.bib
	$(LATEX)    $<
	-$(BIBTEX)  $(basename $<)
	$(LATEX)    $<
	$(LATEX)    $<

%.bbl:	%.tex *.bib
	$(LATEX) $<
	$(BIBTEX) $<

help:
	@echo "To create a new document give the commands:"
	@echo "make new [BASENAME=mydocument] [TEXLIVE=YYYY]"
	@echo "make"
	@echo "If your bib files are not in the main directory, adjust the %.pdf target accordingly." 
	@echo ""
	@echo "If you want to write a long document (book) like a TDR:"
	@echo "make newbook [BASENAME=mydocument] [TEXLIVE=YYYY]"
	@echo ""
	@echo "If atlaslatex is installed centrally, e.g. in ~/texmf:"
	@echo "make newtexmf [BASENAME=mydocument] [TEXLIVE=YYYY]"
	@echo "make newbooktexmf [BASENAME=mydocument] [TEXLIVE=YYYY]"
	@echo ""
	@echo "If you need a standalone draft cover give the commands:"
	@echo "make draftcover [BASENAME=mydocument] [TEXLIVE=YYYY]"
	@echo "pdflatex mydocument-draft-cover"
	@echo ""
	@echo "If you need a standalone preprint cover give the commands:"
	@echo "make preprintcover [BASENAME=mydocument] [TEXLIVE=YYYY]"
	@echo "pdflatex mydocument-preprint-cover"
	@echo ""
	@echo "If you need a document for auxiliary material give the commands:"
	@echo "make auxmat [BASENAME=mydocument] [TEXLIVE=YYYY]"
	@echo "pdflatex mydocument-auxmat"
	@echo ""
	@echo "make clean    to clean auxiliary files (not output PDF)"
	@echo "make cleanpdf to clean output PDF files"
	@echo "make cleanps  to clean output PS files"
	@echo "make cleanall to clean all files"
	@echo "make cleanepstopdf to clean PDF files automatically made from EPS"
	@echo ""

clean:
	-rm *.dvi *.toc *.aux *.log *.out \
		*.bbl *.blg *.brf *.bcf *-blx.bib *.run.xml \
		*.cb *.ind *.idx *.ilg *.inx \
		*.synctex.gz *~ *.fls *.fdb_latexmk .*.lb spellTmp 

cleanpdf:
	-rm $(BASENAME).pdf 
	-rm $(BASENAME)-draft-cover.pdf $(BASENAME)-preprint-cover.pdf
	-rm $(BASENAME)-auxmat.pdf

cleanps:
	-rm $(BASENAME).ps 
	-rm $(BASENAME)-draft-cover.ps $(BASENAME)-preprint-cover.ps
	-rm $(BASENAME)-auxmat.ps

cleanall: clean cleanpdf cleanps

# Clean the PDF files created automatically from EPS files
cleanepstopdf: $(EPSTOPDFFILES)
	@echo "Removing PDF files made automatically from EPS files"
	-rm $^
