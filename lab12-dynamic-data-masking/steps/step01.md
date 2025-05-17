In this step, you will use `cqlsh` to create a keyspace and a table.
The table will track entries to a hours and grades for students.
You will us aggregates and artihmetic operators to return total hours and grade point average.
Finally, you will use Dynamic Data Masking (DDM) to redact a portion of the student names.

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

✅ Insert some student data
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
The formula for grade point average (GPA) is

![GPA](https://killrcoda-file-store.s3.us-east-1.amazonaws.com/AC220/Lab10/gpa.jpg)

You will use the `SUM` aggregate and the division operator to calculate GPA.
If you want to see this info for all students, you can us the CQL `GROUP BY`.
This will calculate hours and gpa for each student in the database.

You will also use `mask_inner()` to mask all but the first three characters;

**Note:** The data is not masked in the database. It is only masked in thr query.

✅ Get hours and gpa for all students.
```
SELECT 
  mask_inner(name, 3, 0) AS student, 
  SUM(hours) AS hours,
  SUM(hours * grade)/SUM(hours) AS gpa
FROM credits
GROUP BY name;
```{{exec}}

You will see a warning: 

![warning](https://killrcoda-file-store.s3.us-east-1.amazonaws.com/AC220/Lab10/warning.jpg)

Since you are looking for data from each student (each partition) you can safely ignore this warning.

You should see hours and gpa for Rosario S. and Lucian B.