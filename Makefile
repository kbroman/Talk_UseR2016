STEM = UseR2016

FIGS = Figs/rqtl_lines_code.pdf

$(STEM).pdf: $(STEM).tex header.tex $(FIGS)
	xelatex $<

notes: $(STEM)_withnotes.pdf
all: $(STEM).pdf notes web

$(STEM)_withnotes.pdf: $(STEM)_withnotes.tex header.tex $(FIGS)
	xelatex $(STEM)_withnotes
	pdfnup $(STEM)_withnotes.pdf --nup 1x2 --no-landscape --paper letterpaper --frame true --scale 0.9
	mv $(STEM)_withnotes-nup.pdf $(STEM)_withnotes.pdf

$(STEM)_withnotes.tex: $(STEM).tex Ruby/createVersionWithNotes.rb
	Ruby/createVersionWithNotes.rb $(STEM).tex $(STEM)_withnotes.tex

web: $(STEM).pdf $(STEM)_withnotes.pdf
	scp $(STEM).pdf broman-10.biostat.wisc.edu:Website/presentations/$(STEM).pdf
	scp $(STEM)_withnotes.pdf broman-10.biostat.wisc.edu:Website/presentations/$(STEM)_withnotes.pdf

Figs/rqtl_lines_code.pdf: R/colors.R Data/lines_code_by_version.csv R/rqtl_lines_code.R
		cd R;R CMD BATCH rqtl_lines_code.R

Data/lines_code_by_version.csv: Perl/grab_lines_code.pl Data/versions.txt
		cd Perl;grab_lines_code.pl
