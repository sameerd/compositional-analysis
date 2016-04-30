library(compositions)
library(reshape2)

# read in the csv data
x <- read.csv("data/freqAnalOff_MAMcsfreqBinsMM_FINAL.csv")

# Change add a character version of FreqBin
x$FreqBinName <- paste0("FreqBin", x$FreqBin)

# reshape the data so that it is wide instead of long
x.reshape <- dcast(x, id+TimePt+Group~FreqBinName, value.var="emg50Cs")

# Extract userful columns
dat.useful <- x.reshape[, c("Group", paste0("FreqBin", 1:4))]

# Split data into treatment and control groups
dat.split <- split(dat.useful, dat.useful$Group)

dat.group0 <- dat.split[[1]]
dat.group0$Group <- NULL

dat.group1 <- dat.split[[2]]
dat.group1$Group <- NULL

# apply relative compositions
dat0.rcomp <- rcomp(dat.group0)
dat1.rcomp <- rcomp(dat.group1)


