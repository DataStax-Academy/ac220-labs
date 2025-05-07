In this step, you will use `cqlsh` to create a keyspace and a table.
The table will track entries to a facilty by door, time and employye.
Then, you will populate the table and perform some time related queris.

✅ Use `cqlsh` to connect to Cassandra
```
~/nodeA/bin/cqlsh 172.30.1.10
```{{exec}}

You will need to create a keyspace for this lab.

✅ Use `cqlsh` to create a keyspace
```
CREATE KEYSPACE access WITH replication = {
  'class':'NetworkTopologyStrategy',
  'datacenter1':1
};
```{{exec}}

✅ Use the keyspace you created
```
use access;
```{{exec}}

Next you will create a table.
The table will contain country names and the continents there they are located.

✅ Create the table
```
CREATE TABLE entry (
  door_id int,
  entry_time timestamp,
  employee_name text,
  PRIMARY KEY ((door_id), entry_time, employee_name)
);
```{{exec}}

✅ Insert data
```
INSERT INTO entry (door_id, entry_time, employee_name) VALUES (4, '2025-04-01T08:12:00', 'Rosario');
INSERT INTO entry (door_id, entry_time, employee_name) VALUES (4, '2025-04-01T17:44:00', 'Rosario');
INSERT INTO entry (door_id, entry_time, employee_name) VALUES (4, '2025-04-02T08:19:00', 'Rosario');
INSERT INTO entry (door_id, entry_time, employee_name) VALUES (4, '2025-04-03T07:55:00', 'Rosario');
INSERT INTO entry (door_id, entry_time, employee_name) VALUES (4, '2025-04-01T09:05:00', 'Tal');
INSERT INTO entry (door_id, entry_time, employee_name) VALUES (4, '2025-04-02T12:30:00', 'Tal');
INSERT INTO entry (door_id, entry_time, employee_name) VALUES (4, '2025-04-02T17:10:00', 'Tal');
INSERT INTO entry (door_id, entry_time, employee_name) VALUES (4, '2025-04-03T09:22:00', 'Tal');
INSERT INTO entry (door_id, entry_time, employee_name) VALUES (4, '2025-04-01T07:50:00', 'Lee');
INSERT INTO entry (door_id, entry_time, employee_name) VALUES (4, '2025-04-01T16:00:00', 'Lee');
INSERT INTO entry (door_id, entry_time, employee_name) VALUES (4, '2025-04-03T08:45:00', 'Lee');
INSERT INTO entry (door_id, entry_time, employee_name) VALUES (4, '2025-04-03T17:35:00', 'Lee');
```{{exec}}

✅ Select all data
```
SELECT * FROM entry;
```{{exec}}

Next, you will use a `WHERE` clause to select all the countries in Europe.

✅ Select all countries
```
SELECT employee_name, entry_time
FROM entry
WHERE door_id = 4
  AND entry_time >= '2025-04-03 00:00:00'
  AND entry_time <  '2025-04-04 00:00:00';
```{{exec}}

✅ Select all countries
```
SELECT employee_name, entry_time
FROM entry
WHERE door_id = 4
  AND entry_time <  '2025-04-04 00:00:00' 
  ORDER BY entry_time descending LIMIT 1;
```{{exec}}

You should see that this query fails!
The data is in the table but you can't use `continent` in a `WHERE` clause.
You will learn more about this in a later module.