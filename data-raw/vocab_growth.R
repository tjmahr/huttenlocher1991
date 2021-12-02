## code to prepare `vocab_growth` dataset goes here

# we gleam the column names by looking at this file
readLines("data-raw/VOCAB.MDMT")

library(tidyverse)
ls <- readLines("data-raw/VOCAB1.DAT") %>%
  stringr::str_replace_all("\"", "")
ls_evens <- ls[seq_along(ls) %% 2 == 1]
ls_odds <- ls[seq_along(ls) %% 2 == 0]

d1 <- readr::read_table(
  paste0(ls_evens, ls_odds),
  col_names =  c("data_id", "age", "vocab", "age_12", "age_12_sq", "id")
)

# so if dataid is family and id is child, then one child per family.
d1 %>%
  distinct(data_id, id) %>%
  print(n = Inf)

d2 <- "data-raw/VOCAB2.DAT" %>%
  readLines() %>%
  stringr::str_replace_all("\"", "") %>%
  readr::read_table(
    col_names = c("data_id", "mom_speak", "sex", "group", "log_mom")
  )

vocab_growth <- dplyr::inner_join(d1, d2) %>%
  select(id, mom_speak:log_mom, age:age_12_sq) %>%
  write_csv("data-raw/vocab-growth.csv")

usethis::use_data(vocab_growth, overwrite = TRUE)
