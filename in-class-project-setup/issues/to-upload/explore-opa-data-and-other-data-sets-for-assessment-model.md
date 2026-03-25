---
title: "Explore OPA data (and other data sets) for assessment model"
labels: ["Data Science","Get Started"]
---

In order to add a model to our pipeline, we first need to know what type of model performs best, and what features are most useful for that model. There's not really a way to do that without some good ol' fashioned exploratory data analysis.

This issue is to explore the OPA data and other data sets to determine what features are most useful for predicting property values.

**Some things you should keep in mind as you explore the data:**
* The model that you eventually build should attempt to predict the `sale_price` of a property. Note that the `opa_properties` table also has a `market_value` field, which is the OPA's estimate of the property's market value, and is not the same as the `sale_price` field, which is the actual price that the property commanded on the market. The model should use the `sale_price` field as the target, not the `market_value` field.
* Keep in mind that the `sale_price` represents how much the property was last sold for, and the `sale_date` represents the date of the last sale. You probably want to take both into account, as properties that were sold more recently are likely to have a stronger signal for what the current value of other properties is.
* Some properties have a very low sale price, like $1. These are likely properties that were transferred between family members. You may want to exclude these properties from your model, as they are not representative of the market value of the property.
* Some properties are sold as part of a bundle of properties. These are likely to have a lower sale price per property than properties that are sold individually. You may want to exclude these properties from your model, as they are not representative of the market value of the property. You can identify these properties by looking at the `sale_price` and `sale_date` fields of the `opa_properties` table. Properties sold on the exact same day with the exact same sale price are likely to be part of a bundle (the `sale_price` value of the properties is going to represent the price of the entire bundle, not the price of any individual property).

**Acceptance Criteria:**
- [ ] A markdown document explaining the useful features and an outline of the feature engineering necessary for model training and prediction
- [ ] Any artifacts (notebooks, R markdown, etc) should be committed to the `eda/` folder. Data sources for the exploration should be documented, but the data itself should not be committed to the repository.