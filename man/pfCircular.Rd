% Generated by roxygen2 (4.0.1): do not edit by hand
\name{pfCircular}
\alias{pfCircular}
\title{Circular block bootstrap procedure applied to charcoal records compositing
results}
\usage{
pfCircular(comp, b = NULL, conf = c(0.05, 0.95), nboot = 1000,
  AgeLim = NULL)
}
\arguments{
\item{comp}{A "pfComposite" object}

\item{b}{A numeric giving block size, if NULL the optimal block size for a
given series is given by: b= 2x(-1 /log(p)), where p is the lag one
autocorrelation coefficient of that series (Adams, Mann & Ammann 2003).}

\item{conf}{Numeric, calculated confidence intervals.}

\item{nboot}{Numeric, number of bootstrap replicates.}

\item{AgeLim}{Numeric, years defining a period to restrict the analysis to.}
}
\value{
\item{out}{A "pfCircular" object with estimated confidence intervals.}
}
\description{
Block bootstrap has been proposed to test the significances of changes in
stationary time series (Kunsch 1989). This procedure consists of splitting
each charcoal series into n-b+1 overlapping blocks of data, where n is
sample size and b the block size. These blocks are used to reconstruct
resampled individual charcoal series that are in turn used to estimate the
confidence intervals around the charcoal series composite mean.
}
\examples{
ID=pfSiteSel(lat>49, lat<75, long>6, long<50)
plot(ID,zoom="world")
TR1=pfTransform(ID, method=c("MinMax","Box-Cox","Z-Score"),BasePeriod=c(200,2000))

## Circular block bootstrapp

COMP=pfComposite(TR1, binning=TRUE, bins=seq(0,2000,100))
circ=pfCircular(COMP,conf=c(0.005,0.025,0.975,0.995),nboot=100)
plot(circ)
}
\author{
O. Blarquez
}
\references{
Kunsch, H. R. 1989. The jackknife and the bootstrap for general
stationary observation s. The Annals of Statistics 17:1217-1241.

Adams, J. B., M. E. Mann, and C. M. Ammann. 2003. Proxy evidence for an El
Nino-like response to volcanic forcing. Nature 426:274-278.
}

