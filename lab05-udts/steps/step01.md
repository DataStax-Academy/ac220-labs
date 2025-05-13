In this step, you will use `cqlsh` to create a keyspace, a UDT and a table that uses the UDT.
The UDT will represent an address and you will use it in a table of employees.

✅ Use `cqlsh` to connect to Cassandra
```
~/nodeA/bin/cqlsh 172.30.1.10
```{{exec}}

You will need to create a keyspace for this lab.

✅ Use `cqlsh` to create a keyspace
```
CREATE KEYSPACE hr WITH replication = {
  'class':'NetworkTopologyStrategy',
  'datacenter1':1
};
```{{exec}}

✅ Use the keyspace you created
```
USE hr;
```{{exec}}

Next, you will create the `address` type.
This type will encapsulate the canonical form for a US address.

✅ Create the `addess` type
```
CREATE TYPE address (
  number text,
  street text,
  city text,
  state text,
  zip int
);
```{{exec}}

Next, create the `employees` table.
The table will be partitioned by `department` and each employee will have an `employee_id`.

✅ Create the `employees` table`
```
CREATE TABLE employees (
  department text,
  employee_id text,
  name text,
  home_address address,
  PRIMARY KEY((department), employee_id)
);
```{{exec}}

Now you have both the `address` UDT and the `employees` table.
Insert an employee record into the table

✅ Insert an employee
```
INSERT INTO employees (department, employee_id, name, home_address)
VALUES ( 'finance', 'emp001', 'Yuri',
  { 
    number: '123', 
    street: 'Main Street', 
    city: 'Springfield', 
    state: 'IL', 
    zip: 62704
  }
);
```{{exec}}

✅ View the table
```
SELECT * FROM employees;
```{{exec}}

