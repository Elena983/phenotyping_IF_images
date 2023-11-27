#delete artifact clusters colomns

library(ggplot2)
library(dplyr)

setwd("~/Desktop")

df <- read.csv2('cells_with_cluster_names1.csv', head = TRUE, sep=",")
df$cluster_name

df <- df %>%
  mutate(ClusterName = case_when(
    cluster_name == 'Endothelial' ~ 'Endothelial', #CD31+
    cluster_name == 'MPs' ~ 'MPs', #CD38+CD45+CD68+
    cluster_name == 'Proliferative MPs' ~ 'MPs', #CD38+CD45+CD68+Ki-67+
    cluster_name == 'B cells' ~ 'B cells',
    cluster_name == 'Treg' ~ 'T help',
    cluster_name == 'None Artefacts' ~ 'None',
    cluster_name == 'CAFs' ~ 'CAFs', #aSMA+
    cluster_name == 'T help' ~ 'T help', #CD3+CD4+
    cluster_name == 'B cells' ~ 'B cells', 
    cluster_name == 'Tcyt' ~ 'T help', #CD3+CD8+PD-1+
    cluster_name == 'APC T help' ~ 'T help', #CD3+CD4+PD-1+
    cluster_name == 'Tumor' ~ 'Tumor',
    cluster_name == 'Tumor APCs' ~ 'Tumor APCs', #CK+IDO-1+
    cluster_name == 'Inflammatory Monocytes' ~ 'Monocytes', #CD68+CD11c+CD16+ 
    cluster_name == 'TAM' ~ 'TAM', #CK+CD68+CD31+
    cluster_name == 'None2 Immune/cancer Artefacts' ~ 'None', #CD3+CK+
    cluster_name == 'CD31+TAM' ~ 'TAM', #CK+CD68+CD31+HLA-DR+
    cluster_name == 'IDO-1+ Tumor APCs' ~ 'Tumor APCs', #CK+IDO-1+HLA-DR+
    cluster_name == 'Proliferating Tumor APCs' ~ 'Tumor APCs' #CK+Ki-67+HLA-DR+
  ))

str(df)

library(stringr)
#delete rows with None names
df_clean <-  na.omit(df %>% filter(ClusterName != 'None'))

str(df_clean)

df_clean$ClusterName

write.csv(df_clean, 
          'cells_with_ClusterName.csv', 
          row.names = FALSE)
