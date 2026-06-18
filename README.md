# ApexPlanet Data Analytics Internship - 30 Days

## 🎯 Internship Overview
This repository contains all tasks completed during the **ApexPlanet 30-Day Data Analytics Internship**.  
**Dataset:** Superstore Sales

---

## 📁 Repository Structure
```
apexplanet-data-analytics/
├── data/                   # Raw and cleaned datasets + SQLite database
├── notebooks/              # Jupyter notebooks for each task
├── sql/                    # SQL query files
├── scripts/                # Python scripts
├── reports/                # Exported results and visualizations
├── dashboards/             # Dashboard files
└── README.md
```

---

## ✅ Task 1 – Foundational Setup & Exploratory Data Analysis (EDA)
### 🛠️ Libraries Used
- **pandas** - Data manipulation
- **numpy** - Numerical operations
- **matplotlib** - Static visualizations
- **seaborn** - Statistical plots
- **plotly** - Interactive charts
- **sqlalchemy** - Database operations

### 📂 Files
| File | Description |
|------|-------------|
| `notebooks/task1_eda.ipynb` | Main EDA notebook with cleaning + visualizations |
| `data/superstore_cleaned.csv` | Cleaned dataset after preprocessing |

### 💡 Key Insights
1. Technology is the top-selling category
2. West region leads in sales
3. Strong correlation between Sales and Profit
4. Consumer segment is most valuable
5. Sales show seasonal trends

### 🚀 How to Run
```bash
pip install pandas numpy matplotlib seaborn plotly sqlalchemy jupyter
jupyter notebook notebooks/task1_eda.ipynb
```

---

## ✅ Task 2 – SQL for Data Extraction

### 🛠️ Tools Used
- **SQLite** - Lightweight database (built into Python, no install needed)
- **sqlalchemy** - Python to SQLite connection
- **pandas** - Execute SQL queries via `read_sql()`
- **openpyxl** - Export results to Excel
- **SQLite Online** - Used for Day 7-8 basic query practice

### 📂 Files
| File | Description |
|------|-------------|
| `sql/task2_sql_queries.sql` | All SQL queries (Fundamentals + Advanced + 10 Business Questions) |
| `notebooks/task2_python_sql.ipynb` | Python + SQLite integration notebook |
| `data/superstore.db` | SQLite database generated from cleaned dataset |
| `reports/task2_sql_results.xlsx` | Exported results for all 10 business questions |

### 📝 SQL Topics Covered
- **Day 7-8:** SELECT, WHERE, ORDER BY, GROUP BY, HAVING, JOINs
- **Day 9-10:** CTEs (WITH clause), Window Functions (RANK, LAG, ROW_NUMBER), Views
- **Day 11-13:** Python + SQLite integration, 10 business questions answered via SQL

### ❓ 10 Business Questions Answered
1. Top 5 products by total sales
2. Monthly revenue trend
3. Customer segmentation by spend (High / Mid / Low Value)
4. Most profitable shipping mode
5. Top 5 loss-making sub-categories
6. Top 10 states by revenue
7. Impact of discount bands on profit
8. Average order value by customer segment
9. Year-over-year sales comparison
10. Top 10 most valuable customers by lifetime profit

### 🚀 How to Run
```bash
pip install sqlalchemy pandas openpyxl
jupyter notebook notebooks/task2_python_sql.ipynb
```

---

## 🔄 Upcoming Tasks
- **Task 3** – Data Visualization & Dashboarding *(Days 14-20)*
- **Task 4** – Advanced Analytics & Statistical Modeling *(Days 21-26)*
- **Task 5** – Final Report, Automation & Presentation *(Days 27-30)*

---
