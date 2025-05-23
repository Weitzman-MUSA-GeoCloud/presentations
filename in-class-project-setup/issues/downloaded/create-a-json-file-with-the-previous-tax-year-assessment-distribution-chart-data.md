---
title: "Create a JSON file with the previous tax year assessment distribution chart data"
labels: ["Analysis","Front-end"]
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

See issue #8 for more detail on the source table.

Store the file in the `gs://musa509s2023_team1_public` bucket in a file named `/configs/tax_year_assessment_bins.json`. This file can be fetched and used to help populate the chart for the previous tax year's assessment values.

**Acceptance criteria:**
- [ ] A Cloud Function named `generate-assessment-chart-configs` that generates the `/configs/tax_year_assessment_bins.json` file.