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

Instead of each team presenting their project end-to-end, we're going to have **three structured discussions** — one for each major component of the project.

Each team will say something about what they did, then we discuss as a class.

The goal is to compare approaches and reflect together, not to show a polished presentation.

---

## Three blocks, ~55 min each

| Time | Block |
|------|-------|
| 1:45–1:55 | **Arrive & settle in** |
| 1:55–2:40 | **Block 1:** Data Pipelines |
| 2:40–2:45 | **Break** |
| 2:45–3:30 | **Block 2:** Sale Price Modeling |
| 3:30–3:35 | **Break** |
| 3:35–4:20 | **Block 3:** UI & Application |
| 4:20–4:35 | **Wrap-up** |

Each block: teams share (~5 min each), then open discussion (~15-30 min).

---

## Pre-class prep (due Wednesday morning)

Fill out your team's responses in the shared Google Form. For each block, make sure to think about:

- Aspects you think were clever, interesting, or particularly challenging
- What you'd change if you had more time

This is the main prep I'm asking for. It should take 20–30 min. I'll use it to see what's coming.

---

## What to fill in

**Block 1 – Data Pipelines:**
- Datasets used
- Pipeline structure (monolithic? modular?)
- Key cleaning/transformation steps
- BigQuery artifacts you created
- Cloud Storage artifacts you created

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
- Specific choices you made to meet your users' needs

---

## What to expect in class for each block

1. Based on your team's responses in the Google Form, I'll determine the order in which teams present
2. Each team takes ~5 min to walk us through their approach
   - No slides! Pull up your actual code, your GCP Workflow graph, your BigQuery schema, your GitHub Pages site
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
- Where did teams make different trade-offs between audiences? Why?
- What would it take to actually deploy one of these?

---

## To summarize

1. Fill in the Google Form by **Wednesday morning**
2. Come to class ready to talk through your work — no slides, no script
3. Pull up your actual code, pipeline, and app

See you Wednesday!
