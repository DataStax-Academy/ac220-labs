In this step you will create some SAI indexes to support more queries in the `customers` table.

The data you entered contains customers from multiple countries. 
Execute a query to retrieve all customers from the USA. and types.

✅ Retrieve USA customers
```
SELECT * FROM customers 
  WHERE country = 'USA';
```{{exec}}

This query failed because the `WHERE` clause did not include the entire partition key.
Even though `country` is *a* primary key column, the table has a composite primary key and queries *must* include all primary key columns in their `WHERE` clauses.

**Note:** The error message suggests that you could use `ALLOW FILTERING` to perform thes query. 
**DO NOT USE** `ALLLOW FILTERING`!! 
The result would be a *full table scan* and potentially unnacceptable performance.

![USA](https://killrcoda-file-store.s3.us-east-1.amazonaws.com/AC220/Lab07/usa.jpg)

Use SAI to enable queries by `country`.
SAI supports indexing partition key columns. 
Of course, if the table has a single-column partition key, indexing is not necessary.

✅ Create an SAI index on `country`
```
CREATE INDEX country_idx 
  ON customers(country) USING 'SAI';
```{{exec}}


Try the query again.
You do not need to reference the index in your query.
If the column has an index, Cassandra will us it.

✅ Retrieve USA customers
```
SELECT * FROM customers 
  WHERE country = 'USA';
```{{exec}}

You should now see all three USA customers.

You may have noticed that there are two customers named `Ariel` in the table.
Write a query to retrieve all the `Ariel`s.

✅ Retrieve all customers named Ariel
```
SELECT * FROM customers 
  WHERE name = 'Ariel';
```{{exec}}

You should see the same error as before.

Remember the rule in Cassandra. 
If a query has a `WHERE` clause, it must first refere to the all the columns of the partition key.
Next, it may refer to the clustering columns in the order they appear.

You will need to create an index on the `name` field to perfrom this query.

✅ Create an SAI index on `name`
```
CREATE INDEX name_idx 
  ON customers(name) USING 'SAI';
```{{exec}}

✅ Retrieve all customers named Ariel
```
SELECT * FROM customers 
  WHERE name = 'Ariel';
```{{exec}}

You should now see both `Ariel`s from the table.