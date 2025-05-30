#' Creates Tables 4.9 and 4.10
#'
#' @description
#' Table 4.9 Age-specific fertility rates by usual residence of mother, urban areas
#' @description
#' Table 4.10 Age-specific fertility rates by usual residence of mother, rural areas
#'
#' @param data data frame being used
#' @param est_data data frame for estimate data
#' @param pops population estimates
#' @param data_year year of data
#' @param rural_urban whether table is for urban or rural data
#' @param tablename name for csv output use _ instead of . for names
#' @param output_path The path to export the generated table
#'
#' @return data frame with tabulated result
#' @export
#'
#' @import dplyr
#' @import tidyr
#' @import janitor
#'
#' @examples
#' t4.9 <- create_table_4_9_and_4_10(data = bth_data, est_data = bth_est, data_year = 2022,
#'                                  rural_urban = "urban", tablename = "Table_4_9")
#' t4.10 <- create_table_4_9_and_4_10(data = bth_data, est_data = bth_est, data_year = 2022,
#'                                  rural_urban = "rural", tablename = "Table_4_10")

create_table_4_9_and_4_10 <- function(data, est_data, pops, data_year = NA,
                                      rural_urban = "urban",
                                      tablename = "Table_4_9",
                                      output_path = NULL){

  # if data_year is not provided, take the latest year in the data
  data_year <- handle_data_year(data_year, data, date_var)

  output <- data |>
    filter(birth3n == rural_urban, is.na(birth1j) & dobyr == data_year) |>
    group_by(fert_age_grp) |>
    summarise(total = n())

  outputb <- est_data |>
    filter(year == data_year) |>
    group_by(fert_age_grp) |>
    summarise(total_est = sum(total)) |>
    rename(fert_age_est = fert_age_grp)

  output <- left_join(output, outputb, by = c("fert_age_grp"="fert_age_est")) |>
    mutate(completeness = total/total_est) |>
    mutate(adjusted = floor(total/completeness)) |>
    select(-c(total_est, completeness))

  popn <- pops |>
    filter(birth2a == "female") |>
    group_by(fert_age_grp) |>
    summarise(total_pop = sum(population_2022))

  output <- merge(output, popn, by = "fert_age_grp", all.x = TRUE) |>
    mutate(asfr = construct_round_excel(adjusted/total_pop*1000, 2))

  return(handle_table_output(output, output_path, tablename))
}



