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

Each course has a number of hours and a grade from 0.0 to 4.0.
Grade point average (gpa) is

![GPA](https://killrcoda-file-store.s3.us-east-1.amazonaws.com/AC220/Lab10/gpa.jpg)

✅ Select all data
```
SELECT 
  name AS student, 
  SUM(hours) AS hours,
  SUM(hours * grade)/SUM(hours) AS gpa
FROM credits
GROUP BY name;
```{{exec}}