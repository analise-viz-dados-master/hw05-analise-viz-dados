library(dplyr); library(tidyr); library(readxl); library(stringr); library(stringi)

cols <- read_excel("data/Projecoes-populacionais-municipais-2010-2040_com-pop-2019-atualizada15102019_2020.xlsx", 
                   sheet = "2020", 
                   range = "A2:BD3", 
                   col_names = FALSE)

col_names <- cols %>% 
  t() %>% 
  as_tibble() %>% 
  fill(V1) %>% 
  mutate(col_names = paste0(V2, "_", V1)) %>% 
  pull(col_names) %>% 
  stri_trans_general("latin-ascii") %>% 
  str_remove_all(" ") %>% 
  str_remove_all("^NA_") %>% 
  str_remove_all("anos")

df_raw <- read_excel("data/Projecoes-populacionais-municipais-2010-2040_com-pop-2019-atualizada15102019_2020.xlsx",
                     sheet = "2020",
                     range = "A4:BD856",
                     col_names = col_names)

df <- df_raw %>% 
  pivot_longer(c(-CodigosMunicipios, -Nomemunicipios), 
               names_to = "var",
               values_to = "pop") %>% 
  separate(var, into = c("SEXO", "FAIXA_ETARIA"), sep = "_") %>% 
  filter(SEXO != "TOTAL", FAIXA_ETARIA != "Total")
