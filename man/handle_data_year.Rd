% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/handle_data_year.R
\name{handle_data_year}
\alias{handle_data_year}
\title{Handle Data Year}
\usage{
handle_data_year(data_year = NULL, data, date_var)
}
\arguments{
\item{data_year}{The data year to use for filtering (NULL by default).}

\item{data}{The dataset}

\item{date_var}{The variable with the dates, in years}
}
\value{
The data year to use for filtering, last one if none passed in.
}
\description{
This function takes the data year, if empty it will select the last one.
}
\examples{
handle_data_year <- function(data_year = NULL, data, date_var)
}
