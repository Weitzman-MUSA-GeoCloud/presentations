---
marp: true
style: |
  .columns-2 {
    display: grid;
    grid-template-columns: repeat(2, minmax(0, 1fr));
    gap: 1rem;
  }
  table {
    font-size: 0.85em;
  }
---

# In-class Project Wrap-Up

---

## Not a presentation day

Last year we did team presentations. This year, we're doing something different.

Instead of each team presenting end-to-end, we're going to have **three structured discussions** — one for each major component of the project.

You'll each say something about what you did, then we discuss as a class.

The goal is to compare approaches and reflect together, not to show a polished product.

---

## Three blocks, ~55 min each

| Time | Block |
|------|-------|
| 0:00–1:00 | **Block 1:** Data Pipelines |
| 1:05–2:00 | **Block 2:** Sale Price Modeling |
| 2:05–3:00 | **Block 3:** UI & Application |

Each block: teams share (~5 min each), then open discussion (~20 min).

---

## Pre-class prep (due Wednesday morning)

Fill in your team's row in the shared Google Sheet — **one row per block**.

This is the main prep I'm asking for. It should take 20–30 min. I'll use it to see what's coming, and at the start of each block we'll project the full table so everyone can see where teams landed before anyone speaks.

---

## What to fill in

**Block 1 – Data Pipelines:**
- Datasets used
- Key cleaning/transformation steps
- BigQuery artifacts you created
- One thing you'd change

---

## What to fill in

**Block 2 – Sale Price Modeling:**
- Features used
- Algorithm/approach
- How you evaluated it (metric + value)
- Biggest known weakness

---

## What to fill in

**Block 3 – UI / Application:**
- How you described your primary users
- One design decision you're proud of
- One thing you'd add with more time

---

## What to expect in class for each block

1. We look at the comparison table together
2. Each team takes ~5 min to walk us through their approach
   - No slides! Pull up your actual code, your GCP Workflow graph, your BigQuery schema
3. Open discussion for ~20 min

---

## Block 1: Data Pipelines

**What your team should cover (~5 min):**
- What datasets did you use, and why?
- Walk through your pipeline — show the GCP Workflow graph
- What does your BigQuery warehouse look like at the end?
- What cleaning step took the most work?

**Discussion we'll have:**
- Which pipeline felt most production-ready? Why?
- What cleaning choice matters most for the model downstream?
- What would break first if this ran daily in production?

---

## Block 2: Sale Price Modeling

**What your team should cover (~5 min):**
- What features did you use? What did you discard?
- What modeling approach did you take?
- How did you decide your model was good enough?
- What's your model's biggest weakness?

**Discussion we'll have:**
- How do different teams define "good enough"?
- What's hard about evaluating an automated valuation model?
- If a homeowner challenged your estimate, what would you say?

---

## Block 3: UI & Application

**What your team should cover (~4 min):**
- **Live demo** (~2 min)
- Who was your primary user — assessor or property owner?
- One design decision you're proud of
- One thing you'd add with more time

**Discussion we'll have:**
- What features appeared across multiple teams?
- Where did teams make different trade-offs between audiences?
- What would it take to actually deploy one of these?

---

## To summarize

1. Fill in the Google Sheet by **Wednesday morning**
2. Come to class ready to talk through your work — no slides, no script
3. Pull up your actual code, pipeline, and app

See you Wednesday!
