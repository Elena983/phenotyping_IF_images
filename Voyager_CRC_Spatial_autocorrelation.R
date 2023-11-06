library(Voyager)
library(SingleCellExperiment)
library(SpatialExperiment)
library(SpatialFeatureExperiment)
library(batchelor)
library(scater)
library(scran)
library(bluster)
library(glue)
library(purrr)
library(tidyr)
library(dplyr)
library(ggplot2)
library(gghighlight)
library(patchwork)
library(spdep)
library(spatialDE)
library(BiocParallel)

theme_set(theme_bw())

setwd("~/Desktop")

df1 <- read.csv2('metadata.csv', head = TRUE, sep=",")
colnames(df1)
class(df1) <- 'data.frame'

matrix1 <- as.matrix(read.csv2('gene_by_cell.csv', head = TRUE, sep = ',', dec=","))
print(matrix1)
dim(matrix1)
class(matrix1) <- "numeric"
colnames(matrix1)
row_names <- 1:18624

#TRUE
any(is.na(matrix1))

# before transposing, assign your row names to an object
rownames(matrix1) <- row_names
matrix1_rownames <- as.numeric(rownames(matrix1))

#swap colomns and rows, transpose matrix
mat1 <- t(matrix1)
class(mat1) <- "numeric"

any(is.na(mat1))
sum(is.na(mat1))

#then assign the stored row names to the new column names
colnames(mat1) <- matrix1_rownames
colnames(mat1)
rownames(mat1)

df1$X <- as.numeric(df1$X)
df1$Y <- as.numeric(df1$Y)
df1$CellID <- as.numeric(df1$CellID)

is.numeric(mat1)
str(mat1)

#create the sfe oblect
sfe1 <- SpatialFeatureExperiment(list(counts = mat1), 
                                colData = df1, 
                                spatialCoordsNames = c("X", 
                                                       "Y"))

sfe1

#Exploratory Data Analysis
celldensity <- plotCellBin2D(sfe1) + scale_y_reverse()
celldensity

spatial <- plotSpatialFeature(sfe1, features='cluster_name', 
                              colGeometryName = "centroids") +
  gghighlight(cluster_name %in% c("Endothelial", 
                                  "B cells", 
                                  'Thelp', 
                                  'Treg',
                                  'Inflammatory Monocytes')) + scale_y_reverse()
spatial

#identify the defect areas
spatial_artefacts1 <- plotSpatialFeature(sfe1, features='cluster_name', 
                                        colGeometryName = "centroids") +
gghighlight(cluster_name %in% c("None2 Immune/cancer Artefacts", "None Artefacts"),
            unhighlighted_params = list(colour = NULL, alpha = 0.3))  +
scale_y_reverse()
spatial_artefacts1

spatial_artefacts2 <- plotSpatialFeature(sfe1, features='cluster_name', 
                                        colGeometryName = "centroids") +
  gghighlight(cluster_name %in% c("None2 Immune/cancer Artefacts", "None Artefacts"),
              unhighlighted_params = list(colour = alpha("white", 0.4),
                                          label_params = list(size = 5)))  +
  scale_y_reverse()
spatial_artefacts2



rowData(sfe1)$mean <- rowMeans(assay(sfe1))
rowData(sfe1)$var <- rowVars(assay(sfe1))

#compute some gene level metrics for each of the 47 barcoded genes
#In contrast to RNA-based methods, the fields in the matrix represent intensities rather than counts.

#https://bioramble.wordpress.com/2016/01/30/why-sequencing-data-is-modeled-as-negative-binomial/
#in our case it looks like it is poison dispribution, not negative binominal

data.frame(rowData(sfe1)) |>
  ggplot(aes(mean, var)) + 
  geom_point()

#COMET data is subject to noise from several sources including segmentation artifacts, nonspecific staining, and imperfect tissue processing. 
#These are factors that can limit accurate quantification of signal intensity and impede accurate cell annotation.

#The normalized count matrix is typically stored in the logcounts slot for scRNA-seq data
#but we will instead store the normalized matrix in a slot called normalizedIntensity.

mtx <- assay(sfe1, 'counts')
assay(sfe1, 'normalizedIntensity') <- (mtx - rowMeans(mtx))/rowSds(mtx)
assays(sfe1)


#-----------
#Spatial EDA
#-----------

#the graph in space along with its corresponding colGeometry
colGraph(sfe1, "knn10") <- findSpatialNeighbors(
  sfe1, method = "knearneigh", 
  dist_type = "idw", 
  k = 10, 
  style = "W")
  
#since there are so many cells in this dataset
#plotting the neighborhood graph may not be as useful as many connections will be obscure by overlapping lines
plotColGraph(sfe1, 
             colGraphName = "knn10", 
             colGeometryName = 'centroids')

#explore univariate metrics for global spatial autocorrelation
#Since few genes are quantified in this study, we will compute the metrics for all genes

#runUnivariate() function to compute the spatial autocorrelation metrics and save the results in the SFE object
sfe1 <- runUnivariate(
  sfe1, type = "moran.mc", 
  features = rownames(sfe1),
  exprs_values = "normalizedIntensity", 
  colGraphName = "knn10", 
  nsim = 100,
  BPPARAM = MulticoreParam(2))

sfe1 <- runUnivariate(
  sfe1, 
  type = "moran.plot", 
  features = rownames(sfe1),
  exprs_values = "normalizedIntensity", 
  colGraphName = "knn10")

#The results of these computations are accessible in the rowData attribute of the SFE object
colnames(rowData(sfe1))

#plot the results of the genes with the highest Moran’s I statistic
top_moran <- data.frame(rowData(sfe1)) |>
  arrange(desc(moran.mc_statistic_sample01)) |>
  head(6) |> 
  rownames()

#Each of these plots suggests that the Moran’s I statistic is significant
moran <- plotMoranMC(sfe1, 
                     features = top_moran, 
                     facet_by = 'features')
moran

#plot the normalized intensity for these genes in space
plotSpatialFeature(
  sfe1, 
  features=top_moran, 
  colGeometryName = "centroids",
  exprs_values = "normalizedIntensity", 
  scattermore = TRUE, 
  pointsize = 1)  + scale_y_reverse()

# assess how similar observed values are to its neighbors

#When the variable is centered, the plot is divided into four quadrants defined by the horizontal line y = 0 and the vertical line x = 0. 
#Points in the upper right (or high-high) and lower left (or low-low) quadrants indicate positive spatial association, 
#and points in the lower right (or high-low) and upper left (or low-high) quadrants include observations that exhibit negative spatial association.
moranPlot(sfe1, top_moran[1])

#-----------------------
#Differential Expression
#-----------------------

# Store coordinates in a data frame object
coords <- centroids(sfe1)$geometry |>
  purrr::map_dfr(\(x) c(x = x[1], y = x[2]))


#take time to install the library spatialIDE from conda repository
#RAM-demanding better to run on server (on local machine (16 GB) more than 1 hour)
de_res <- spatialDE::run(assay(sfe1,
                               "normalizedIntensity"), 
                         coords, 
                         verbose=TRUE)

#plot the normalized expression of the top 5 genes in space.
top_genes <- de_res |>
  arrange(pval) |>
  slice_head(n=6) |>
  pull(g)

plotSpatialFeature(sfe1, top_genes, colGeometryName="centroids",
                   exprs_values = "normalizedIntensity")+ scale_y_reverse()

#the expression of the top DE genes seems to highlight the spatial distribution of known cell types in the tissue 


sessionInfo()