
# ✅ Unified Medical Reference App  

**Purpose:** Quick offline access to curated OPD and Emergency case notes for newly graduated doctors or duty doctors.

---

## 🎯 Core Features to Implement

### 🔹 1. **Case Database (Offline, ObjectBox)**

- Unified model (`MedicalCase`)
- Fields:
  - `title`
  - `type` (OPD or Emergency)
  - `presentation`, `symptoms`, `examination`
  - `differentials`, `investigations`
  - `management` for: ER / Ward / OPD / Home
  - `notes`, `createdAt`

---

### 🔹 2. **Case List View**

- Scrollable, searchable list of all cases
- Filters:
  - By **type**: OPD / Emergency / All
  - By **system** (optional: Cardio, Neuro, Skin…)
- Optional:
  - Sorting (A–Z, Recently Added)
  - Favorites

---

### 🔹 3. **Case Detail View**

- Clean display of:
  - Overview / Presentation
  - Symptoms
  - Examination
  - Differentials
  - Investigations
  - Management (ER, Ward, OPD, Home) → show in expandable tiles or tabs
  - Notes section (editable and stored locally)

---

### 🔹 4. **Search Functionality**

- Search by:
  - Case title
  - Symptoms
  - Keywords in content

---

### 🔹 5. **Add/Edit Custom Notes**

- Per-case personal notes section
- Stored locally with ObjectBox
- Optional backup/export option

---

### 🔹 6. **Data Import/Export (Optional)**

- JSON import/export for full case data and notes
- Helpful if you plan updates later or want to crowdsource data

---

### 🔹 7. **UI Polish**

- Theme suitable for clinical use (light/dark)
- Quick access toolbar:
  - 🔍 Search
  - 🏷️ Filter
  - 📋 All Cases

---

## 📦 Optional (Advanced Features)

- **Pin/Favorite Cases**
- **System/Organ Tags** (e.g., cardio, neuro, derm)
- **Offline-first syncing system** for future scalability (e.g., ObjectBox Sync if needed later)
- **Admin Mode** for adding/editing raw case data

---

Would you like a working sample model + list page for this combined app in Flutter using ObjectBox and minimal UI?
