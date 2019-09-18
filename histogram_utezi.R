setwd("D:/R/GitHub/Kazalniki_kakovosti")

library(stringr)
library(googlesheets)
library(dplyr)
library(ggplot2)

preberi_tabelo <- gs_url("https://docs.google.com/spreadsheets/d/1f7wn_vTYlDa2ZMAu8WEObO6BGInJQocg-dhMeVSmKrw/edit#gid=1087390009")

data_1 <- gs_read(gs_title("Kazalniki kakovosti rodov Zveze tabornikov Slovenije (Responses)"), 1)

data <- names(data_1)
data <- str_extract(data, "\\[[[:digit:]]\\]")
data <- str_extract(data, "[[:digit:]]")
data <- as.numeric(data[!is.na(data)])

a <- qplot(as.factor(data)) + stat_count(aes(y = ..count.., label = ..count..), 
                                  geom = "text", color = "white", size = 10,
                                  position = position_stack(vjust = 0.5, reverse = TRUE),)

ggsave("histogram_utezi.pdf", a, device = "pdf")
