In this step, you will use `cqlsh` to create a keyspace and a table with a map.
The table will track customer orders and status.

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

Next, you will create the `service_history` table.
This table is for a car dealership to track cars and their service histories.
You will use customer name as the partition key.
Customers may have multiple cars so you will use the car's vehicle identification number (VIN) the clustering column.
The table should also include model, year amd color.
Finaly, use a map to store the service history for the car.
In the map, you will use month as the key and sevice performed as the value.

✅ Create the table
```
CREATE TABLE service_history (
  customer text,
  vin text,
  make text,
  year int,
  color text,
  PRIMARY KEY ((customer), vin)
);
```{{exec}}

