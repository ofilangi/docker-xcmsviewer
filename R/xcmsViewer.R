#!/usr/bin/Rscript

print(paste("HOST --> ", Sys.getenv("HOST")))
print(paste("PORT --> ", strtoi(Sys.getenv("PORT"))))
print(paste("TRACE --> ", as.logical(Sys.getenv("TRACE"))))

library(shiny)
library(xcmsViewer)

options(shiny.host = Sys.getenv("HOST"))
options(shiny.port = strtoi(Sys.getenv("PORT")))
options(shiny.launch.browser = FALSE)
options(shiny.trace = as.logical(Sys.getenv("TRACE")))
xcmsViewer("/extdata")

# -----------------------------------

library(parallel)
library(BiocParallel)
library(omicsViewer)
library(xcms)
library(xcmsViewer)

res <- readRDS("/extdata/xcmsViewer_intermediate_obj.RDS")
# statistical analysis
expr <- log10( exprs(res@featureSet) ) # usually we log10 transform the original expression matrix. 
boxplot(expr)
exprs(res@featureSet) <- normalize.nQuantiles(expr, probs = 0.5) # median centering of columns of expression matrix

tcs <- rbind(c("group", "A", "B")) # define a matrix tells which groups should be compared
viewerObj <- prepViewerData( object = res, median.center = FALSE, compare.t.test = tcs,  fillNA = TRUE, paired = FALSE)
saveRDS(viewerObj, "extdata/res.RDS")

