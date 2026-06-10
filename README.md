# 🛒 E-Commerce Customer Behavior & Cohort Retention Analysis (SQL Project)

Welcome to the **Customer Behavior and Shopping Habits** analysis project! This repository contains the complete PostgreSQL scripts and business insights derived from analyzing transaction data in 2023. This project was developed as the Final Project for the **Master SQL for Data Analyst Bootcamp** by Genggam Data.

---

## 📌 Project Overview & Objectives
As a Data Analyst, the objective of this project is to support the **Marketing, Growth, and Business Development** teams by providing data-driven recommendations to optimize sales, evaluate promotional efficiency, and understand customer retention challenges.

The project is structured into **5 main analysis scopes**:
1. **Descriptive Analysis** — Fundamental health metrics of the storefront.
2. **Performance Sales & Growth Analysis** — Identifying monthly sales trends and category growth dynamics.
3. **Promotional Cost Efficiency Analysis** — Tracking marketing spend effectiveness (Burn Rate) against the corporate 43% ceiling.
4. **Customer Retention (Cohort) Analysis** — Assessing customer lifecycle and long-term brand loyalty.
5. **Customer Behavior Analysis** — Segmenting preferences by demographic (gender) and testing rating correlations.

---

## 📊 Executive Summary & Key Business Insights

* 📉 **The Retention Challenge:** Our Cohort Analysis reveals a critical drop-off in customer loyalty. On average, **over 50% of new customers churn after their very first month**. Acquiring customers is expensive; we must shift our focus to post-purchase loyalty programs or targeted re-engagement campaigns.
* 🚨 **Promotional Overspending:** In the first half of 2023, promotional efficiency was severely compromised. Monthly **burn rates peaked in June at 47.16%**, continuously breaching management's maximum threshold of **43%**. Fortunately, tighter targeting strategies in Q4 brought spending back to an efficient 43.35% by December.
* 🛍️ **Gender-Targeted Campaigns:** Cross-gender data identifies *Pants* and *Jewelry* as universally strong sellers. However, to maximize ROI on marketing campaigns, the team should specifically target **Male audiences for *Coat* and *Sweater***, and **Female audiences for *Blouse* and *Sandals***.
* 🔄 **Sales Fluctuation & Peak Season:** Overall revenue is highly volatile, hitting its lowest point in June ($9,451.20) but skyrocketing to its absolute annual peak in **October ($12,303.98)**. 
* 🚫 **The Rating Paradox:** A Pearson Correlation test between product review ratings and total purchase volumes yielded **$r = -0.00038$**. This statistically proves that customer purchasing decisions are completely independent of review scores, meaning other factors like pricing, seasonal urgency, or promotions drive the volume.

---

## 🛠️ Tech Stack & Dataset
* **Database Management System:** PostgreSQL (via DBeaver / pgAdmin)
* **Visualization Tools:** Google Sheets / Microsoft Excel
* **Core SQL Features Used:** Common Table Expressions (CTEs), Window Functions (`LAG()`, `ROW_NUMBER()`), Aggregations (`SUM`, `COUNT DISTINCT`), Date Extractions (`EXTRACT`).
* **Dataset:** *Customer Behavior and Shopping Habits 2023* (3,900 rows, 551 unique customers).

---

## 🔍 Deep-Dive Analysis Breakdown

### 1. Descriptive Analysis (2023 Store Overview)
A basic exploration to quantify the storefront scale in 2023:
* **Total Transactions:** 3,900 orders
* **Unique Customers:** 551 active shoppers
* **Total Adjusted Revenue:** \$128,673.73 *(calculated net of discounts applied)*
* **Product Variety:** 4 main categories containing 25 unique items.
* **Average Shopper Age:** 23.96 years old *(highly skewed towards Gen-Z and Millennials)*

### 2. Performance Sales & Growth Analysis
Monthly metrics indicate sharp seasonal behaviors. Growth rates were calculated using the standard formula:
$$\text{Growth Percentage} = \left( \frac{\text{Current Month}}{\text{Previous Month}} - 1 \right) \times 100$$

* **High Performance Months:** October (+9.85% Order Growth) and March (+13.13% Order Growth).
* **Low Performance Months:** June saw a steep decline of -13.06% in transactions, highly correlating with our worst promotional overspend.

### 3. Promotional Cost Efficiency Analysis
Management set a strict rule: **The Burn Rate must not exceed 43%**. 
$$\text{Burn Rate} = \left( \frac{\text{Total Discount Value (USD)}}{\text{Total Gross Sales (USD)}} \right) \times 100$$

| Month | Total Sales ($) | Promotional Value ($) | Burn Rate (%) | Status |
|---|---|---|---|---|
| January | 19,547 | 8,677.53 | 44.39% | 🔴 Exceeded |
| June | 17,740 | 8,366.08 | **47.16%** | 🔴 Critical Overspend |
| October | 21,792 | 9,488.02 | 43.54% | 🟡 Near Limit |
| December | 18,725 | 8,116.82 | **43.35%** | green_circle: Optimal Control |

* **Takeaway:** The promotional strategy was highly inefficient for 9 out of 12 months. Sales did not scale proportionally to the deep discount cuts given out mid-year.

### 4. Customer Retention Analysis (Cohort Framework)
By establishing the month of a customer's first purchase as their cohort group, we tracked their recurring transactions over an 11-month index window.
* **Retention Rate (%)** reflects high initial dropouts. Customers entering in January (Cohort 1) show a month-1 retention of 43%. While it slightly bounces back in later months due to holiday seasons, losing 57% of customers immediately indicates low post-purchase engagement.
* **Churn Rate Analysis** confirms that over the entire year, average churn immediately hovers above 50% for almost every cohort. 

### 5. Customer Behavior & Preferences
* **Top 3 Most Frequently Purchased Items:** *Pants*, *Blouse*, and *Jewelry* (tied at 171 sales each).
* **Demographic Preference Rank:**
  * **Male Top 3:** Pants ➡️ Jewelry ➡️ Coat
  * **Female Top 3:** Blouse ➡️ Sandals ➡️ Shirt
* **Statistical Analysis:** The Pearson Correlation value of **-0.00038** implies zero linear correlation. Poorly rated items sell just as frequently as 5-star items, emphasizing that the brand's target audience is highly price-sensitive rather than quality-review focused.

---

## 📈 Strategic Business Recommendations

1. **Implement a Customer Loyalty Program:** Address the 50%+ churn rate immediately. Introduce a points-based system or offer an exclusive voucher specifically for a customer's *second* purchase to bridge the gap between Month 0 and Month 1.
2. **Revamp Promotional Allocation:** Drop the generalized, heavy discounting patterns seen in Q2 (June). Transition towards personalized, behavior-based targeted discounts (e.g., automated email discounts on birthdays or specific item restocking notifications).
3. **Hyper-Personalized Marketing Assets:** Sync social media and ad copy with the demographic preferences matrix. Automate web banners so that male users are greeted with coats and sweaters, while female users see blouse and sandal collections first.

---

## 📁 Repository Structure
```bash
├── Script.sql          # Full PostgreSQL code containing all sections neatly structured
└── README.md           # Business context, graphs, and executive project overview
