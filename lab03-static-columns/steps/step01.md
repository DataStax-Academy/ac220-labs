In this step, you will use `cqlsh` to create a keyspace and a table.
The table will track customer orders and status.

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

Next, you will create a table.
The table will track customers, order numbers, order amounts and cutomer status.
Every customer has a status value, either *GOLD*, or *BASIC*,

**Note:** The `amount` column represents the value of the order in cents as an 'int'. 
Use `int` for currency to prevent potential errors in decimal math and provide consistency with client systems.


✅ Create the table
```
CREATE TABLE orders (
  customer text,
  order_id int,
  amount int,
  status text,
  PRIMARY KEY ((customer), order_id)
);
```{{exec}}

Insert some data for two customers.

✅ Insert some entry data
```
-- LumaCore
INSERT INTO orders (customer, order_id, amount, status)
  VALUES ('LumaCore', 1410, 1021200, 'BASIC');

INSERT INTO orders (customer, order_id, amount, status)
  VALUES ('LumaCore', 1411, 987100, 'BASIC');

INSERT INTO orders (customer, order_id, amount, status)
  VALUES ('LumaCore', 1412, 509200, 'BASIC');

--- Nexora
INSERT INTO orders (customer, order_id, amount, status)
  VALUES ('Nexora', 2100, 12023100, 'GOLD');

INSERT INTO orders (customer, order_id, amount, status)
  VALUES ('Nexora', 2101, 9023300, 'GOLD');

INSERT INTO orders (customer, order_id, amount, status)
  VALUES ('Nexora', 2102, 1000000, 'GOLD');

```{{exec}}

Verify that the data has loaded.

✅ Select all the data
```
SELECT * from Orders;
```{{exec}}

