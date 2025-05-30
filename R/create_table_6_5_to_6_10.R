#' Creates Tables 6.5 to 6.10
#'
#' @description
#' Table 6.5 Ten leading causes of death, infants and children (0–4 years, both sexes combined)
#' @description
#' Table 6.6 Ten leading causes of death, children (5–14 years, both sexes combined)
#' @description
#' Table 6.7 Ten leading causes of death, adolescents and adults (15–69 years, males)
#' @description
#' Table 6.8 Ten leading causes of death, adolescents and adults (15–69 years, females)
#' @description
#' Table 6.9 Ten leading causes of death, older adults (70+ years, males)
#' @description
#' Table 6.10 Ten leading causes of death, older adults (70+ years, females),
#'
#' @param data data frame being used
#' @param sex_value whether male or female
#' @param age_group which age group is being used e.g. "<5"
#'
#' @return data frame with tabulated results
#' @export
#'
#' @import dplyr
#' @import tidyr
#' @import janitor
#'
#' @examples
#' t6.5 <- create_t6.5_t6.10(dth_data, sex_value = c("male","female"), age_group = "<5")
#' t6.6 <- create_t6.5_t6.10(dth_data, sex_value = c("male","female"), age_group = "5-14")
#'
create_t6.5_t6.10 <- function(data, data_year = NA, sex_value = "male", age_group = "<5"){

  # if data_year is not provided, take the latest year in the data
  if (is.na(data_year)){
    data_year = data %>% pull(!!sym(date_var)) %>% max(na.rm = TRUE)
  }

  output <- data |>
    filter(doryr == data_year & birth2a %in% sex_value & age_grp_lead == age_group) |>
    group_by(substr(death1g,1,3)) |>
    summarise(total = n()) |>
    rename(causecd = `substr(death1g, 1, 3)`)

  output <- left_join(output, cause, by = c("causecd" = "code")) |>
    group_by(group, description) |>
    summarise(total = sum(total)) |>
    arrange(desc(total))

  r99_dths <- output |>
    filter(group %in% c("R00:R99"))
  na_dths <- output |>
    filter(substr(group,1,1) %in% c( NA))

  output <- output |>
    filter(!substr(group,1,1) %in% c("R", NA))

  output2 <- output |>
    tail(nrow(output)-10)

  output2 <- rbind(output2, na_dths) |>
    mutate(group = "-",
           description = "All other causes")|>
    group_by(group, description) |>
    summarise(total = sum(total))
  rm(na_dths)

  output <- head(output, 10)

  output <- rbind(output, r99_dths, output2)
  total_deaths <- sum(output$total)
  output <- output |>
    adorn_totals("row")  |>
    mutate(proportion = construct_round_excel(total/sum(total_deaths)*100,2))
  return(output)

}


