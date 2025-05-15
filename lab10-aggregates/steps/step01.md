In this step, you will use `cqlsh` to create a keyspace and a table.
The table will track entries to a hours and grades for students.
You will us aggregates and artihmetic operators to return total hours and grade point average.

✅ Use `cqlsh` to connect to Cassandra
```
~/nodeA/bin/cqlsh 172.30.1.10
```{{exec}}

You will need to create a keyspace for this lab.

✅ Use `cqlsh` to create a keyspace
```
CREATE KEYSPACE grades WITH replication = {
  'class':'NetworkTopologyStrategy',
  'datacenter1':1
};
```{{exec}}

✅ Use the keyspace you created
```
use grades;
```{{exec}}

Next you will create the `credits` table.
The table will track hours, grades and subject.

✅ Create the table
```
CREATE TABLE credits (
    name text,
    subject text,
    hours int,
    grade float,
    PRIMARY KEY ((name), subject)
);
```{{exec}}

✅ Insert some entry data
```
INSERT INTO credits 
  (name, subject, hours, grade) 
VALUES 
  ('Lucian B', 'Math', 3, 4.0);

INSERT INTO credits 
  (name, subject, hours, grade) 
VALUES 
  ('Lucian B', 'History', 4, 3.0);

INSERT INTO credits 
  (name, subject, hours, grade) 
VALUES 
  ('Lucian B', 'Biology', 2, 3.5);

INSERT INTO credits 
  (name, subject, hours, grade) 
VALUES 
  ('Lucian B', 'English', 3, 3.7);

INSERT INTO credits 
  (name, subject, hours, grade) 
VALUES 
  ('Rosario S', 'Math', 3, 4.0);

INSERT INTO credits 
  (name, subject, hours, grade) 
VALUES 
  ('Rosario S', 'History', 4, 3.5);

INSERT INTO credits 
  (name, subject, hours, grade) 
VALUES 
  ('Rosario S', 'Biology', 2, 3.8);

INSERT INTO credits 
  (name, subject, hours, grade) 
VALUES 
  ('Rosario S', 'English', 3, 3.9);
```{{exec}}

Look at the data you entered.

✅ Select all data
```
SELECT * FROM credits;
```{{exec}}

Next, you will use a `WHERE` clause with a range to select all the entries on April 3, 2025.

✅ Select all entries from April 3
```
SELECT employee_name, entry_time
FROM entry
WHERE door_id = 4
  AND entry_time >= '2025-04-03 00:00:00-0500'
  AND entry_time <  '2025-04-04 00:00:00-0500';
```{{exec}}

You should see that Rosario, Lee and Tal all entered on April 3, and Lee entered twice.

✅ Select the last entry on April 2
```
SELECT employee_name, entry_time
FROM entry
WHERE door_id = 4
  AND entry_time >= '2025-04-02 00:00:00-0500'
  AND entry_time <  '2025-04-03 00:00:00-0500'  
  ORDER BY entry_time DESC LIMIT 1;
```{{exec}}

You should see that Tal was the last one to enter the facility on April 3 at 17:10:00.
