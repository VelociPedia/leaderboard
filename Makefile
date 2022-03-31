.PHONY: tbs dep vrl multigp quadrivals rookies maionhigh boners wtt wttnow

all: tbs dep vrl multigp quadrivals rookies maionhigh boners wtt wttnow

clean:
	rm data/pilots/*
	rm data/ranking/*
	rm md/leaderboards/*
	rm md/pilots/*
	
tbs:
	./getcollection.zsh "TBS EU SPEC SERIES.csv"
	./makerank.zsh "TBS EU SPEC SERIES.csv"
	./getcollection.zsh "RCTech.de EU SPEC SERIES 02.csv"
	./makerank.zsh "RCTech.de EU SPEC SERIES 02.csv"
	./getcollection.zsh "RCTech.de EU SPEC SERIES 03.csv"
	./makerank.zsh "RCTech.de EU SPEC SERIES 03.csv"
	./getcollection.zsh "TBS EU SPEC SERIES 04.csv"
	./makerank.zsh "TBS EU SPEC SERIES 04.csv"
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

dep:
	./getcollection.zsh "DEP OPEN SERIES.csv"
	./makerank.zsh "DEP OPEN SERIES.csv"
	./getcollection.zsh "DEP OPEN SERIES 03.csv"
	./makerank.zsh "DEP OPEN SERIES 03.csv"
	./getcollection.zsh "DEP OPEN SERIES 04.csv"
	./makerank.zsh "DEP OPEN SERIES 04.csv"
	./getcollection.zsh "DEP OPEN SERIES 05.csv"
	./makerank.zsh "DEP OPEN SERIES 05.csv"

vrl:
	./getcollection.zsh "VRL SERIES.csv"
	./makerank.zsh "VRL SERIES.csv"
	./getcollection.zsh "VRL SERIES 03.csv"
	./makerank.zsh "VRL SERIES 03.csv"
	./getcollection.zsh "VRL SERIES 04.csv"
	./makerank.zsh "VRL SERIES 04.csv"
	./getcollection.zsh "VRL SERIES 05.csv"
	./makerank.zsh "VRL SERIES 05.csv"
	./getcollection.zsh "VRL SERIES 06.csv"
	./makerank.zsh "VRL SERIES 06.csv"
	./getcollection.zsh "VRL SERIES 07.csv"
	./makerank.zsh "VRL SERIES 07.csv"
	./getcollection.zsh "VRL SERIES 08.csv"
	./makerank.zsh "VRL SERIES 08.csv"

multigp:
	./getcollection.zsh "MultiGP Tracks.csv"
	./makerank.zsh "MultiGP Tracks.csv"

quadrivals:
	./getcollection.zsh "QuadRivals.csv"
	./makerank.zsh "QuadRivals.csv"

rookies:
	./getcollection.zsh "Rookies Tracks.csv"
	./makerank.zsh "Rookies Tracks.csv"

formula:
	./getcollection.zsh "FormulaFlow.csv"
	./makerank.zsh "FormulaFlow.csv"

ddr22:
		./getcollection.zsh "DDR22.csv"
		./makerank.zsh "DDR22.csv"

maionhigh:
	./getcollection.zsh "MaiOnHigh Tracks.csv"
	./makerank.zsh "MaiOnHigh Tracks.csv"

boners:
	./getcollection.zsh "Boners Tracks.csv"
	./makerank.zsh "Bonners Tracks.csv"
	
wtt:
	./getcollection.zsh "Weekly Time Trials Tracks.csv"
	./makerank.zsh "Weekly Time Trials Tracks.csv"
	
wttnow:
		./getcollection.zsh "WTT-current.csv"