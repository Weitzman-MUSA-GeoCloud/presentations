# In-Class Activity: Deconstructing "Suggest-a-Station"

**System**: Bluebikes Suggest-a-Station Tool (https://bluebikes.com/suggest-a-station)
**Duration**: ~30 Minutes
**Goal**: Build intuition about data collection systems by tracing data flow through a real geospatial application.

---

## Phase 1: Explore (5 Minutes)

**Prompt**: "Open the Bluebikes station suggestion map. Click on a location where you'd want a new station. Walk through the submission form (you don't have to actually submit)."

**Observe**:
*   What information does the form ask for?
*   What information does the map *show you* about that location before you submit?

---

## Phase 2: Think-Pair-Share — Data Flow (10 Minutes)

### Think (2 min, individual)
Answer silently: *"Identify one piece of data you provide when you submit. Where does that data show up in the interface for someone else viewing the map later?"*

### Pair (3 min, with a partner)
Compare your answers. Did you identify the same data flows?

### Share (5 min, table discussion)
Each table identifies **one data element** and traces its round-trip:
*   **Checkboxes ("Close to my home", etc.)** → Aggregated into the **pie chart** shown in the sidebar.
*   **Map click (lat/lon)** → Contributes to the **orange heatmap circles** on the map (darker = more suggestions nearby).
*   **"15 other people have suggested..."** → A count query based on *your* location.

---

## Phase 3: Diagram the System (10 Minutes)

**Prompt**: "As a table, sketch a system diagram. Trace a single suggestion from click to appearing on someone else's map."

**Suggested Components**:
```
[User clicks map] → [Frontend captures lat/lon + form data]
        ↓
[POST request to API]
        ↓
[Backend validates & stores in Database]
        ↓
[Another user loads page] → [API query: "suggestions near this point"]
        ↓
[Frontend aggregates & renders orange circles + pie chart]
```

**Bonus Question**: The form has a "Tell us more" free-text field. Why might that data *not* appear in the public interface, even though it's collected?

*(Hint: Think about what would be required to display user-generated text publicly.)*

---

## Phase 4: Debrief (5 Minutes)

**Instructor-Led Discussion**:

1.  **Structured vs. Unstructured Data**: The checkboxes are easy to aggregate (pie chart). The free-text field is valuable for planners but harder to display publicly (content moderation, interpretation).

2.  **Data for Different Audiences**: Not all collected data needs to flow back to every user. Planners see the free-text; the public sees aggregations.

3.  **Comparison to a Physical Suggestion Box**:
    *   **Scale**: 1000s of digital inputs vs. 10s of paper slips.
    *   **Structure**: Digital forces a valid coordinate; paper allows "near the park".
    *   **Feedback**: Digital shows "15 others suggested here" instantly.
