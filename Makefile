.PHONY: tbs dep vrl multigp quadrivals rookies maionhigh boners wtt ddr22 formula

all: tbs dep vrl multigp maionhigh ddr22 wtt formula quadrivals

misc: formula qr22 ddr22 tdrf22 wtt

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
	./getcollection.zsh "TBS EU SPEC SERIES 11.csv"
	./makerank.zsh "TBS EU SPEC SERIES 11.csv"
	./getcollection.zsh "TBS EU SPEC SERIES 12.csv"
	./makerank.zsh "TBS EU SPEC SERIES 12.csv"

dep:
	./getcollection.zsh "DEP OPEN SERIES.csv"
	./makerank.zsh "DEP OPEN SERIES.csv"
	./getcollection.zsh "DEP OPEN SERIES 03.csv"
	./makerank.zsh "DEP OPEN SERIES 03.csv"
	./getcollection.zsh "DEP OPEN SERIES 04.csv"
	./makerank.zsh "DEP OPEN SERIES 04.csv"
	./getcollection.zsh "DEP OPEN SERIES 05.csv"
	./makerank.zsh "DEP OPEN SERIES 05.csv"
	./getcollection.zsh "DEP OPEN SERIES 06.csv"
	./makerank.zsh "DEP OPEN SERIES 06.csv"

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
	./getcollection.zsh "VRL SERIES 09.csv"
	./makerank.zsh "VRL SERIES 09.csv"

multigp:
	./getcollection.zsh "MultiGP Tracks.csv"
	./makerank.zsh "MultiGP Tracks.csv"
	./getcollection.zsh "MGP2022.csv"
	./makerank.zsh "MGP2022.csv"
	./getcollection.zsh "MGP2023.csv"
	./makerank.zsh "MGP2023.csv"

quadrivals:
	./getcollection.zsh "QuadRivals Tracks.csv"
	./makerank.zsh "QuadRivals Tracks.csv"
	./getcollection.zsh "QRivals21.csv"
	./makerank.zsh "QRivals21.csv"
	./getcollection.zsh "QRivals22.csv"
	./makerank.zsh "QRivals22.csv"
	
qr21:
	./getcollection.zsh "QRivals21.csv"
	./makerank.zsh "QRivals21.csv"
	
qr22:
	./getcollection.zsh "QRivals22.csv"
	./makerank.zsh "QRivals22.csv"

rookies:
	./getcollection.zsh "Rookies Tracks.csv"
	./makerank.zsh "Rookies Tracks.csv"

formula:
	./getcollection.zsh "FormulaFlow.csv"
	./makerank.zsh "FormulaFlow.csv"

ddr22:
	./getcollection.zsh "DDR22.csv"
	./makerank.zsh "DDR22.csv"

tdrf22:
	./getcollection.zsh "TDRF22.csv"
	./makerank.zsh "TDRF22.csv"

maionhigh:
	./getcollection.zsh "MaiOnHigh Tracks.csv"
	./makerank.zsh "MaiOnHigh Tracks.csv"

boners:
	./getcollection.zsh "Boners Tracks.csv"
	./makerank.zsh "Bonners Tracks.csv"
	
wtt:
	./getcollection.zsh "Weekly Time Trials Tracks.csv"
	./makerank.zsh "Weekly Time Trials Tracks.csv"
