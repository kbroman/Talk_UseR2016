# illustration of R/qtl data file

library(broman)
iron <- read.csv("iron.csv", stringsAsFactors=FALSE)
iron[1:2,1:4] <- ""
excel_fig(iron, "../Figs/datafile.pdf")
excel_fig(iron, "../Figs/datafile_bw.pdf")
