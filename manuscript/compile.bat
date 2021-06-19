@echo off
pandoc header.yml manuscript.md --template=template_min.tex --filter pandoc-crossref --citeproc -o manuscript.docx
pandoc header.yml manuscript.md --template=template_min.tex --filter pandoc-crossref --citeproc -o manuscript.tex
pandoc header.yml manuscript.md --template=template_min.tex --filter pandoc-crossref --citeproc --pdf-engine=lualatex -o manuscript.pdf