#' Create Table 3.10
#'
#'Table 3.10 Adjustment of deaths by age group and birth2a of decedent
#'
#' @param data dataframe being used
#' @param dth_est dataframe being used with estimated Death data
#' @param date_var occurrence data being used e.g. dobyr, dodyr etc
#' @param data_year year the data is for
#' @param tablename name of the table being saved as a csv file
#'
#' @return data frame of tabulated results
#' @export
#'
#' @import dplyr
#' @import tidyr
#' @import janitor
#'
#' @examples t3.10 <- create_t3.10(dth_data, date_var = dodyr, data_year = 2022, tablename = "Table_3_10")
#'
create_t3.10 <- function(data, dth_est, date_var, data_year=NA, tablename = NA){
  # if data_year is not provided, take the latest year in the data
  if (is.na(data_year)){
    data_year = data %>% pull({{date_var}}) %>% max(na.rm = TRUE)
  }

  output <- data |>
    filter(!!sym(date_var) == data_year, birth2a != "not stated") |>
    group_by(age_grp_wide, birth2a) |>
    summarise(reg_deaths = n()) |>
    rename(age_grp = age_grp_wide)

  output_all <- output  |>
     mutate(birth2a = "total") |>
     group_by(age_grp, birth2a) |>
     summarise(reg_deaths = sum(reg_deaths))

  output <- rbind(output_all, output)

  d_est_prop <- dth_est  |>
    filter(year == data_year ) |>
    group_by(age_grp) |>
    summarise(female = sum(female), male = sum(male)) |>
    pivot_longer(cols = c(female, male) , names_to = "birth2a", values_to = "est_count")

  d_est_prop_all <- d_est_prop |>
    mutate(birth2a = "total") |>
    group_by(age_grp, birth2a) |>
    summarise(est_count = sum(est_count))

  d_est_prop <- rbind(d_est_prop_all, d_est_prop)

  output <- left_join(output, d_est_prop, by= c("age_grp", "birth2a")) |>
    mutate(completeness = construct_round_excel((reg_deaths/est_count),2)) |>
    mutate(adjusted = floor((reg_deaths/ completeness)),
           completeness = completeness * 100) |>
    select(-c(est_count)) |>
    pivot_wider(names_from = birth2a, values_from = c(reg_deaths, completeness, adjusted))

  output_dir <- "./outputs"
  if (!dir.exists(output_dir)) {
    dir.create(output_dir, recursive = TRUE)
  }

  write.csv(output, paste0(output_dir, "/", tablename, ".csv"), row.names = FALSE)
  return(output)
}


