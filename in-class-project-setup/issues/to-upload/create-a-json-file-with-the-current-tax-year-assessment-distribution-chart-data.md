---
title: "Create a JSON file with the current tax year assessment distribution chart data"
labels: ["Scripting", "Front-end"]
---

Create a cloud function that will query the `derived.current_assessment_bins` table, and generate a JSON file that the front end can read to inform a chart configuration. The format should look something like:

```js
[
  {"tax_year": ..., "lower_bound": ..., "upper_bound": ..., "property_count": ...},
  {"tax_year": ..., "lower_bound": ..., "upper_bound": ..., "property_count": ...},
  {"tax_year": ..., "lower_bound": ..., "upper_bound": ..., "property_count": ...},
  ...
]
```

- Work with the front-end team to determine the best way to represent this data in the chart. See issue #8 for more detail on the source table.

Store the file in the `gs://{{gcp_project}}-public` bucket in a file named `/configs/current_assessment_bins.json`. This file can be fetched and used to help populate the chart for the current tax year's assessment values.

**Acceptance criteria:**
- [ ] A Cloud Function named `generate-assessment-chart-configs` that generates the `/configs/current_assessment_bins.json` file.