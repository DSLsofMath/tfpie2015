NAME=dslsofmath

default: $(NAME).pdf

dslsofmath.pdf:  $(NAME).md template.latex
	pandoc -s -f markdown+lhs -N --number-offset=1 --template template.latex $(NAME).md -o $(NAME).tex && latexmk -pdf $(NAME).tex
clean:
	- rm *.pag *.aux *.bbl *.blg *.fdb_latexmk *.log $(NAME).tex $(NAME).pdf *.idx *.ilg *.ind *.toc *~ *.vrb *.snm *.fls *.nav *.out

