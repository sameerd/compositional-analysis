library(compositions)
library(reshape2)

x <- read.csv("data/freqAnalOff_MAMcsfreqBinsMM_FINAL.csv")
x$FreqBinName <- paste0("FreqBin", x$FreqBin)
x.reshape <- dcast(x, id+TimePt+Group~FreqBinName, value.var="emg50")

dat.useful <- x.reshape[, c("Group", paste0("FreqBin", 1:4))]

dat.split <- split(dat.useful, dat.useful$Group)

dat.group0 <- dat.split[[1]]
dat.group0$Group <- NULL

dat.group1 <- dat.split[[2]]
dat.group1$Group <- NULL

dat0.rcomp <- rcomp(dat.group0)
dat1.rcomp <- rcomp(dat.group1)


