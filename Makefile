.PHONY: tbs dep maionhigh beginner quadrivals multigp

all: tbs dep maionhigh beginner

tbs:
	./getcollection.zsh "RCTech.de EU SPEC SERIES 02.csv"
	./makerank.zsh "RCTech.de EU SPEC SERIES 02.csv"
	./getcollection.zsh "RCTech.de EU SPEC SERIES 03.csv"
	./makerank.zsh "RCTech.de EU SPEC SERIES 03.csv"
	./getcollection.zsh "TBS EU SPEC SERIES 05.csv"
	./makerank.zsh "TBS EU SPEC SERIES 05.csv"
	./getcollection.zsh "TBS EU SPEC SERIES 06.csv"
	./makerank.zsh "TBS EU SPEC SERIES 06.csv"
	./getcollection.zsh "TBS EU SPEC SERIES 07.csv"
	./makerank.zsh "TBS EU SPEC SERIES 07.csv"
	./getcollection.zsh "TBS EU SPEC SERIES 08.csv"
	./makerank.zsh "TBS EU SPEC SERIES 08.csv"
	./getcollection.zsh "TBS EU SPEC SERIES 09.csv"
	./makerank.zsh "TBS EU SPEC SERIES 09.csv"
	./getcollection.zsh "TBS EU SPEC SERIES 10.csv"
	./makerank.zsh "TBS EU SPEC SERIES 10.csv"
	./getcollection.zsh "TBS EU SPEC SERIES.csv"
	./makerank.zsh "TBS EU SPEC SERIES.csv"

multigp:
	./getcollection.zsh "MultiGP.csv"
	./makerank.zsh "MultiGP.csv"

dep:
	./getcollection.zsh "DEP OPEN SERIES 03.csv"
	./makerank.zsh "DEP OPEN SERIES 03.csv"
	./getcollection.zsh "DEP OPEN SERIES 04.csv"
	./makerank.zsh "DEP OPEN SERIES 04.csv"
	./getcollection.zsh "DEP OPEN SERIES 05.csv"
	./makerank.zsh "DEP OPEN SERIES 05.csv"
	./getcollection.zsh "DEP OPEN SERIES.csv"
	./makerank.zsh "DEP OPEN SERIES.csv"

quadrivals:
	./getcollection.zsh "QuadRivals.csv"
	./makerank.zsh "QuadRivals.csv"

maionhigh:
	./getcollection.zsh "MaiOnHightracks.csv"
	./makerank.zsh "MaiOnHightracks.csv"

beginner:
	./getcollection.zsh "beginner.csv"
	./makerank.zsh "beginner.csv"