\name{shafii.rapeseed}
\alias{shafii.rapeseed}
\docType{data}
\title{
  Multi-environment trial of rapeseed
}
\description{
  Rapeseed yield multi-environment trial, 3 years
}

\format{
  A data frame with 648 observations on the following 5 variables.
  \describe{
    \item{\code{year}}{year, numeric: 87, 88, 89}
    \item{\code{loc}}{location, 14 levels}
    \item{\code{rep}}{rep, 3 levels}
    \item{\code{gen}}{genotype, 6 levels}
    \item{\code{yield}}{yield, kg/ha}
  }
}
\details{
  SAS codes for the analysis can be found at
  http://www.uiweb.uidaho.edu/ag/statprog/ammi/

  The data are from the U.S. National Winter Rapeseed trials conducted
  in 1986, 1987, and 1988.  Trial locations included Georgia (GGA, TGA),
  Idaho (ID), Kansas (KS), Mississippi (MS), Montana (MT), New York
  (NY), North Carolina (NC), Oregon (OR), South Carolina (SC), Tennessee
  (TN), Texas (TX), Virginia (VA), and Washington (WA).


}
\source{
  Bahman Shafii and William J Price, 1998.
  Analysis of Genotype-by-Environment Interaction Using the
  Additive Main Effects and Multiplicative Interaction Model
  and Stability Estimates, \emph{Journal of Agricultural Biological
    Enironmental Statistics}, 3, 335--345.
  http://doi.org/10.2307/1400587

  Electronic version from:
  http://www.uiweb.uidaho.edu/ag/statprog/ammi/yld.data

  Used with permission of Benjamin Price.
}
\references{
  None.
}

\examples{

data(shafii.rapeseed)
dat <- shafii.rapeseed

dat$gen <- with(dat, reorder(gen, yield, mean))
dat$loc <- with(dat, reorder(loc, yield, mean))
dat$yield <- dat$yield/1000

dat <- transform(dat, rep=factor(rep), year=as.factor(as.character(year)))
dat$locyr = paste(dat$loc, dat$year, sep="")

# The 'means' of reps
datm <- aggregate(yield~gen+year+loc+locyr, data=dat, FUN=mean)
datm <- datm[order(datm$gen),]
datm$gen <- as.character(datm$gen)
datm$gen <- factor(datm$gen,
                       levels=c("Bienvenu","Bridger","Cascade",
                         "Dwarf","Glacier","Jet"))
dat$locyr <- reorder(dat$locyr, dat$yield, mean)

require(lattice)
# This picture tells most of the story
# Now change symbols
op <- tpg <- trellis.par.get()
tpg$superpose.symbol$pch <- c('7','8','9')
trellis.par.set(tpg)
dotplot(loc~yield|gen,group=year,data=dat,
        auto.key=list(columns=3),
        main="shafii.rapeseed",ylab="Location")
#dotplot(loc~yield|gen,group=year,data=datm,auto.key=TRUE,
#        main="shafii.rapeseed")

# AMMI biplot.  Remove gen and locyr effects.
m1.lm <- lm(yield ~ gen + locyr, data=datm)
datm$res <- resid(m1.lm)
# Convert to a matrix
if(require(reshape2)){
dm <- melt(datm, measure.var='res', id.var=c('gen', 'locyr'))
dmat <- acast(dm, gen~locyr)
# AMMI biplot.  Figure 1 of Shafii (1998)
biplot(prcomp(dmat), main="shafii.rapeseed - AMMI biplot")
}

trellis.par.set(op) # Unset graphics changes

}

