# Olist Sales Analytics

SQL analysis of the [Olist Brazilian E-Commerce dataset](https://www.kaggle.com/datasets/olistbr/brazilian-ecommerce) (Kaggle), built with PostgreSQL. I loaded the raw CSV files, modeled them as a star schema and answered five business questions with SQL.

**Period covered:** Sep 2016 - Aug 2018 (99,441 orders).

## Tools
PostgreSQL 18 · DBeaver · SQL (CTEs, window functions, joins, date operations)

## Data model
Raw tables are reorganized into a star schema:

- **Fact table:** `fact_sales` (one row per item in an order, 112,650 rows)
- **Dimensions:** `dim_customer`, `dim_product` (categories translated to English), `dim_seller`, `dim_date`

## Scripts

| File | Content |
| --- | --- |
| `01_create_tables.sql` | Raw tables |
| `02_star_schema.sql` | Dimensions and fact table |
| `03_monthly_revenue.sql` | Q1: monthly revenue |
| `04_top_categories.sql` | Q2: top categories by revenue |
| `05_customer_retention.sql` | Q3: repeat customers |
| `06_delivery_times.sql` | Q4: delivery time by state |
| `07_payment_methods.sql` | Q5: payment methods |

## Findings

**1. Monthly revenue.** Sales are negligible before 2017 (and November 2016 has no records). Revenue grew from about R$112k in January 2017 to a peak of R$988k in November 2017 (7,289 orders, consistent with Black Friday), then stayed between roughly R$830k and R$980k per month in 2018. Revenue is the item price of delivered orders, excluding freight.

**2. Top categories.** Health & beauty leads in revenue (R$1.23M), followed by watches & gifts (R$1.17M). Bed & bath sells the most units (10,953) but ranks third in revenue because of its lower average price (about R$93, versus about R$199 for watches & gifts).

**3. Customer retention.** 97% of customers (90,557) placed only one delivered order; 3% (2,801) placed two or more. Growth in 2017 therefore came mainly from new customers. Olist creates a new `customer_id` for every order, so customers are identified with `customer_unique_id`.

**4. Delivery times.** Average delivery time varies widely by state. Northern states such as RR, AP and AM take 26-29 days on average, but with few orders (41, 67 and 145). Delay rates do not follow delivery time: AL and MA have high shares of late orders (24% and 20%), while AP and AC have low ones (about 4%).

**5. Payment methods.** Credit card accounts for 78% of payment value (R$12.1M), followed by boleto (18%). Credit card is the only method used in installments (3.5 on average). Payment values include freight, so they do not match the revenue in Q1.

## Limitations
- Only delivered orders are analyzed.
- Findings describe patterns in the data; they do not establish causes.
- Some state-level results rely on small samples.

## Next steps
Build an interactive dashboard (Tableau Public) with these results.
