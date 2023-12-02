# Rechunking National Water Model v3.0 retrospective simulations to more (cloud-)approachable chunks in Zarr format.
Authors: _James McCreight (NCAR), Ishita Srivastava (NCAR), Rich Signell (USGS), and Yongxin Zhang (NCAR)_


## Overview
The following table describes the simulation time period, domain and frequency of the inputs for the National Water Model (NWM) version 3.0 retrospective simulation: 

| DOMAIN      | Simulation Time Period| Data Frequency                                                                  | 
|-------------|-----------------------|---------------------------------------------------------------------------------|
| CONUS       | Feb 1979 - Feb 2023   | Inputs are hourly and outputs are provided at hourly or 3-hourly resolution     |
| Alaska      | Jan 1981 - Dec 2019   | Inputs are hourly and outputs are provided at hourly or 3-hourly resolution     |
| Hawaii      | Jan 1994 - Jan 2014   | Inputs are hourly and outputs are provided at hourly, 15-min, 45-min resolution |
| Puerto Rico | Jan 2008 - June 2023  | Inputs are hourly and outputs are provided at hourly or 3-hourly resolution     |

Additional details are provided below and in this [retrospective overview document](https://github.com/NCAR/rechunk_retro_nwm_v21/blob/main/ancillary/NWMv2.1_42YrRetrospective_OutputVarsFullPhysicsRun.pdf).

The model writes separate files at each output time. Within those individual files the data are not chunked 
in space. In the use case of opening a full timeseries at a single point or a sub-region, the user would be required to 
read in the entire data set: a very inefficient data access pattern for a very common use case. 

Enter rechunking. The goal of rechunking this model dataset is to provide chunks (data pieces partitioning the dimnensions of
of the data) that support efficient data access for most use cases. When a specific, intensive use case would benefit
from a different chunk scheme than that provided, the provided datasets can be rechunked to accomodate that pattern. 
Examples of use cases are supplied, including re-rechunking.


## Data overview
Following zarr stores have been created, corresponding closely to the model output files. The time resolution is noted for each product. 

### CONUS
| Data Type | Description                                           | Frequency | Size   |
|-----------|-------------------------------------------------------|-----------|--------|
| lakeout   | Output from the lake model                            | Hourly    | 5.0GB  |
| gwout     | Output from the groundwater model                     | Hourly    | 317GB  |
| chrtout   | Output from the streamflow model                      | Hourly    | 2.9TB  |
| precip    | Input precipitation fields from the OWP AORC forcing  | Hourly    | 1.3TB  |
| lwdown    | Input lwdown fields from the OWP AORC forcing         | Hourly    | 7.7TB  |
| psfc      | Input psfc fields from the OWP AORC forcing           | Hourly    | 8.0TB  |
| q2d       | Input q2d fields from the OWP AORC forcing            | Hourly    | 4.6TB  |
| swdown    | Input swdown fields from the OWP AORC forcing         | Hourly    | 3.9TB  |
| t2d       | Input t2d fields from the OWP AORC forcing            | Hourly    | 4.6TB  |
| u2d       | Input u2d fields from the OWP AORC forcing            | Hourly    | 4.2TB  |
| v2d       | Input v2d fields from the OWP AORC forcing            | Hourly    | 4.2TB  |
| ldasout   | Output from the NoahMP land surface model             | 3-hourly  | 14TB   |
| rtout     | Output from the overland and subsurface terrain       | 3-hourly  | 3.5TB  |

### Alaska
| Data Type | Description                                          | Frequency | Size   |
|-----------|------------------------------------------------------|-----------|--------|
| lakeout   | Output from the lake model                            | Hourly    | 5.5GB  |
| gwout     | Output from the groundwater model                     | Hourly    | 1.7TB  |
| chrtout   | Output from the streamflow model                      | Hourly    | 346GB  |
| forcing   | Input fields from the OWP AORC forcing                | Hourly    | 2.4TB  |
| ldasout   | Output from the NoahMP land surface model             | 3-hourly  | 548GB  |
| rtout     | Output from the overland and subsurface terrain       | 3-hourly  | 46GB   |

### Hawaii

| Data Type | Description                                          | Frequency | Size   |
|-----------|------------------------------------------------------|-----------|--------|
| lakeout   | Output from the lake model                            | Hourly    | 31MB  |
| gwout     | Output from the groundwater model                     | Hourly    | 15GB  |
| chrtout   | Output from the streamflow model                      | Hourly    | 36GB  |
| forcing   | Input fields from the OWP AORC forcing                | Hourly    | 444GB |
| ldasout   | Output from the NoahMP land surface model             | 3-hourly  | 132GB |
| rtout     | Output from the overland and subsurface terrain       | 3-hourly  | 64GB  |

### Puerto  Rico

| Data Type | Description                                          | Frequency  | Size  |
|-----------|------------------------------------------------------|------------|-------|
| lakeout   | Output from the lake model                            | Hourly    | 26MB  |
| gwout     | Output from the groundwater model                     | Hourly    | 4.3GB |
| chrtout   | Output from the streamflow model                      | Hourly    | 9.6GB |
| forcing   | Input fields from the OWP AORC forcing                | Hourly    | 37GB  |
| ldasout   | Output from the NoahMP land surface model             | 3-hourly  | 28GB  |
| rtout     | Output from the overland and subsurface terrain       | 3-hourly  | 25GB  |



Additonal detail on these stores (variables contained and space-time information) is provided in the data description section 
below and via accompanying notebooks.


## Data Description

Data as accessed by `xarray.open_zarr` can be found in the accompanying notebook
[(html)](https://nbviewer.org/github/NCAR/rechunk\_retro_nwm\_v21/blob/main/notebooks/data\_description.ipynb) 
[(jupyter\_notebook)](https://github.com/NCAR/rechunk_retro_nwm_v21/blob/main/notebooks/data_description.ipynb). This includes
metadata, chunking schemes, and data types for all variables and coordinates. 

Further details in this accompanying notebook 
[(html)](https://nbviewer.org/github/NCAR/rechunk_retro_nwm_v21/blob/main/notebooks/data_description_detail.ipynb) 
[(jupyter notebook)](https://github.com/NCAR/rechunk_retro_nwm_v21/blob/main/notebooks/data_description_detail.ipynb)
including the xarray dataset reports and also xarray and Zarr details for each variable showing storage data types, levels of 
compression and other information. Note that the difference in the data types between xarray and zarr result from the use of scale\_factor 
and add\_offset metadata in the underlying Zarr data set which xarray uses to recover floating point variables from the stored 
integers. 


## Use Cases

* Example of retrieving and plotting a single timeserires from the chrtout store
[(html)](https://nbviewer.org/github/NCAR/rechunk_retro_nwm_v21/blob/main/notebooks/usage_example_streamflow_timeseries.ipynb) 
[(jupyter notebook)](https://github.com/NCAR/rechunk_retro_nwm_v21/blob/main/notebooks/usage_example_streamflow_timeseries.ipynb)

* Example of subsetting and rechunking the store to optimize data access pattern: selecting only streamflow gages from chrtout
[(html)](https://nbviewer.org/github/NCAR/rechunk_retro_nwm_v21/blob/main/notebooks/usage_example_rerechunk_chrtout.ipynb) 
[(jupyter notebook)](https://github.com/NCAR/rechunk_retro_nwm_v21/blob/main/notebooks/usage_example_rerechunk_chrtout.ipynb)


## Code overview
An overview of the code used can be found in [README_code.md](README_code.md).
