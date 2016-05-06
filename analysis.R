## ----setup, cache=TRUE, echo=TRUE----------------------------------------
library(knitr)
opts_chunk$set(fig.path="figure/compositional-", cache.path="cache/compositional-")


library(compositions)
library(reshape2)

# read in the csv data
x <- read.csv("data/freqAnalOff_MAMcsfreqBinsMM_FINAL.csv")


# Change add a character version of FreqBin
x$FreqBinName <- paste0("FreqBin", x$FreqBin)
x$Group <- factor(as.numeric(x$Group), levels=c(0, 1), labels=c("A", "B"))

# reshape the data so that it is wide instead of long
x.reshape <- dcast(x, id+TimePt+Group~FreqBinName, value.var="emg50")

## ----verify1, cache=TRUE, echo=TRUE--------------------------------------
# verify that the frequencies add up to 1
freqsums <- x.reshape$FreqBin1 + x.reshape$FreqBin2 + x.reshape$FreqBin3 + x.reshape$FreqBin4
plot(freqsums)

## ----verify2, cache=TRUE, echo=TRUE--------------------------------------
# split all the data by TimePt
x.split <- split(x.reshape, x.reshape$TimePt)

# we are making an assumption here that all the patients are in the same order 
# on each split. No way to verify this given the data because there is no patient 
# id but but the group orders look like they match
all.equal(x.split[[1]]$Group, x.split[[2]]$Group)
all.equal(x.split[[1]]$Group, x.split[[3]]$Group)
all.equal(x.split[[1]]$Group, x.split[[4]]$Group)
all.equal(x.split[[1]]$Group, x.split[[5]]$Group)

# Lets make this explicit by making the id equal to the patient id
# FIXME: VERIFY THIS FROM THE ORIGINAL DATA
for(i in 2:5) {
  x.split[[i]]$id <- x.split[[1]]$id
}

## ----setup2, echo=TRUE, cache=TRUE---------------------------------------
# data to analyze in wide format with 4 bins
x4 <- x.split

# Combine bins 1 and 2 so that we have data with 3 bins
# Rename the combined bin FreqBin12
x3 <- lapply(x4, function(z) {
  z$FreqBin1 <- z$FreqBin1 + z$FreqBin2
  z$FreqBin2 <- NULL
  names(z) <- sub("FreqBin1", "FreqBin12", names(z))
  z
})

# now further split x3 and x4 by group
x4 <- lapply(x4, function(z) split(z, z$Group))
x3 <- lapply(x3, function(z) split(z, z$Group))

# Function to just extract columns named FreqBin
ExtractFreqBins <- function(z.df) z.df[, grep("FreqBin", names(z.df))]

## ----comp-analysis, echo=TRUE, cache=TRUE--------------------------------
x3.acomps <- lapply(x3, function(z) lapply(z, function(y) acomp(ExtractFreqBins(y))))

perturbs.acomps.A <- lapply(1:5, function(i) x3.acomps[[i]][["A"]] - x3.acomps[[1]][["A"]])
perturbs.acomps.B <- lapply(1:5, function(i) x3.acomps[[i]][["B"]] - x3.acomps[[1]][["B"]])

## ----comp-plot1, echo=TRUE, cache=TRUE-----------------------------------
# Plot the perturbation differences between the various time intervals
op <- par(mfrow=c(3,2))
for (i in 1:5) {
  plot(perturbs.acomps.A[[i]])
  plot(perturbs.acomps.B[[i]], add=TRUE, col="red")
}
par(op)
lapply(perturbs.acomps.A, mean)

