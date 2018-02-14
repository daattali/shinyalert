  #!usr/bin/make -f
# All commands are run as R functions rather than shell commands so that it will work easily on any Windows machine, even if the Windows machine isn't properly set up with all the right tools

all: README.md

clean:
	Rscript -e 'suppressWarnings(file.remove("README.md", "vignettes/shinyalert.md"))'

.PHONY: all clean
.DELETE_ON_ERROR:
.SECONDARY:

README.md : vignettes/shinyalert.Rmd
#	echo "Rendering the shinyalert vignette"
	Rscript -e 'rmarkdown::render("vignettes/shinyalert.Rmd", output_format = "md_document", output_options = list(pandoc_args = c("-t", "commonmark+raw_html")))'
#	echo "Correcting image paths"
#	sed -i -- 's,../inst,inst,g' vignettes/shinyalert.md
	Rscript -e 'file <- gsub("\\.\\./inst", "inst", readLines("vignettes/shinyalert.md")); writeLines(file, "vignettes/shinyalert.md")'
#	echo "Correcting paths to other reference vignettes"
	Rscript -e 'file <- gsub("\\((.*)\\.([rR]md)","(vignettes/\\1.\\2", readLines("vignettes/shinyalert.md")); writeLines(file, "vignettes/shinyalert.md")'
#	echo "Copying output to README.md"
#	cp vignettes/shinyalert.md README.md
	Rscript -e 'file.copy("vignettes/shinyalert.md", "README.md", overwrite = TRUE)'
	Rscript -e 'suppressWarnings(file.remove("vignettes/shinyalert.md"))'
