% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/trajectory.R
\name{set_attribute}
\alias{set_attribute}
\title{Add a set attribute activity}
\usage{
set_attribute(.trj, key, value, global = FALSE)
}
\arguments{
\item{.trj}{the trajectory object.}

\item{key}{the attribute key (coerced to a string).}

\item{value}{the value to set, accepts either a numeric or a callable object
(a function) which must return a numeric.}

\item{global}{if \code{TRUE}, the attribute will be global instead of per-arrival.}
}
\value{
Returns the trajectory object.
}
\description{
Modify an attribute in the form of a key/value pair.
}

