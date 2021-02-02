spelling:
	Rscript -e "spelling::spell_check_files(c('NEWS'), ignore=readLines('inst/WORDLIST', warn=FALSE))"
