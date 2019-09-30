library(dplyr)
library(stringr)


setwd("D:/R/GitHub/Kazalniki_kakovosti")
data <- readLines("Vprasanja_v_csv.csv")


podrocja <- data[str_which(data, "^\\{[[:digit:]]{2}\\}")]
kazalnik <- data[str_which(data, "^\\{[[:digit:]]{2}-[[:digit:]]{2}\\}")]
izbire <- data[str_which(data, "^\\[")]

tabela_izbir <- matrix(nrow = length(kazalnik), ncol = 5)
tabela_izbir <- data.frame(tabela_izbir)
colnames(tabela_izbir) <- c("0 - Nezadostno", "1 - Pomanjkljivo", "2 - Delno", "3 - Zadovoljivo", "4 - Vzorno")



vrstica <- 1

for(i in c(1:length(izbire))) {
      if(i == 1) {
            tabela_izbir[vrstica, as.numeric(str_sub(izbire[i], 3,3)) + 1] <- izbire[i]
      }
      else if(as.numeric(str_sub(izbire[i], 3, 3)) < as.numeric(str_sub(izbire[i-1], 3, 3))) {
            vrstica <- vrstica + 1
            tabela_izbir[vrstica, as.numeric(str_sub(izbire[i], 3,3)) + 1] <- izbire[i]
      }
      else {
            tabela_izbir[vrstica, as.numeric(str_sub(izbire[i], 3,3)) + 1] <- izbire[i]
      }
}


tabela_izbir$kazalnik <- kazalnik

write.csv(tabela_izbir, "koncna_tabela.csv", na = "", row.names = FALSE)
