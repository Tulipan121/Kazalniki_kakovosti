setwd("D:/R/GitHub/Kazalniki_kakovosti")

library("stringr")
library("googlesheets")
library("dplyr")

preberi_tabelo <- gs_url("https://docs.google.com/spreadsheets/d/1f7wn_vTYlDa2ZMAu8WEObO6BGInJQocg-dhMeVSmKrw/edit#gid=1087390009")

data_1 <- gs_read(gs_title("Kazalniki kakovosti rodov Zveze tabornikov Slovenije (Responses)"), 1)

data <- t(data_1[, str_detect(names(data_1), "Komentarji*")])

data <- str_replace_all(data, "Komentar", paste("Komentar", row(data)))

data <- paste(data, collapse = "")

data <- str_replace_all(data, '"', "'")

data <- strsplit(data, '[^^]\\{')

data <- unlist(data)


data <- str_replace(data, "^", "\\{")
data <- str_replace(data, "  ", " ")
str_replace_all(data, "\\\\n", " ")

data <- unlist(str_split(data, "\\}"))

a <- data.frame(t(matrix(data, nrow = 2, ncol = length(data)/2)), stringsAsFactors = FALSE)

colnames(a) <- c("kazalnik", "komentar")

a$kazalnik <- str_remove_all(a$kazalnik, "[[:punct:]]")

komentar <- str_which(a$kazalnik, "[K|k]omentar*")
ni_komentar <- setdiff(c(1:nrow(a)), komentar)

a$kazalnik[ni_komentar] <- str_pad(a$kazalnik[ni_komentar], 4, side = "right", pad = "0")

a$podrocje <- c(rep(NA, nrow(a)))
a$podrocje[komentar] <- a$kazalnik[komentar]
a$podrocje[ni_komentar] <- str_sub(a$kazalnik[ni_komentar], 1, 2)
a$kazalnik[komentar] <- ""
a$kazalnik[ni_komentar] <- str_sub(a$kazalnik[ni_komentar], 3, 4)

a <- a[, c(3,1,2)]

a$komentar <- str_remove_all(a$komentar, "^:|^:[[:blank:]]|^[[:blank:]]")

write.csv2(a, "komentarji.csv")
