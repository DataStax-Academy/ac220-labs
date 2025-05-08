In this step you will delete the `orders` table and create a new one.
The new table will have the same columns but the `status` column will be `static`.

✅ Delete the table
```
DELETE TABLE orders;
```{{exec}}

The new vesion of the table will be the same as the old version except the `status` column will be `static`.

✅ Create the table
```
CREATE TABLE orders (
  customer text,
  order_id int,
  amount int,
  status text static,
  PRIMARY KEY ((customer), order_id)
);
```{{exec}}

✅ Insert the same data
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
SELECT * from orders;
```{{exec}}