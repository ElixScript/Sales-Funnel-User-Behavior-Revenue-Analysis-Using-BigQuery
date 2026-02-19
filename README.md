# Sales-Funnel-User-Behavior-Revenue-Analysis-Using-BigQuery

**SQL Analysis Portfolio Project**

## Project Overview

This project presents an end-to-end SQL analysis using **Google BigQuery** to evaluate sales funnel performance, user behavior, traffic source quality, and revenue impact. The analysis is designed to simulate real-world business, growth, and risk-related use cases using event-level transaction data.

The project demonstrates the ability to transform raw transactional data into actionable business insights through structured SQL queries.

---

## Objectives

* Analyze user progression through the sales funnel.
* Measure conversion rates across different funnel stages.
* Evaluate traffic source quality based on user behavior and conversions.
* Analyze user journey duration and time to conversion.
* Connect funnel performance with revenue and monetization metrics.

---

## Dataset Description

The dataset consists of event-level transaction records where each row represents a user action on the platform.

**Key columns:**

* `event_id`: Unique identifier for each event.
* `user_id`: Unique identifier for each user.
* `event_type`: Type of user action (page_view, add_to_cart, checkout_start, payment_info, purchase).
* `event_date`: Timestamp of the event occurrence.
* `product_id`: Identifier of the product involved.
* `amount`: Transaction value recorded during purchase events.
* `traffic_source`: Source of user acquisition (e.g., email, organic, social media).

All analyses are performed on data from the **last 30 days**.

---

## Analysis Steps

### Step 1 – Data Understanding & Sanity Check

Initial exploration of the dataset to understand structure, validate key columns, and confirm event-level data integrity before conducting further analysis.

### Step 2 – Sales Funnel Overview

High-level funnel analysis calculating the number of unique users at each stage and measuring conversion rates between stages to identify drop-off points and overall funnel efficiency.

### Step 3 – Funnel by Traffic Source

Segmentation of the sales funnel by traffic source to evaluate channel quality, conversion performance, and potential inefficiencies or low-quality traffic sources.

### Step 4 – User Journey & Time to Conversion

Analysis of user journey timelines by identifying the first occurrence of key events (view, cart, purchase) to calculate average time-to-conversion and detect potential friction or abnormal behavior.

### Step 5 – Funnel & Revenue Performance

Revenue-focused analysis connecting funnel performance to financial metrics, including total revenue, average order value (AOV), revenue per buyer, and revenue per visitor.

---

## Key Insights

* The largest drop-off occurs at the early funnel stage (page view to add to cart), indicating an opportunity for UX or product presentation optimization.
* Checkout and payment stages show high efficiency, suggesting minimal friction during transaction completion.
* Email traffic demonstrates the highest conversion quality compared to other channels.
* Average user journey duration highlights potential optimization opportunities in the cart-to-purchase stage.
* Revenue growth opportunities are driven more by improving early funnel conversion rather than increasing transaction value.

---

## Tools & Technologies

* **Google BigQuery**
* **SQL (CTE, aggregation, conditional logic, time-based analysis)**

---

## Use Cases

* Business and growth analytics
* Marketing performance evaluation
* Risk and fraud behavior analysis
* Funnel optimization and revenue strategy

---

## Author

**Bagus Cipta Pratama**
* Create a one-page project summary for CVs
* Prepare interview explanations based on this project
