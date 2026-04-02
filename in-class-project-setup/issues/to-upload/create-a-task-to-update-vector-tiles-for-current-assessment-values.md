---
title: "Create a task to update vector tiles for current assessment values"
labels: ["Scripting","Analysis","Front-end"]
---

## Motivation

In your UI, you are going to have a map that shows a layer with the previous and/or current assessment values for all the residential properties in Philadelphia -- more than 500,000 polygons. This much data would be a challenge for a dynamic front-end for a couple of primary reasons:

1. **Download size** -- your layer is going to need a several attributes on each feature -- any data that you need to determine the color of the feature (e.g. based on the distribution of market values), as well as any data that you might want to include in a hover or popup (e.g. address, parcel number, or other characteristics driving the market value estimate). This layer is going to be over 100MB. That is _not_ something you want your users to have to download all at once.
2. **Lots of drawing** -- even if you could get the data to your users, rendering 500,000 polygons on a map at the same time is going to be a challenge for most web browsers. JavaScript mapping libraries draw each feature individually, and even though modern browsers and machines are very fast, they are not infinitely fast. Somewhere on the order of 10-50k features in memory at one time is probably the upper limit for a smooth user experience.

For web maps, the standard solution for this volume of data is to use tiles. See this [slide deck](https://docs.google.com/presentation/d/1Qvz0I6I9BQi3b2GOUZVETsvjTnSect3Sb7q_FcNljq0/edit?usp=sharing) from the JavaScript for Planners and Designers (MUSA 6110) course for an overview on map tiles.

There are several ways to create a vector tile set. For example:
- [Mapbox Tiling Service (MTS)](https://www.mapbox.com/mts) using its API (refer to the [MTS API Docs](https://docs.mapbox.com/api/maps/mapbox-tiling-service/))
- [Tippecanoe](https://github.com/felt/tippecanoe) (a project started at Mapbox, now maintained by [Felt](https://felt.com/)) using its command line interface
- `ogr2ogr` using the [GDAL Mapbox Vector Tile (MVT) driver](https://gdal.org/drivers/vector/mvt.html)

Using MTS or Tippecanoe is nice because they can generate both raster and vector tiles, but `ogr2ogr` will get the job done, and since we've already used it in this course, it is the path that I'll walk through here. If you choose to use a different tool, that is fine.

## Overview

This issue walks through creating a vector tile layer for the residential properties in Philadelphia. This can most easily be done with a [Cloud Run shell job](https://cloud.google.com/run/docs/quickstarts/jobs/build-create-shell) using `ogr2ogr`. In brief, there are three steps involved (note that these steps assume that you have already created a Cloud Function to export a geojson file of the residential properties to the `{{gcp_project}}-temp_data` bucket):

1. Download the `property_tile_info.geojson` data file from the `{{gcp_project}}-temp_data` bucket
2. Use `ogr2ogr` to convert the data into a folder of [Mapbox Vector Tile](https://github.com/mapbox/vector-tile-spec) (MVT) protobuf (.pbf) files.
3. Upload the resulting folder into a Google Cloud Storage bucket. The easiest way to do this may be to use the `gcloud` CLI.

You could instead implement these steps using all Python or Node in a Cloud Function, but it would be more trouble. More detail about the Cloud Run approach follows.

## What's Cloud Run?

Google Cloud Run allows you to specify instructions for installing your dependencies and running your program in a virtual machine on Google's infrastructure. A virtual machine into which your dependencies get pre-installed is called a "container" (or sometimes a "container image"). Cloud Run installs your dependencies according to your instructions into a container, and uses that container to run your program.

Google Cloud Functions is actually implemented on top of Google Cloud Run. In the case of Cloud Functions, Google has simply given you a choice of container building instructions ("runtimes") to choose from. For example, if you select the Python runtime and upload your code, Cloud Functions will build a container by installing everything in your requirements.txt file, and then run your `main.py` when the container starts up.

## Create a container for Cloud Run

For Cloud Run, we'll use a container definition script called a **Containerfile** (also known as a [Dockerfile](https://docs.docker.com/engine/reference/builder/#:~:text=A%20Dockerfile%20is%20a%20text,line%20to%20assemble%20an%20image.)). The following Containerfile will create a container that contains the dependencies mentioned above (GDAL for `ogr2ogr`, and the `gcloud` CLI):

```docker
# This Containerfile is a mix of two documentation sources:
# https://cloud.google.com/run/docs/quickstarts/jobs/build-create-shell#writing
# https://cloud.google.com/run/docs/tutorials/gcloud#code-container

# ----------

# Use a gcloud image based on debian:buster-slim for a lean production container.
# https://docs.docker.com/develop/develop-images/multistage-build/#use-multi-stage-builds
FROM gcr.io/google.com/cloudsdktool/cloud-sdk:slim

RUN apt-get update

# Install GDAL for ogr2ogr
RUN apt-get install -y gdal-bin

# Execute next commands in the directory /workspace
WORKDIR /workspace

# Copy over the script to the /workspace directory
COPY script.sh .

# Just in case the script doesn't have the executable bit set
RUN chmod +x ./script.sh

# Run the script when starting the container
CMD [ "./script.sh" ]
```

In the same folder as `Containerfile`, create a file named `script.sh`. When the container is built, this script file will be copied in. The script should contain the following:

```bash
#!/usr/bin/env bash
set -ex

# Download the property_tile_info.geojson file from the temp bucket.
gcloud storage cp \
  gs://{{gcp_project}}-temp_data/property_tile_info.geojson \
  ./property_tile_info.geojson

# Convert the geojson file to a vector tileset in a folder named "properties".
# The tile set will be in the range of zoom levels 12-18. See the ogr2ogr docs
# at https://gdal.org/drivers/vector/mvt.html for more information.
ogr2ogr \
  -f MVT \
  -dsco MINZOOM=12 \
  -dsco MAXZOOM=18 \
  -dsco COMPRESS=NO \
  ./properties \
  ./property_tile_info.geojson

# Upload the vector tileset to the public bucket.
gcloud storage cp \
  --recursive \
  ./properties \
  gs://{{gcp_project}}-public/tiles
```

## Deploy the Cloud Run job

In order to deploy a script to Cloud Run, use the following command:

```bash
gcloud run jobs \
  deploy generate-property-map-tiles \
  --project {{gcp_project}} \
  --region us-east4 \
  --source . \
  --cpu 4 \
  --memory 2Gi
```

The first time you run this command, the `gcloud` tool will ask you a question like the following:

```
Deploying from source requires an Artifact Registry Docker repository to store built containers. A repository named [cloud-run-source-deploy] in region [us-east4] will be created.

Do you want to continue (Y/n)?
```

This is because your Containerfile needs to be built into an image file, and that image needs to be stored somewhere (in GCP, this place where images are built and stored is called an "Artifact Registry"). Go ahead and answer `Y`.

## Testing the job

```bash
gcloud run jobs \
  execute generate-property-map-tiles \
  --project {{gcp_project}} \
  --region us-east4
```

If it's working correctly, it will take a while (like 15 minutes), but will complete by copying a bunch of tile files to GCS.

**Acceptance criteria:**
- [ ] A Cloud Run job named `generate-property-map-tiles` using the Containerfile and script above
- [ ] The job should run successfully and copy a bunch of tile files to the public bucket
- [ ] The job should be scheduled to run as part of the data pipeline