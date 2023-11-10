Project (ongoing) done as a Research Assistant at ETH

# phenotyping_IF_images
Image of the colorectal cancer core from TMA [from](https://lunaphore.com/40-plex-tma-minerva-story/#s=0#w=0#g=0#m=-1#a=-100_-100#v=0.7676_0.499_0.5#o=-100_-100_1_1#p=Q)

[Download from](https://lunaphore.wetransfer.com/downloads/2fc24134cd869f853de894d518aa496f20221103131530/609fb4)

<image src='https://github.com/Elena983/phenotyping_IF_images/assets/68946912/0d56a392-8023-42f9-9fe5-8a5e597ba426' width='550' alt='CRC'/>

Pipeline to receive the countmatrix performed by MCMICRO pipeline

<image src='https://github.com/Elena983/phenotyping_IF_images/assets/68946912/c8ca632a-9166-40ef-b789-a1641ebd1d9d' width='550' alt='MESMER whole-cell segmentation algorithm'/>

Lunaphore Viewer performed background correction.
Image files from COMET are already stitched and aligned.

https://github.com/Elena983/phenotyping_IF_images/assets/68946912/ca15550e-59fe-41db-b4cc-7eee3216bacd

In the video, you may see cells with nuclei and membrane and those with only a membrane without nuclei (no DAPI).

Markers

![Markers](https://github.com/Elena983/phenotyping_IF_images/assets/68946912/ba034a4e-df9a-4476-bbfa-45ea174784a6)

With only DAPI, we don't see some critical cancer areas.

![markers without visible nuclei](https://github.com/Elena983/phenotyping_IF_images/assets/68946912/5ab5274a-8086-4427-b2c4-b1629d394add)

<image src='https://github.com/Elena983/phenotyping_IF_images/assets/68946912/23311ab0-659d-4d13-b80a-e0c179d7d8c6' width='550' alt='cells'/>

So, to capture these cells, we did the whole-cell segmentation MESMER.

Run pipeline on Linux via NextFlow

<image src='https://github.com/Elena983/phenotyping_IF_images/assets/68946912/0a1c12ad-816d-4c24-9030-2fc105850a54' width='350' alt='pipeline'/>


Analysis using SciMap and ScanPy (Python)
Countmartix is 20,000 cells

<image src='https://github.com/Elena983/phenotyping_IF_images/assets/68946912/3730ed36-8edc-41cc-af70-ec92442f30bd' width='650' alt='leiden vs real'/>

Leiden clusters are the math clusters when real clusters from phenotyping are cell-type dependent.
On the heatmap, we can clearly see that the most critical indicator is good segmentation (never overlapping the cells with marker genes, CD3 (T) and CD20(B), for example)
On Leiden clusters, overlaying occurs almost always.

<image src='https://github.com/Elena983/phenotyping_IF_images/assets/68946912/6095c931-10c4-4f8c-b57e-94a3c88556e8' width='650' alt='subclusters on UMAP'/>

Marker-based cell annotation with [CELESTA](https://github.com/plevritis-lab/CELESTA)

<image src='https://github.com/Elena983/phenotyping_IF_images/assets/68946912/3eede541-f3a1-4afa-9798-bd3589f30e3a' width='650' alt='classification'/>

<image src='https://github.com/Elena983/phenotyping_IF_images/assets/68946912/fd3ae64b-b00e-47ca-8ed5-3bd362449dab' width='650' alt='classification'/>

### Working with data

Checking the background value
It is still not 0

<image src='https://github.com/Elena983/phenotyping_IF_images/assets/68946912/6edc3924-1bac-4257-b209-8899929acd6f' width='650' alt='background'/>

# in processing 
So I will implement the BaSiC module on ImageJ (deploying during the COMET run as later they will be deleted by software)
To do this, I need to receive tiles. 
Then, apply the ashlar module for stitching and aligning.

After doing this, one starts the MCMICRO pipeline from the segmentation algorithm.

<image src='https://github.com/Elena983/phenotyping_IF_images/assets/68946912/795ff337-69d7-4977-b4e4-097a137810b2' width='650' alt='output'/>

Obtaining the countmatrix.csv

### Quality assessment

Transfer it to FlowJo to convert CSV to FCS (Drag and Drop) to assess data quality visually.

<image src='https://github.com/Elena983/phenotyping_IF_images/assets/68946912/9abfb4f7-49d8-4beb-9522-6ce60164aef6' width='650' alt='Quality assessment'/>

![Screenshot_37](https://github.com/Elena983/phenotyping_IF_images/assets/68946912/d6676faa-d4a6-42c4-8eab-01d4ec7a767b)

## FlowSom Clustering and MEM 

FlowSom Algorithm assigns a cluster number for each cell, as MEM calls it by the most and least expressed genes in it.

<image src='https://github.com/Elena983/phenotyping_IF_images/assets/68946912/59168a63-1ae0-48f7-9d7f-2a34dfbc38d0' width='750' alt='FlowSom'/>

It may be applied via the FlowJo plugin or in R.
In FlowJo, we may see the spatial distribution of each cluster.

# Cell localization by cluster on FlowSom (images need to be rotated 180) in space

<image src='https://github.com/Elena983/phenotyping_IF_images/assets/68946912/698e0f7c-4325-4341-af05-5b5f760d1a19' width='650' alt='space'/>

# FlowSom clusters look great on UMAP axes

<image src='https://github.com/Elena983/phenotyping_IF_images/assets/68946912/96d3b510-c90f-4093-abf8-0b1630dd4f14' width='650' alt='UMAP'/>

# Cell types identified from each cluster with marker enrichment modeling (MEM)

<image src='https://github.com/Elena983/phenotyping_IF_images/assets/68946912/4e09468b-e835-49a0-8e6a-12a6113be53e' width='650' alt='heatmap MEM'/>

## Tool for imaging clusters in space

Input for Voyager tool to create SFE object
Create 2 files from the clustering output

<image src='https://github.com/Elena983/phenotyping_IF_images/assets/68946912/7f3d5cfe-e6d3-4b1f-99ab-678253b71c9f' width='850' alt='SFE'/>

I found 2 clusters that should be excluded.

Immune/Cancer cells CD3+CK+, cluster where immune and cancer genes are highly expressed
Unstained cells - no markers

<image src='https://github.com/Elena983/phenotyping_IF_images/assets/68946912/f3c955e5-9899-492d-a9ea-99d467f99f3a' width='850' alt='excluded clasters'/>

# Excluded clusters among all cells (highlight the clusters of interest)

COMET data is subject to noise from several sources, including segmentation artifacts, nonspecific staining, and imperfect tissue processing. 
These factors can limit the accurate quantification of signal intensity and impede accurate cell annotation.

<image src='https://github.com/Elena983/phenotyping_IF_images/assets/68946912/5f6f732a-b4ca-47de-b298-f04c6daa94c8' width='850' alt='all clasters'/>

# Cell density

![density](https://github.com/Elena983/phenotyping_IF_images/assets/68946912/daa5e2d1-4438-43e5-8561-8de070c24627)

# Compute var/mean gene-level metrics, Poisson distribution. 

Compute some gene-level metrics for each of the 20 genes
In contrast to RNA-based methods, 
the fields in the matrix represent intensities rather than counts

<image src='https://github.com/Elena983/phenotyping_IF_images/assets/68946912/8b5ad3b5-c943-4401-a70a-4b89cac5fa4d' width='450' alt='poisson'/>

## Genes with the highest Moran’s I statistic,  presence, and strength of spatial autocorrelation. 

# Plot the normalized intensity for these genes in space.

The vertical line in each plot represents the observed Moran’s I while the density represents the Moran’s I statistic for each of the random permutations of the data.

If the vertical line representing the observed Moran's I fall within the bulk of the density distribution, it suggests that the spatial autocorrelation in the data is not significantly different from what would be expected by random chance. 

In other words, the data has no strong spatial clustering or dispersion evidence.
On the other hand, if the vertical line falls in the tails (extremes) of the density distribution, it suggests that the observed Moran's I is significantly different from random chance. 

This indicates the presence of spatial autocorrelation. 
The direction of the deviation (left or right tail) can provide information about the nature of spatial autocorrelation (positive or negative spatial autocorrelation).

Each of these plots suggests that the Moran’s I statistic is significant.

![moran](https://github.com/Elena983/phenotyping_IF_images/assets/68946912/63a2d2a2-2bf3-4d62-b8ba-ccd0e892aca5)

# Assess how similar observed values are to their neighbors.

When the variable is centered, the plot is divided into 4 quadrants defined by the horizontal line y = 0 and the vertical line x = 0. 

Points in the upper right (or high-high) and lower left (or low-low) quadrants indicate positive spatial association, and points in the lower right (or high-low) and upper left (or low-high) quadrants include observations that exhibit negative spatial association.

<image src='https://github.com/Elena983/phenotyping_IF_images/assets/68946912/31894256-4221-4c76-aff8-4222c66886aa' width='450' alt='4'/>

# DEGs

Normalized expression of the top 5 genes in space (computing needs RAM resources)

![degs](https://github.com/Elena983/phenotyping_IF_images/assets/68946912/760e07fb-3c29-4d8c-93b0-4ed0490670db)

### Plan to do Ongoing

Cell classification (deep-learning algorithm STELLAR)

Cellular neighborhood analysis (https://github.com/nolanlab/NeighborhoodCoordination)

Marker correlation analysis (rcorr function of the Hmisc R package)

Cell interaction analysis





