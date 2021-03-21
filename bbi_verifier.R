## ----setup, include=FALSE------------------------
knitr::opts_chunk$set(echo = TRUE)


## ------------------------------------------------
if(!require(pacman)){install.packages("pacman")}
pacman::p_load(DT,data.table,dtplyr,tidyverse, tidystringdist)


## ------------------------------------------------
load("./shiny_app/bbi_verifier/iebc_data_fin.RData")


## ------------------------------------------------
iebc_data_1 <- read_csv("./Pages-from-Building_Bridges_Initiative_File_1-2.csv") %>%
  setNames("data")

iebc_data_2 <- read_csv("./Pages-from-Building_Bridges_Initiative_File_1-3.csv") %>%
  setNames("data")

iebc_data_3 <- read_csv("./Building_Bridges_Initiative_File_2.csv") %>%
  setNames("data")


## ------------------------------------------------
iebc_data_raw <- bind_rows(iebc_data_1,iebc_data_2,iebc_data_3) %>%
  mutate(data = str_trim(data))

dim(iebc_data_raw)
head(iebc_data_raw)

gc()


## ------------------------------------------------
iebc_data_raw <- iebc_data_raw %>%
  extract(col = data, 
          into = "ID_PP_NUMBER", 
          regex = "(^\\d\\*+\\d{3})",
          remove = FALSE) %>%
  extract(col = data, 
          into = "BBI_SUPPORTERNAMES", 
          regex = "([[:alpha:]]+\\D+)",
          remove = FALSE)%>%
  extract(col = data, 
          into = "COUNTY_CODE", 
          regex = "[[:alpha:]]+\\D+(\\d\\d?)",
          remove = FALSE) %>%
  extract(col = data, 
          into = "COUNTY", 
          regex = "[[:alpha:]]+\\D+\\d\\d?(\\D+)",
          remove = FALSE) %>%
  extract(col = data, 
          into = "CONST_CODE", 
          regex = "[[:alpha:]]+\\D+\\d\\d?\\D+(\\d+)",
          remove = FALSE) %>%
  extract(col = data, 
          into = "CONSTITUENCY", 
          regex = "[[:alpha:]]+\\D+\\d\\d?\\D+\\d+(\\D+)",
          remove = FALSE) %>%
  extract(col = data, 
          into = "CAW_CODE", 
          regex = "[[:alpha:]]+\\D+\\d\\d?\\D+\\d+\\D+(\\d+)",
          remove = FALSE)%>%
  extract(col = data, 
          into = "remaining", 
          regex = "[[:alpha:]]+\\D+\\d\\d?\\D+\\d+\\D+\\d+(.*)",
          remove = FALSE)

dim(iebc_data_raw)
head(iebc_data_raw)

gc()


## ------------------------------------------------
pos <- str_locate(string = iebc_data_raw$remaining, 
           pattern = "[[:alpha:]]\\s")[1:nrow(iebc_data_raw)]

head(pos)


## ------------------------------------------------
iebc_data_fin <- iebc_data_raw %>%
  mutate(CAW = str_sub(string = remaining, end = pos),
         POLLING_STATION = str_sub(string = remaining, start = pos+1)) %>%
  select(-data,-remaining)

dim(iebc_data_fin)
head(iebc_data_fin)

gc()

## ------------------------------------------------
iebc_data_fin <- iebc_data_fin %>%
  select(ID_PP_NUMBER,BBI_SUPPORTERNAMES,COUNTY_CODE,COUNTY,CONST_CODE,CONSTITUENCY,CAW_CODE,CAW,POLLING_STATION)

head(iebc_data_fin)

## ------------------------------------------------
id_num1 <- "2"
id_num2 <- "815"
name1 <- "WANJIRU"
name2 <- ""

iebc_data_fin %>%
  filter(str_detect(ID_PP_NUMBER, paste0(id_num1,"\\*+",id_num2)) & 
           str_detect(BBI_SUPPORTERNAMES, name1) & 
           str_detect(BBI_SUPPORTERNAMES, name2))


## ------------------------------------------------
datatable(iebc_data_fin %>% head(50), 
          filter = "top", 
          options = list(dom = "ltipr"), 
          rownames = FALSE)


## ------------------------------------------------
iebc_data_fin_dt <- lazy_dt(iebc_data_fin[1:100,])

iebc_data_fin_dt <- data.table(iebc_data_fin)


## ------------------------------------------------
mtcars2 <- lazy_dt(mtcars)

mtcars2 %>% 
  filter(wt < 5) %>% 
  mutate(l100k = 235.21 / mpg) %>% # liters / 100 km
  group_by(cyl) %>% 
  summarise(l100k = mean(l100k)) %>% 
  as_tibble()

