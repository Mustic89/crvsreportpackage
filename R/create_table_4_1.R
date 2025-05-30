
#' Calculates Table 4.1 Births summary table
#'
#' @description
#' Table 4.1 Summary statistics on fertility by year of occurrence
#'
#'
#' @param data births data frame
#' @param est_data estimate data frame
#' @param pops population data frame
#' @param date_var variable for year
#' @param tablename name for csv output use _ instead of . for names
#' @param output_path The path to export the generated table
#'
#' @return data frame with tabulated results
#' @export
#'
#' @import dplyr
#' @import tidyr
#' @import janitor
#'
#' @examples t4.1 <- create_t4.1(bth_data, est_data, pops, date_var = dobyr, tablename = "Table_4_1")
#'
create_t4.1 <- function(data, est_data, pops, date_var = "dobyr", tablename = "Table_4_1", output_path = NULL){
  curr_year <- data %>% pull(!!sym(date_var)) %>% max(na.rm = TRUE)
  years <- construct_year_sequence(curr_year)

  output <- data |>
    filter(is.na(birth1j) & !!sym(date_var) %in% years & birth2a != "not stated") |>
    group_by(birth2a, !!sym(date_var)) |>
    rename(Indicator = birth2a) |>
    summarise(total = n(), .groups = "drop")

  output_counts <- output |>
    pivot_wider(names_from = Indicator, values_from = total, values_fill = list(total = 0))

  output_comp <- est_data |>
    filter(year %in% years) |>
    group_by(year) |>
    summarise(ftotal = sum(female), mtotal = sum(male), .groups = "drop")

  output_counts <- output_counts |>
    rename("year" = all_of(date_var))

  combined_counts <- left_join(output_counts, output_comp, by = c("year" = "year"))

  output_comp <- combined_counts |>
    mutate(male_comp = round(male / mtotal * 100, 1),
           female_comp = round(female / ftotal * 100, 1)) |>
    select(year, male_comp, female_comp) |>
    arrange(year) |>
    pivot_longer(cols = c(male_comp, female_comp), names_to = "Indicator", values_to = "counts") |>
    pivot_wider(names_from = year, values_from = counts)

  output_counts <- output_counts |>
    arrange(year) |>
    pivot_longer(cols = c(male, female), names_to = "Indicator", values_to = "counts") |>
    pivot_wider(names_from = !!sym("year"), values_from = counts, values_fill = list(counts = 0))

  population <- pops |>
    pivot_longer(cols = starts_with("population_"), names_to = "year", values_to = "count") |>
    mutate(year = as.integer(gsub("population_", "", year))) |>
    group_by(year, birth2a) |>
    summarise(total_pop = sum(count), .groups = "drop") |>
    arrange(birth2a)

  output <- output %>%
    rename("year" = all_of(date_var))

  output_cbr <- left_join(output, population, by = c("year" = "year", "Indicator" = "birth2a")) |>
    group_by(year) |>
    summarise(total = sum(total), total_pop = sum(total_pop), .groups = "drop") |>
    mutate(cbr = round((total / total_pop) * 1000, 2)) |>
    select(year, cbr) |>
    mutate(Indicator = "CBR") |>
    pivot_wider(names_from = year, values_from = cbr)

  output_ratio <- output |>
    pivot_wider(names_from = Indicator, values_from = total, values_fill = list(total = 0)) |>
    arrange(year) |>
    mutate(total = male + female,
           Ratio = round((male / female), 2)) |>
    select(year, Ratio) |>
    pivot_wider(names_from = year, values_from = Ratio) |>
    mutate(Indicator = "Ratio") |>
    select(Indicator, starts_with("20"))

  output_ratio <- output_ratio[1,]

  fertility_rates <- construct_fertility_rates(data, pops) |>
    rename(Indicator = fert_age_grp) |>
    filter(Indicator == "total")

  output <- bind_rows(output_counts, output_comp, output_ratio, output_cbr, fertility_rates)

  return(handle_table_output(output, output_path, tablename))
}
