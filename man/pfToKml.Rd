% Generated by roxygen2 (4.0.1): do not edit by hand
\name{pfToKml}
\alias{pfToKml}
\title{Export selected site to Google Earth kml format}
\usage{
pfToKml(x, file = "NULL")
}
\arguments{
\item{x}{An object of the class "pfSiteSel"}

\item{file}{File location and name with kml extension e.g.
file="/Users/Olivier/Desktop/truc.kml"}
}
\value{
No value returned.
}
\description{
Export sites selected using pfSiteSel function to Google Earth kml format.
}
\examples{
\dontrun{
x=pfSiteSel(id_site==222)
pfToKml(x,file="site222.kml")
}
}
\author{
O. Blarquez
}

