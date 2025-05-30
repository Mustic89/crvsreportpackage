% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/handle_table_output.R
\name{handle_table_output}
\alias{handle_table_output}
\title{Handle Table Output}
\usage{
handle_table_output(table, output_path = NULL, tablename)
}
\arguments{
\item{table}{The table to output}

\item{output_path}{The path to output the table, will be NULL by default}

\item{tablename}{The name of the .csv file with the table}
}
\value{
The table passed in, if an output path is given it will save the csv.
}
\description{
This function takes a table and handles the output creation part.
}
\examples{
handle_table_output <- function(table, output_path, tablename)
}
