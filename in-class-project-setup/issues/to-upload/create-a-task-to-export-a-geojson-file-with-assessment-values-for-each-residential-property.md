---
title: "Create a task to export a GeoJSON file with the assessment values for each residential property"
labels: ["Scripting","Analysis","Front-end"]
---

* Refer to #6 for the full motivation for this task.

## Overview

This issue walks through creating a Cloud Function that exports a file containing the residential properties in Philadelphia to the `{{gcp_project}}-temp_data` bucket. The function should be included as part of your data pipeline workflow, and should export the file as `property_tile_info.geojson` in the bucket. **NOTE that this issue is structured around GeoJSON as the file format, but you can use any file format that ogr2ogr can understand, as that's what we'll use to convert the file into vector tiles in issue #6**.

At a high level, the function should do the following:

1. Join the parcel data from the PWD parcels with the assessment values (both historical market values and predicted market values), along with any other property characteristics data from OPA properties that you want to surface in the assessment review dashboard.
2. Convert the result of your query from step 1 into a GeoJSON file.
3. Upload the GeoJSON file to the `{{gcp_project}}-temp_data` bucket as `property_tile_info.geojson`.

## Acceptance Criteria

- [ ] A Cloud Function is created that exports a file containing the residential properties in Philadelphia to the `{{gcp_project}}-temp_data` bucket as `property_tile_info.geojson`.
- [ ] The Cloud Function is included as part of your data pipeline workflow.
- [ ] The GeoJSON file contains the parcel data from the PWD parcels with the assessment values (both historical market values and predicted market values), along with any other property characteristics data from OPA properties that you want to surface in the assessment review dashboard.
- [ ] The GeoJSON file is valid and can be converted into vector tiles using ogr2ogr.
