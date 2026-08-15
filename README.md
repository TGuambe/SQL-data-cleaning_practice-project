# Cafe Sales Data Cleaning - PostgreSQL

## 📌Overview
This project focuses on cleaning and preparing a cafe sales dataset using PostgreSQL.

The main purpose of this project was to practice and strengthen my understanding of SQL-based data cleaning, while also developing the analytical reasoning required to determine why a particular cleaning technique should be used rather than simply applying SQL functions mechanically.

This is a practice-focused project rather than a full business analysis. The goal was to work through a realistic, messy dataset and apply a structured data-cleaning workflow from raw data through to a validated dataset suitable for further analysis.

### Dataset
The dataset contains cafe transaction records with the following fields:
- `transaction_id`
- `item`
- `quantity`
- `price_per_unit`
- `total_spent`
- `payment_method`
- `location`
- `transaction_date`

The raw dataset contained issues including:
- Missing values
- ERROR and UNKNOWN values
- Potential duplicate records
- Whitespace inconsistencies
- Incorrect data types & formatting
- Missing transactional values that could potentially be reconstructed

## Data Cleaning Process
### 1. Duplicate Identification

I used `ROW_NUMBER()` to identify potential duplicate records based on the complete set of transaction attributes.
I also checked the transaction_id using `COUNT()` and `GROUP BY` to determine whether individual transaction IDs occurred more than once.

No duplicate records were identified.

#### 2. Staging Table
A separate staging table, cafe_sales2, was created from the original dataset.
This allowed the original imported data to remain unchanged while the cleaning process was performed on a working copy.

### 3. Whitespace Removal
`TRIM()` was applied to the text-based columns to remove leading and trailing whitespace.
 
### 4. Standardising Invalid Values
Values such as:
- ERROR
- UNKNOWN
were converted to SQL `NULL` values.
This created a consistent representation of missing information before further cleaning.

### 5. Handling Missing Values
Where possible, missing numerical values were reconstructed using the relationship:
- Total Spent = Quantity × Price Per Unit

For example:
- Missing quantity → total_spent / price_per_unit
- Missing price per unit → total_spent / quantity
- Missing total spent → price_per_unit × quantity

This allowed recoverable information to be retained rather than unnecessarily deleting records.

### 6. Data Type Conversion
COLUMN                | DATA TYPE
- `transaction_id`	  | `TEXT`
- `item`              | `TEXT`
- `quantity`          | `INTEGER`
- `price_per_unit`    | `NUMERIC(10,2)`
- `total_spent`	      | `NUMERIC(10,2)`
- `payment_method`    | `TEXT`
- `location`	      | `TEXT`
- `transaction_date`  | `DATE`


### 7. Removing Unusable Records
Three records were removed because item, price_per_unit, and total_spent were all `NULL`.
These records contained insufficient information to contribute meaningfully to the intended sales analysis, while records with recoverable missing values were retained.

## Tools Used
- PostgreSQL
- SQL
- GitHub

## Key Takeaway
One of the biggest lessons from this project was that data cleaning is not purely a technical process.

Knowing how to use `ROW_NUMBER()`, `COUNT()`, `TRIM()`, `UPDATE`, `ALTER TABLE`, and `TYPE` conversions is important. However, understanding when and why to use those techniques is equally important.
The quality of a cleaning process depends not only on whether the SQL works, but also on whether the decisions being made are appropriate for the data and the intended analysis.

