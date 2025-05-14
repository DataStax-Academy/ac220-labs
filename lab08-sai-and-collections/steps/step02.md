In this step you will create indexes to support service history queries.

Because the service history is stored in a map you will not be able to query it directly.
You will have to create indexes for the queries you need.

✅ Start by creating a `KEYS` index
```
CREATE INDEX service_key_idx 
  ON customers(KEYS(service_history)) using 'SAI';
```{{exec}}

Since you created a `KEYS` index, you can now use keys in your `WHERE` clauses.

✅ Find all the customers that had service done in `JAN`
```
SELECT * FROM customers 
  WHERE service_history CONTAINS KEY 'JAN';
```{{exec}}

You should see that in `JAN`, Noam's blue Ford had an oil change, and Ira's red Chevy had a tire rotation.

Using the `KEYS` index, you were able to discover when service were performed.
To run a query that returns what services were performed, you will need a `VALUES` index.
Since service names are often made up of multiple words, it may be helpful to make the `VALUES` index case-insensitive.

✅ Create a case-insensitve `VALUES` index
```
CREATE INDEX service_value_idx 
  ON customers(VALUES(service_history)) using 'SAI'
  WITH OPTIONS = {'case_sensitive': 'false'};
```{{exec}}

Now you can execute a query to find all customers who had a specific service done, regardless of the month.
In this case, you will serch for customers who have had a tune up.
Since the `VALUES` index is case-insensitive the `WHERE` clause will use `tune up`.


✅ Find customers who have had a `tune up`
```
SELECT * FROM customers 
  WHERE service_history CONTAINS 'tune up';
```{{exec}}

You should see that Ira's black Chrysler and red Chevy both had tune ups.

Sometimes, you need to search keys and values.
SAI supports `ENTRIES` indexes to match key and value in a `Where` clause.

✅ Create the `Entries` index
```
CREATE INDEX service_entry_idx 
  ON customers(ENTRIES(service_history)) using 'SAI';
```{{exec}}

✅ Find the customers who had brake service done in April
```
SELECT * FROM customers 
  WHERE service_history['APR'] = 'Brake service';
```{{exec}}

You can combine primary key fields and indexed fields in a `WHERE` clause.
You still have to follow the rules about using the entire partition key and constraining slustering columns from L-R.

✅ Find the Ira's cars that had oil changes
```
SELECT * FROM customers 
  WHERE 
    name = 'Ira' 
  AND 
    servce_history CONTAINS 'oil change';
```{{exec}}

You should see that Ira's black Chrysler had an oil change.