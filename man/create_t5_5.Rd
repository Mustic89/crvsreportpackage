% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/create_table_5_5.R
\name{create_t5_5}
\alias{create_t5_5}
\title{Creates Table 5.5}
\usage{
create_t5_5(
  data,
  date_var = "dodyr",
  data_year = NA,
  tablename = "Table_5_5",
  output_path = NULL
)
}
\arguments{
\item{data}{data frame being used}

\item{date_var}{occurrence data variable being used}

\item{data_year}{year the data is for}

\item{tablename}{name for csv output use _ instead of . for names}
}
\value{
data frame with tabulated results
}
\description{
Table 5.5 Deaths by region of death and site of occurrence

Variables needed per record:

- `dodyr`: Year of death.

- `death1c`: Region of death.

- `death1n`: Site of occurrence.
}
\examples{
death_data <- construct_sample_death_data()
death_data <- construct_year(death_data, date_col = "death1a", year_col = "dodyr")
table_5_5 <- create_t5_5(death_data, date_var= "dodyr", data_year = 2022)
}
