---
title: "Create a pipeline to ingest the PWD Parcels into a BigQuery table"
labels: ["Scripting"]
---

- Refer to issue #1 for detail.

**Acceptance Criteria:**
- [ ] A Cloud Function named `extract-pwd-parcels` to fetch the PWD Parcels dataset and upload into a Cloud Storage bucket named `{{gcp_project}}-raw_data` into a folder named `pwd_parcels/`
- [ ] A Cloud Function named `prepare-pwd-parcels` to prepare the file in `gs://{{gcp_project}}-raw_data/pwd_parcels/` for backing an external table. The new file should be stored in JSON-L format in a bucket named `{{gcp_project}}-prepared_data` and a file named `pwd_parcels/data.jsonl`. All field names should be lowercased.
- [ ] A Cloud Function named `load-pwd-parcels` that creates or updates an external table named `source.pwd_parcels` with the fields in `gs://{{gcp_project}}-prepared_data/pwd_parcels/data.jsonl`, and creates or updates an internal table named `core.pwd_parcels` that contains all the fields from `source.pwd_parcels` in addition to a new field named `property_id` set equal to the value of `brt_id` (note that the `brt_id` field may be an integer in the PWD dataset, so you may need to zero-pad the value to a 9-digit string).
- [ ] A [parallel branch](https://cloud.google.com/workflows/docs/reference/syntax/parallel-steps) added to the Workflow named `data-pipeline` to run each function in step.