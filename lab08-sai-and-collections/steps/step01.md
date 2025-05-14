In this step, you will use `cqlsh` to create a keyspace, a UDT and a table that uses the frozen UDT as the partition key.

✅ Use `cqlsh` to connect to Cassandra
```
~/nodeA/bin/cqlsh 172.30.1.10
```{{exec}}

You will need to create a keyspace for this lab.

✅ Use `cqlsh` to create a keyspace
```
CREATE KEYSPACE crm WITH replication = {
  'class':'NetworkTopologyStrategy',
  'datacenter1':1
};
```{{exec}}

✅ Use the keyspace you created
```
USE crm;
```{{exec}}

Next, you will create the `name` type.
This type will encapsulate first and last names.

✅ Create the `name` type
```
CREATE TYPE name (
  first text,
  last text
);
```{{exec}}

Next, create the `customers` table.
The table will be partitioned by `company` and you will use the `name` UDT as the clustering column.
You will need to make the `name` frozen so it can be included in the primary key.

✅ Create the `customers` table`
```
CREATE TABLE customers (
  company text,
  contact frozen<name>,
  title text,
  PRIMARY KEY ((company), contact)
);
```{{exec}}

Now that you have created the table, enter some data

✅ Insert some customers
```
INSERT INTO customers (company, contact, title) 
VALUES ('AltoStrat', { first: 'Hao', last: 'L' }, 'Sales Manager');

INSERT INTO customers (company, contact, title) 
VALUES ('AltoStrat', { first: 'Dani', last: 'H' }, 'Marketing Assistant');

INSERT INTO customers (company, contact, title) 
VALUES ('CymbalGroup', { first: 'Kim', last: 'Q' }, 'CTO');
```{{exec}}

✅ View the table
```
SELECT * FROM customers;
```{{exec}}

You should see the customers you entered.
They are partitioned (grouped) by company.

