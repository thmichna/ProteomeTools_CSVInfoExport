library(tidyverse)
library(plyr)

myfiles = list.files(pattern="proteins.csv", 
                     full.names=TRUE, 
                     recursive = TRUE)

dat_csv = ldply(myfiles, 
                read_csv)

ProteinsOnly = dat_csv %>% 
  filter(str_detect(Accession, "Packet") ) %>% 
  select(Accession,`Coverage (%)`)%>% 
  as.tibble() %>%
  mutate(Number = as.numeric(str_sub(Accession, 
                                     start =24, 
                                     end=25 ) ) ) %>%
  arrange(Number)


ggplot(ProteinsOnly) +
  geom_bar( aes(x = reorder(Accession, Number), 
                y = `Coverage (%)`, 
                fill =`Coverage (%)` ), 
            stat="identity") +
  scale_fill_gradient(low = "red", 
                      high = "green", 
                      limits = c(0,100) ) +
  labs(title="Coverage of each peptide composition in Pool1",
        x ="Peptide Composition #", 
        y = "Coverage [%]")+
  theme(axis.text.x = element_text(angle = 60, hjust = 1))

