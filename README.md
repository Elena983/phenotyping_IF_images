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

<image src='https://github.com/Elena983/phenotyping_IF_images/assets/68946912/0a1c12ad-816d-4c24-9030-2fc105850a54' width='650' alt='pipeline'/>


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

### Quality assessment

CSV is written out as FCS files (R script)
FCS files are then uploaded onto CellEngine (Primity Bio) to assess data quality visually

<image src='https://github.com/Elena983/phenotyping_IF_images/assets/68946912/9abfb4f7-49d8-4beb-9522-6ce60164aef6' width='650' alt='Quality assessment'/>

![Screenshot_37](https://github.com/Elena983/phenotyping_IF_images/assets/68946912/d6676faa-d4a6-42c4-8eab-01d4ec7a767b)

### Working with data


### Plan to do Ongoing

FlowJo

Unsupervised classification of cell types on this scaled data with FlowSOM 

Cell types identifying from each cluster with marker enrichment modeling (MEM)

Cell classification (deep-learning algorithm)

Cellular neighborhood analysis (https://github.com/nolanlab/NeighborhoodCoordination)

Marker correlation analysis (rcorr function of the Hmisc R package)

Cell interaction analysis 

Spatial autocorrelation and Local Moran's I (Voyager R package)





