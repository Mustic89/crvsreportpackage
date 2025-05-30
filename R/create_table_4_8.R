#' creates table 4.8
#'
#' Table 4.8 Crude birth rate (CBR) by place of usual residence of mother
#'
#' @param data data frame being used
#' @param est_data data frame for estimate data
#' @param pops estimated population sizes by year
#' @param date_var occurrence data variable being used
#' @param data_year year of data
#' @param by_var variable the data is grouped by
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
#' @examples t4.8 <- create_t4.8(bth_data, bth_est, dobyr, data_year = 2022, by_var = birth1c, tablename = "Table_4_8")

create_t4.8 <- function(data, est_data, pops, date_var,
                        data_year = NA, by_var = NA,
                        tablename = "Table_4_8", output_path = NULL){

  # if data_year is not provided, take the latest year in the data
  data_year <- handle_data_year(data_year, data, date_var)

  output <- data |>
    filter(!!sym(date_var) == data_year) |>
    group_by(!!sym(by_var)) |>
    summarise(total = n())

  est <- est_data |>
    filter(year == data_year) |>
    group_by(birth1c) |>
    summarise(est_total = sum(total))

  pop <- pops |>
    select(birth1c, paste0("population_", data_year)) |>
    group_by(birth1c) |>
    summarise(total_pop = sum(!!sym(paste0("population_",data_year))))

  output <- left_join(output, est, by = "birth1c") |>
    mutate(completeness = construct_round_excel(total/est_total*100, 2)) |>
    mutate(adjusted = floor(total/(completeness/100)))

  output <- left_join(output, pop, by = "birth1c") |>
    mutate(cbr = construct_round_excel(adjusted/total_pop*1000, 1)) |>
    select(birth1c, total, adjusted, cbr)

  return(handle_table_output(output, output_path, tablename))
}
