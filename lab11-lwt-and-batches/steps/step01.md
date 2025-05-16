In this step, you will use `cqlsh` to create a keyspace and a table.
The table will track entries orders.
Next, you will insert a single row.
Finally, you will attempt to add two rows using batches and LWT.

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
use sales;
```{{exec}}

Next you will create the `orders` table.
The table will track hours, grades and subject.

✅ Create the table
```
CREATE TABLE orders (
    cust_id int,
    order_id int,
    item text,
    count int,
    PRIMARY KEY ((cust_id), order_id)
);
```{{exec}}

✅ Insert some a row
```
INSERT INTO orders(cust_id, order_id, item, count) 
  VALUES (101, 334, 'oranges', 1);
```{{exec}}

Look at the data you entered.
You should see:

✅ Select all data
```
SELECT * FROM orders;
```{{exec}}

