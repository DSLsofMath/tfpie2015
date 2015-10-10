NAME=dslm

default: $(NAME).pdf

$(NAME).pdf:  $(NAME).tex
	latexmk -pdf $(NAME).tex

$(NAME).tex: $(NAME).lagda $(NAME).format dslmagda.fmt $(NAME).bib
	lhs2TeX --agda $(NAME).lagda > $(NAME).tex

clean:
	- rm *.ptb *.pag *.aux *.bbl *.blg *.fdb_latexmk *.log $(NAME).tex $(NAME).pdf *.idx *.ilg *.ind *.toc *~ *.vrb *.snm *.fls *.nav *.out

PREPRINT = Ionescu_Jansson_DSLsofMath_TFPIE_2015_paper_preprint.pdf

.PHONY: www

www: ${PREPRINT}
	cp ${PREPRINT} ~/jobb/www/www.cse.chalmers.se/papers/
	unison jobb

${PREPRINT}: ${NAME}.pdf
	ln -s ${NAME}.pdf ${PREPRINT}

# URL: http://www.cse.chalmers.se/~patrikj/papers/Ionescu_Jansson_DSLsofMath_TFPIE_2015_paper_preprint.pdf

upload: DSLsofMath.zip

DSLsofMath.zip: dslm.tex
	-mkdir DSLsofMath
	cp dslm.bib ../eptcsstyle/eptcs.cls ../eptcsstyle/eptcs.bst DSLsofMath/
	sed s+../eptcsstyle/eptcs+eptcs+g dslm.tex > DSLsofMath/dslm.tex
	(cd DSLsofMath; latexmk -pdf)
	zip -r DSLsofMath DSLsofMath
