In this step, you will use `cqlsh` to create a keyspace and a table with a map.
The table will track customer cars and service histories.
Once you have created the table you will insert some customers. 

✅ Use `cqlsh` to connect to Cassandra
```
~/nodeA/bin/cqlsh 172.30.1.10
```{{exec}}

You will need to create a keyspace for this lab.

✅ Use `cqlsh` to create a keyspace
```
CREATE KEYSPACE dealership WITH replication = {
  'class':'NetworkTopologyStrategy',
  'datacenter1':1
};
```{{exec}}

✅ Use the keyspace you created
```
USE dealership;
```{{exec}}

Next, you will create the `customers` table.
This table is for a car dealership to track cars and their service histories.
You will use customer email as the partition key.
Customers may have multiple cars so you will use the car's vehicle identification number (VIN) the clustering column.
The table should also include model, year amd color.
Finaly, use a map to store the service history for the car.
In the map, you will use month as the key and sevice performed as the value.

✅ Create the table
```
CREATE TABLE customers (
  email text,
  vin text,
  make text,
  year int,
  color text,
  service_history map<text,text>,
  PRIMARY KEY ((email), vin)
);
```{{exec}}

Next, you will insert some customers into the table.
For now, you will insert only customers and their cars.
You will add service histories later.

**Note:** In Cassandra, the only columns that must have values are the partition key and clustering columns.
Unlike in a relational database, you cannot declare other columns as required in Cassandra.


✅ Insert the customers
```
-- Customer 1 with one car
INSERT INTO customers (email, vin, make, year, color)
VALUES ('noam@example.com', '1H1234', 'Ford', 2020, 'Blue');

-- Customer 2 with two cars
INSERT INTO customers (email, vin, make, year, color)
VALUES ('ira@example.com', '2C3456', 'Chrysler', 2018, 'Black');

INSERT INTO customers (email, vin, make, year, color)
VALUES ('ira@example.com', '5Y4567', 'Chevy', 2021, 'Red');
```{{exec}}

✅ View the `customers` table
```
SELECT * FROM customers;
```{{exec}}

Notice that the `service_history` column is `null`. 
The `null` in the `service_history` column *does not* represent a tombstone.
If the `INSERT` statement had expicitly set the column to `null`, there would have been a tombstone.