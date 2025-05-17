In this step, you will use `cqlsh` to create a keyspace and two tables.
Next, you will insert data into the tables using batches.

✅ Use `cqlsh` to connect to Cassandra
```
~/nodeA/bin/cqlsh 172.30.1.10
```{{exec}}

You will need to create a keyspace for this lab.

✅ Use `cqlsh` to create a keyspace
```
CREATE KEYSPACE dining WITH replication = {
  'class':'NetworkTopologyStrategy',
  'datacenter1':1
};
```{{exec}}

✅ Use the keyspace you created
```
use dining;
```{{exec}}

In Cassandra you will often use the *table-per-query* pattern.
In other words you will design tables to support a single query and when requirements call for another query, you will create a new table.
Sometimes, you will even create two tables with *exactly* the same data!

In lab you will create two tables.
Both tables will contain the same data.
The difference is that the tables will have different partition keys and clustering columns.
Each table is optimized for a different query, even though the data is the same.

The naming convention reflects the supported queries.
Both tables will contain restaurant reviews, but one is partitioned by user and the other by restaurant.
Data duplication (denormalization) takes more storage space, but it supports optimal queries

✅ Create the tables
```
CREATE TABLE reviews_by_user (
  user_id int,
  review_id int,
  restaurant_id int,
  restaurant_name text,
  review text,
  PRIMARY KEY ((user_id), review_id)
);

CREATE TABLE reviews_by_restaurant (
 restaurant_id int,
 review_id int,
 user_id int,
 restaurant_name text,
 review text,
 PRIMARY KEY ((restaurant_id), review_id)
);
```{{exec}}

Next, you will insert data into both tables.
Both tables have the same data optimized for different queries.
Use a `BATCH` to keep both tables in sync with the same data.

✅ Insert a row into both tables
```
BEGIN BATCH
  INSERT INTO reviews_by_user (
    user_id, review_id, restaurant_id, restaurant_name, review
  ) VALUES (
    1, 100, 500, 'Taco Town', 'Great tacos and fast service!'
  );

  INSERT INTO reviews_by_restaurant (
    restaurant_id, review_id, user_id, restaurant_name, review
  ) VALUES (
    500, 100, 1, 'Taco Town', 'Great tacos and fast service!'
  );
APPLY BATCH;
```{{exec}}

Every time you do an `INSERT`, you do it in a batch to make sure that both tables are updated at the same time.

✅ Add some more reviews
```
BEGIN BATCH
  INSERT INTO reviews_by_user (
    user_id, review_id, restaurant_id, restaurant_name, review
  ) VALUES (
    1, 101, 501, 'Red Lantern', 'My favorite buffet.'
  );

  INSERT INTO reviews_by_restaurant (
    restaurant_id, review_id, user_id, restaurant_name, review
  ) VALUES (
    501, 101, 1, 'Red Lantern', 'My favorite buffet.'
  );
APPLY BATCH;

BEGIN BATCH
  INSERT INTO reviews_by_user (
    user_id, review_id, restaurant_id, restaurant_name, review
  ) VALUES (
    2, 102, 500, 'Taco Town', 'I love the burritos.'
  );

  INSERT INTO reviews_by_restaurant (
    restaurant_id, review_id, user_id, restaurant_name, review
  ) VALUES (
    500, 102, 2, 'Taco Town', 'I love the burritos.'
  );
APPLY BATCH;
```{{exec}}


✅ Select all data from reviews_by_user
```
SELECT * FROM reviews_by_user;
```{{exec}}

✅ Select all data from reviews_by_restaurant
```
SELECT * FROM reviews_by_restaurant;
```{{exec}}

