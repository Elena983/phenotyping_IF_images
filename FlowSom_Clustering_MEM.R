# Data Analysis Workflow Example on Your Data (UMAP, FlowSOM, MEM)

library(FlowSOM)
library(flowCore)
library(Biobase)
library(ggplot2)
library(MEM)
library(tidyverse)
library(Rtsne)
library(uwot)
library(RColorBrewer)

choose.markers <- function(exp_data) {
  print("Numbered column names, in order they appear in file: ")
  print(paste(c(1:(ncol(exp_data))), ": ", 
              colnames(exp_data[, c(1:(ncol(exp_data)))]), sep = ""))
  markers = readline("Enter column numbers to include (e.g. 1:5,6,8:10).\n")
  sep_vals = unlist(strsplit(markers, ","))
  list_vals = vector()
  for (i in 1:length(sep_vals)) {
    val = sep_vals[i]
    if (length(unlist(strsplit(val, ":"))) > 1) {
      new_val = as.numeric(unlist(strsplit(val, ":"))[1]):
        as.numeric(unlist(strsplit(val, ":"))[2])
    } else{
      new_val = as.numeric(sep_vals[i])
    }
    list_vals = c(list_vals, new_val)
  }
  markerList = c(list_vals)
  return(markerList)
}

setwd("~/Desktop/my_data_files")

my.files <-  dir(pattern = "*.fcs")

data.lists <- lapply(lapply(my.files, read.FCS), exprs)

# variable my.data in environment should contain a concatenation of all cells
# and all measure features 
my.data = as.data.frame(do.call(rbind, mapply(cbind, data.lists, "File ID" = c(1:length(data.lists)), 
                                              SIMPLIFY = F)))
colnames(my.data)[1:length(my.data) - 1] <- as.character(read.FCS
                                                         (my.files[[1]])@parameters@data[["desc"]])

# select all channels with markers (that you want to apply scales to) by opening!!!!
# console below
#STOP here
my.marker.data = as.data.frame(as.data.frame(my.data)[,c(choose.markers(my.data))]) # 3:22

# set the cofactor for all features
cofactor = 5

# if all of your channels have the same cofactor, this will apply an arcsih
# transformation to the previously selected markers
my.markers.transformed <- my.marker.data %>%
  mutate_all(function(x)
    asinh(x / cofactor))

# Run UMAP on chosen markers

# select all channels to use in UMAP by opening console below similar to
# what you did previously
#STOP here, the new values
umap.markers = as.data.frame(as.data.frame(my.markers.transformed)[,c(choose.markers(my.markers.transformed))])# 1:20

myumap <- umap(umap.markers, 
               ret_model = TRUE, 
               verbose = TRUE)
umap.data = as.data.frame(myumap$embedding)
colnames(umap.data) <- c("UMAP1", "UMAP2")

range <- apply(apply(umap.data, 2, range), 2, diff)
graphical.ratio <- (range[1]/range[2])

# UMAP flat dot plot and density dot plot (1 dot = 1 cell)
UMAP.plot <- data.frame(x = umap.data[,1], y = umap.data[,2])

ggplot(UMAP.plot) + coord_fixed(ratio=graphical.ratio) + geom_point(aes(x=x, y=y), cex = 1) + labs( x = "UMAP 1", y = "UMAP 2") + theme_bw()

ggplot(UMAP.plot, aes(x=x, y=y)) + coord_fixed(ratio = graphical.ratio)  + geom_bin2d(bins = 128) + 
  scale_fill_viridis_c(option = "A", trans = "sqrt") + scale_x_continuous(expand = c(0.1,0)) + 
  scale_y_continuous(expand = c(0.1,0)) + labs(x = "UMAP 1", y = "UMAP 2") + theme_bw()

# enter target number of clusters
target.clusters = 20

# Run FlowSOM on your selected variable
flowsom.input = umap.data
mat <- as.matrix(flowsom.input)

# create flowFrame for FlowSOM input
metadata <-
  data.frame(name = dimnames(mat)[[2]],
             desc = dimnames(mat)[[2]])
metadata$range <- apply(apply(mat, 2, range), 2, diff)
metadata$minRange <- apply(mat, 2, min)
metadata$maxRange <- apply(mat, 2, max)
input.flowframe <- new("flowFrame",
                       exprs = mat,
                       parameters = AnnotatedDataFrame(metadata))

# implement the FlowSOM on the data
fsom <-
  FlowSOM(
    input.flowframe,
    colsToUse = c(1:2),
    nClus = target.clusters,
    seed = 1
  )
FlowSOM.clusters <-
  GetMetaclusters(fsom)

qual_col_pals = brewer.pal.info[brewer.pal.info$category == 'qual',]
col_vector = unlist(mapply(brewer.pal, qual_col_pals$maxcolors, 
                           rownames(qual_col_pals)))
col_vector = col_vector[-c(4,17,19,27,29:45)]
values = sample(col_vector)

# plot FlowSOM clusters on UMAP axes
ggplot(UMAP.plot) + coord_fixed(ratio=graphical.ratio) + 
  geom_point(aes(x=x, y=y, color=FlowSOM.clusters),cex = 1.5) + 
  guides(colour = guide_legend(override.aes = list(size=5), nrow = 13)) +
  labs(x = "UMAP 1", y = "UMAP 2",title = "FlowSOM Clustering on UMAP Axes", 
       color = "FlowSOM Cluster") + theme_bw() + 
  scale_color_manual(values = values)  

cluster = as.numeric(as.vector((FlowSOM.clusters)))

# Run MEM on the FlowSOM clusters found by using UMAP axes
cluster = as.numeric(as.vector((FlowSOM.clusters)))

# Run MEM on the FlowSOM clusters from UMAP
MEM.data = cbind(my.markers.transformed, cluster)

MEM.values.uf = MEM(
  MEM.data,
  transform = FALSE,
  cofactor = 0,
  choose.markers = FALSE,
  markers = "all",
  choose.ref = FALSE,
  zero.ref = FALSE,
  rename.markers = FALSE,
  new.marker.names = "none",
  file.is.clust = FALSE,
  add.fileID = FALSE,
  IQR.thresh = NULL
)

# build MEM heatmap and output enrichment scores
build.heatmaps(
  MEM.values.uf,
  cluster.MEM = "both",
  cluster.medians = "none",
  display.thresh = 2,
  newWindow.heatmaps = TRUE,
  output.files = TRUE,
  labels = FALSE,
  only.MEMheatmap = TRUE
)


setwd("~/Desktop/my_data_files/output files")

data.to.export = cbind(my.data,umap.data,cluster)
separate.files = split(data.to.export,data.to.export$`File ID`)
for (i in 1:length(separate.files)){
  single.file = separate.files[[i]]
  remove.ID  = single.file[-c(ncol(my.data))]
  mat <- as.matrix(single.file)}
  # create flowFrame
  metadata <-
    data.frame(name = dimnames(mat)[[2]],
               desc = dimnames(mat)[[2]])
  metadata$range <- apply(apply(mat, 2, range), 2, diff)
  metadata$minRange <- apply(mat, 2, min)
  metadata$maxRange <- apply(mat, 2, max)
  export.flowframe <- new("flowFrame",
                          exprs = mat,
                          parameters = AnnotatedDataFrame(metadata))
  newname  = str_remove(my.files[i], ".fcs")
  filename = paste0(newname,"_UMAP_FlowSOM.fcs")
  write.FCS(export.flowframe,filename = filename)
  print(i)

  data.to.export = cbind(my.data,umap.data,cluster)
  separate.files = split(data.to.export,data.to.export$`File ID`)
  for (i in 1:length(separate.files)){
    single.file = separate.files[[i]]
    remove.ID  = single.file[-c(ncol(my.data))]
    newname  = str_remove(my.files[i], ".csv")
    filename = paste0(newname,"_UMAP_FlowSOM.csv")
    write.csv(single.file,file = filename)
    print(i)}
  
  library(dplyr)
  
  setwd("~/Desktop/my_data_files") 
  
  df <- read.csv2('CRC--mesmer_cell.fcs_UMAP_FlowSOM.csv', head = TRUE, sep=",")
  
 df <- df %>%
   mutate(cluster_name = case_when(
     cluster == 1 ~ 'Endothelial', #CD31+
     cluster == 2 ~ 'MPs', #CD38+CD45+CD68+
     cluster == 3 ~ 'Proliferative MPs', #CD38+CD45+CD68+Ki-67+
     cluster == 4 ~ 'B cells',
     cluster == 5 ~ 'Treg',
     cluster == 6 ~ 'None Artefacts',
     cluster == 7 ~ 'CAFs', #aSMA+
     cluster == 8 ~ 'T help', #CD3+CD4+
     cluster == 9 ~ 'B cells', 
     cluster == 10 ~ 'Tcyt', #CD3+CD8+PD-1+
     cluster == 11 ~ 'APC T help', #CD3+CD4+PD-1+
     cluster == 13 ~ 'Tumor',
     cluster == 15 ~ 'Tumor APCs', #CK+IDO-1+
     cluster == 14 ~ 'Inflammatory Monocytes', #CD68+CD11c+CD16+ 
     cluster == 16 ~ 'TAM', #CK+CD68+CD31+
     cluster == 17 ~ 'None2 Immune/cancer Artefacts', #CD3+CK+
     cluster == 18 ~ 'CD31+TAM', #CK+CD68+CD31+HLA-DR+
     cluster == 19 ~ 'IDO-1+ Tumor APCs', #CK+IDO-1+HLA-DR+
     cluster == 20 ~ 'Proliferating Tumor APCs' #CK+Ki-67+HLA-DR+
   ))
 
str(df)

# Use write.csv to save the dataframe to a CSV file
write.csv(df, 
          'cells_with_cluster_names.csv', 
          row.names = FALSE)

df$cluster_name
