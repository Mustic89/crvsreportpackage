#' creates Tables 4.5, 4.5 and 4.6
#'
#' @description
#' Table 4.4 Live births by age of mother and type of birth
#' @description
#' Table 4.5 Live births by age and marital status of mother, urban areas
#' @description
#' Table 4.6 Live births by age and marital status of mother, rural areas
#'
#' @param data the dataframe being used
#' @param data_year the year of the data needed
#' @param by_var the variable the data is being grouped by
#' @param rural_urban if this is no then no rural/urban split is used. Else specify "rural" or "urban"
#' @param col_var variable of data being used e.g. fert_age_grp
#' @param tablename name of the table being saved as a csv file
#' @param output_path The path to export the generated table
#'
#' @return tabulated data
#' @export
#'
#' @import dplyr
#' @import tidyr
#' @import janitor
#'
#' @examples t4.4 <- create_t4.4_to_4_6(bth_data, data_year = 2022, col_var = fert_age_grp, by_var = birth1g, rural_urban = "no", tablename = "Table_4_4")
#' t4.5 <- create_t4.4_to_4_6(bth_data, year = 2022, col_var = fert_age_grp, by_var = birth3c, rural_urban = "urban", tablename = "Table_4_5")
#' t4.6 <- create_t4.4_to_4_6(bth_data, year = 2022, col_var = fert_age_grp, by_var = birth3c, rural_urban = "rural", tablename = "Table_4_6")

create_t4.4_to_4_6 <- function(data, data_year = NA, col_var = fert_age_grp,
                               by_var = birth1g, rural_urban = "no",
                               tablename = "Table_4_4", output_path = NULL){

  # if data_year is not provided, take the latest year in the data
  data_year <- handle_data_year(data_year, data, date_var)

  # Ensure data for fer_age_group is handled as a straight string, not a factor
  # Avoids issues with fert_age_grp
  data$fert_age_grp <- as.character(data$fert_age_grp)

  if(rural_urban == "no"){
    output <- data |>
      filter(doryr == data_year & is.na(birth1j)) |>
      group_by(!!sym(col_var), !!sym(by_var)) |>
      mutate(!!sym(by_var) := ifelse(is.na(!!sym(by_var)), 0, !!sym(by_var)),
             !!sym(col_var) := ifelse(is.na(!!sym(col_var)), "Not Stated", !!sym(col_var))) |>
      summarise(Total = n()) |>
      pivot_wider(names_from = !!sym(by_var), values_from = Total, values_fill = 0) |>
      adorn_totals(c("col","row"))

    output <- output[c(9, 1:8, 10),]
    return(handle_table_output(output, output_path, tablename))
  } else {
    output <- data |>
      filter(doryr == data_year & is.na(birth1j) & birth3n == rural_urban) |>
      group_by(!!sym(col_var), !!sym(by_var)) |>
      mutate(!!sym(by_var) := ifelse(is.na(!!sym(by_var)), 0, !!sym(by_var)),
             !!sym(col_var) := ifelse(is.na(!!sym(col_var)), "Not Stated", !!sym(col_var))) |>
      summarise(Total = n()) |>
      pivot_wider(names_from = !!sym(by_var), values_from = Total, values_fill = 0 ) |>
      adorn_totals(c("col","row"))

    output <- output[c(9, 1:8, 10),]

    return(handle_table_output(output, output_path, tablename))
}
}


