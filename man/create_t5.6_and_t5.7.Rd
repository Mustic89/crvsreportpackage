% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/create_table_5_6_&_5_7.R
\name{create_t5.6_and_t5.7}
\alias{create_t5.6_and_t5.7}
\title{Creates Tables 5.6 & 5.7}
\usage{
create_t5.6_and_t5.7(
  data,
  ru_filter = NULL,
  age_var,
  date_var = "dodyr",
  data_year = NA,
  tablename = "Table_5_6",
  output_path = NULL
)
}
\arguments{
\item{data}{Death records data frame.}

\item{ru_filter}{Type of region to filer by (urban/rural). Optional.}

\item{age_var}{Age of deceased column of the dataframe.}

\item{date_var}{Event year column of the dataframe. Defaults to "dodyr".}

\item{data_year}{The year to report on. Defaults to the last in the data.}

\item{tablename}{Name of the table to be saved as a csv file. Optional.}

\item{output_path}{The path to export the generated csv table. Optional.}
}
\value{
A data frame of tabulated results
}
\description{
Table 5.6 Deaths by age and sex of decedent (urban areas)

Table 5.7 Deaths by age and sex of decedent (rural areas)

Variables needed per record:

- `dodyr`: Year of death.

- `death2r`: Rural-Urban Identifier. Optional.

- `death2c`: Sex of the deceased.

- `death2b`: Age of the deceased. Ideally in a grouped format.
}
\examples{
death_data <- construct_sample_death_data()
death_data <- construct_year(death_data, date_col = "death1a", year_col = "dodyr")
death_data <- construct_age(death_data, dob_col = "death2a", age_col = "death2b", end_date_col = "death1a")
death_data <- construct_age_group(death_data, age_col = "death2b", new_col = "death2b_grp")
table_5_6 <- create_t5.6_and_t5.7(death_data, ru_filter = "urban", age_var = "death2b_grp", data_year = 2022)
}
