Project (ongoing) done as a Research Assistant at ETH

# phenotyping_IF_images
Image of the colorectal cancer core from TMA [from](https://lunaphore.com/40-plex-tma-minerva-story/#s=0#w=0#g=0#m=-1#a=-100_-100#v=0.7676_0.499_0.5#o=-100_-100_1_1#p=Q)

[Download from](https://lunaphore.wetransfer.com/downloads/2fc24134cd869f853de894d518aa496f20221103131530/609fb4)

<image src='https://github.com/Elena983/phenotyping_IF_images/assets/68946912/0d56a392-8023-42f9-9fe5-8a5e597ba426' width='550' alt='CRC'/>

Pipeline to receive the countmatrix performed by MCMICRO pipeline

<image src='https://github.com/Elena983/phenotyping_IF_images/assets/68946912/c8ca632a-9166-40ef-b789-a1641ebd1d9d' width='550' alt='MESMER whole-cell segmentation algorithm'/>

Backgroung correction was done by Lunaphore Viewer
Image files from COMET are already stitched and alighned

https://github.com/Elena983/phenotyping_IF_images/assets/68946912/ca15550e-59fe-41db-b4cc-7eee3216bacd

On the video you may see cells with nuclei and membrane as well as the cells are with only a membrane without nuclei (no DAPI).

Markers

![Markers](https://github.com/Elena983/phenotyping_IF_images/assets/68946912/ba034a4e-df9a-4476-bbfa-45ea174784a6)

With only DAPI we don't see some important cancer areas
<image src='https://github.com/Elena983/phenotyping_IF_images/assets/68946912/e4e21a2b-f68a-4171-8c95-e0897fc9af9a' width='750' alt='areas without DAPI'/>

Analysis usind SciMap and ScanPy (Python)
Countmartix is 20 000 cells

<image src='https://github.com/Elena983/phenotyping_IF_images/assets/68946912/3730ed36-8edc-41cc-af70-ec92442f30bd' width='750' alt='leiden vs real'/>

Leiden clusters are the math clusters when real clusters from phenotyping are cell-type depended.
On heatmap we can clearly see that the most important indicator is good segmentation (never overlapping the cells with marker genes, CD3 (T) and CD20(B), for example)
On leiden clusters overlaying occurs almost always

<image src='https://github.com/Elena983/phenotyping_IF_images/assets/68946912/6095c931-10c4-4f8c-b57e-94a3c88556e8' width='750' alt='subclusters on UMAP'/>







