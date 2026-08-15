# Lessons Learned — Cafe Sales Data Cleaning

## Why I Built This Project
This project was primarily created as a practice exercise.
My goal was not to produce an elaborate business analysis, but to test whether I genuinely understood the data-cleaning techniques I had been learning in PostgreSQL.
As I worked through the dataset, however, I realised that data cleaning involves much more than knowing which SQL functions to use.
The technical skills are important, but the reasoning behind those techniques is just as important.

---
## 1. Data Cleaning Is More Than Writing SQL
One of my biggest lessons from this project was that data cleaning is not just a technical process.

It is easy to approach data cleaning as a list of SQL techniques:
1. Find duplicates
2. Use `TRIM()`
3. Replace errors
4. Handle `NULL`
5. Change data types
6. Delete bad rows

Data cleaning is more about preparing data for further analysis and visualizations later on. 
Thus, the more important questions are:
- Why am I doing this?
- What exactly am I trying to fix?
- What does this data represent?
- Could this information be recovered instead of removed?
- Will this transformation affect my future analysis?
- Am I making an assumption that the data does not support?

This project helped me understand that technical SQL knowledge and analytical judgment need to work together.

---

## 2. Duplicate Detection Needs Context
Initially, I approached duplicate detection primarily through `ROW_NUMBER()`.

Using something like:
```sql
ROW_NUMBER() OVER (
    PARTITION BY ...
)
```
which is is a valid way to identify duplicate records, and it is a technique I wanted to practice.

However, this project made me realise that duplicate detection should also consider the structure of the dataset.
This dataset contained a `transaction_id`, which provided a unique identifier for each transaction.

Because of that, checking:
```sql
SELECT transaction_id, COUNT(*)
FROM cafe_sales
GROUP BY transaction_id
HAVING COUNT(*) > 1;
```
provided another way of investigating duplicates.

This was particularly useful because my previous data-cleaning project did not contain such a clear unique identifier. In that situation, using the available columns together with techniques such as `ROW_NUMBER()` was much more important.

### Lesson: 
The structure of the dataset influences the method used to identify duplicates.

---

## 3. Learn the Business Before Deciding What Is "Bad" Data
Another major lesson was the importance of understanding the business behind the data.

A dataset can contain many columns, but that does not mean every column will have equal importance for every analysis.

For this project, I considered fields such as:
* Item
* Quantity
* Price per Unit
* Total Spent
* Location
* Payment Method

The first four are directly connected to sales performance, while location and payment method can provide additional context.
However, without knowing the actual cafe's business model, I cannot confidently claim that payment method is irrelevant.

For example, a real business might want to analyse payment methods because of:
* Customer preferences
* Digital payment adoption
* Differences in purchasing behaviour

Therefore, rather than assuming that a column is useless, it is better to understand the business question being asked first.

---

## 4. Data Cleaning Involves Making Decisions
The most interesting decision in this project involved three records where:
* `item` was `NULL`
* `price_per_unit` was `NULL`
* `total_spent` was `NULL`

I decided to remove those records because they contained insufficient information to contribute meaningfully to the sales analysis I intended to perform.

However, I did not delete every record containing a `NULL`.
If a missing value could be reconstructed from other information, I retained the record.
This distinction helped me understand that deleting data should be a reasoned decision, rather than an automatic response to missing values.

---

## 5. The Dataset Does Not Tell Me Everything
Because this was a Kaggle dataset rather than data from a real company I work with, I had to be careful about making assumptions.

For example, the `location` field contained values such as:
```text
In-store
Takeaway
```
I can interpret these values based on their names and my general understanding of how cafes operate, but I do not actually know the business rules behind the dataset.

The same applies to `payment_method`.
I can form reasonable hypotheses, but I should not present those assumptions as facts.

### Lesson
Separate what the data explicitly tells me from what I am inferring from the data.
This is particularly important when analysing real business data, where incorrect assumptions can lead to incorrect conclusions.

---

## 9. Cleaning Should End With Validation

Another lesson from this project is that performing a transformation is not enough.
After cleaning the data, I should verify that the transformation produced the intended result.

For example, because:
```text
Total Spent = Quantity × Price Per Unit
```
I can validate the cleaned dataset by checking whether any records violate that relationship.

I can also check:
* Remaining `NULL` values
* Remaining `ERROR` or `UNKNOWN` values
* Duplicate transaction IDs
* Data types
* Invalid dates
* Impossible numerical values
* Unexpected categories

### Lesson
Cleaning is not finished when the SQL runs successfully. It is finished when the resulting data has been validated.
