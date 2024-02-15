#!/usr/bin/Rscript

print(" ========  preprocessing data ===========")

print(" --- read 'group' file containing column 1: mzXML, column 2: Group name")
data <- read.table(file=file.path("extdata/group"))
mz_xmls <- data[, 1]
group <- data[, 2]

suppressPackageStartupMessages({
  library(parallel)
  library(BiocParallel)
  library(omicsViewer)
  library(xcms)
  library(xcmsViewer)
})

# loading annotation data
data("hmdb_msdial")

pd <- data.frame(file = file.path("extdata", mz_xmls), stringsAsFactors = FALSE)

pd$label <- sub(".mzXML", "", basename(pd$file))
pd$group <- group

print(pd)

# feature identification and quantification
res <- runPrunedXcmsSet(
files = pd$file, # path to the files
pheno = pd, # phenotype data
tmpdir = "/extdata/temp", # folder to store temporary files, needs to be an empty folder or not existing then a new folder will be created
keepMS1 = FALSE, # should the MS1 be kept, if yes, we can generate chromatogram give an intensity range. But it will make the data much larger. 
mode = "neg", # ionization mode, "pos" or "neg"
ref = hmdb_msdial, # feature annotation database
RTAdjustParam = PeakGroupsParam(minFraction = 0.5, span = 0.5), #  retention time adjustment parameter, will be passed to "adjustRtimePeakGroups"
ppmtol = 20, # mass tolerance in PPM
mclapplyParam = list(fun_parallel = mclapply, mc.cores = 4) # parallel
)

#saveRDS(res, file = "/extdata/xcmsViewer_intermediate_obj.RDS") # save the data
#res <- readRDS("/extdata/xcmsViewer_intermediate_obj.RDS")

# statistical analysis
expr <- log10( exprs(res@featureSet) ) # usually we log10 transform the original expression matrix. 
boxplot(expr)
exprs(res@featureSet) <- normalize.nQuantiles(expr, probs = 0.5) # median centering of columns of expression matrix

tcs <- rbind(append(c("group"), unique(pd$group))) # define a matrix tells which groups should be compared
viewerObj <- prepViewerData( object = res, median.center = FALSE, compare.t.test = tcs,  fillNA = TRUE, paired = FALSE)
saveRDS(viewerObj, "extdata/res.RDS")
