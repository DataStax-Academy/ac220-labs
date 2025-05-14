In this step, you will use `cqlsh` to create a keyspace, and a table with a composite partition key. Next, you will insert some data and execute some quries.

✅ Use `cqlsh` to connect to Cassandra
```
~/nodeA/bin/cqlsh 172.30.1.10
```{{exec}}

You will need to create a keyspace for this lab.

✅ Use `cqlsh` to create a keyspace
```
CREATE KEYSPACE sales WITH replication = {
  'class':'NetworkTopologyStrategy',
  'datacenter1':1
};
```{{exec}}

✅ Use the keyspace you created
```
USE sales;
```{{exec}}


Next, create the `customers` table.
This table will be partitioned by `country` and `city`.
Create a clustering column called `customer_id` for uniqueness.

✅ Create the `customers` table`
```
CREATE TABLE customers (
    country text,
    city text,
    customer_id int,
    name text,
    email text,
    PRIMARY KEY ((country, city), customer_id)
);
```{{exec}}

Now that you have created the table, enter some data

✅ Insert some customers
```
INSERT INTO customers (country, city, customer_id, name, email)
VALUES ('USA', 'Chicago', 48291, 'Ariel', 'ariel@altostrat.com');

INSERT INTO customers (country, city, customer_id, name, email)
VALUES ('USA', 'Chicago', 53924, 'Kalani', 'kalani@cymbalgroup.com');

INSERT INTO customers (country, city, customer_id, name, email)
VALUES ('France', 'Paris', 17583, 'Nur', 'nur@altostrat.com');

INSERT INTO customers (country, city, customer_id, name, email)
VALUES ('USA', 'Detroit', 62714, 'Tristan', 'tristan@cymbalgroup.com');

INSERT INTO customers (country, city, customer_id, name, email)
VALUES ('Nigeria', 'Lagos', 90352, 'Bola', 'bola@altostrat.com');

```{{exec}}

✅ View the table
```
SELECT * FROM customers;
```{{exec}}

You should see the customers you entered.

Exequte a query to retrieve all customes in Chicago, USA. 
Since `country` and `city` make up the composite partition key, this query will retrive an entire partition.

✅ View the table
```
SELECT * FROM customers
  WHERE country = 'USA' AND city = 'Chicago';
```{{exec}}

You should see both customers from Chicago.
