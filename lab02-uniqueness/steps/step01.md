In this step, you will use `cqlsh` to create a keyspace and a table.
The table will track user interactions on a web site.
You will use a TimeUUID to track time and ensure uniqueness.
Then, you will populate the table and perform some time related queris.

✅ Use `cqlsh` to connect to Cassandra
```
~/nodeA/bin/cqlsh 172.30.1.10
```{{exec}}

You will need to create a keyspace for this lab.

✅ Use `cqlsh` to create a keyspace
```
CREATE KEYSPACE website WITH replication = {
  'class':'NetworkTopologyStrategy',
  'datacenter1':1
};
```{{exec}}

✅ Use the keyspace you created
```
use website;
```{{exec}}

Next you will create a table.
The table will track user interaction with a website. 
Since you are tracking data by user, `user_id` is the partition key.
This table uses a 'timeuud' as the clustering column.
The 'timeuuid' records the event time, and ensures uniqueness of the primary key.
The 'CLUSTERING ORDER' is 'DESC' so most recent events can be retrieved first.

✅ Create the table
```
CREATE TABLE events_by_user (
  user_id text,
  event_time timeuuid,
  event_type text,
  description text,
  PRIMARY KEY ((user_id), event_time)
) WITH CLUSTERING ORDER BY (event_time DESC);
```{{exec}}

Production applications should use the `now()` function for `timeuuid` generation. 
For this example, you will use some pre-generated `timeuuid`s.
The first three events happen on March 3, 2025, and the second three events happen on April 4, 2025.

✅ Insert some entry data
```
--- March 3, 2025
INSERT INTO events_by_user (user_id, event_time, event_type, description)
VALUES ('mahan', ef620000-038b-11f0-8080-808080808080, 'login', 'Mahan logged in');

INSERT INTO events_by_user (user_id, event_time, event_type, description)
VALUES ('mahan', 13254600-038c-11f0-8080-808080808080, 'click', 'Clicked on homepage banner');

INSERT INTO events_by_user (user_id, event_time, event_type, description)
VALUES ('mahan', 36e88c00-038c-11f0-8080-808080808080, 'logout', 'Mahan logged out');

--- April 4, 2025
INSERT INTO events_by_user (user_id, event_time, event_type, description)
VALUES ('mahan', 6b944000-0f55-11f0-8080-808080808080, 'login', 'Mahan logged in again');

INSERT INTO events_by_user (user_id, event_time, event_type, description)
VALUES ('mahan', 8f578600-0f55-11f0-8080-808080808080, 'click', 'Clicked on account page');

INSERT INTO events_by_user (user_id, event_time, event_type, description)
VALUES ('mahan', b31acc00-0f55-11f0-8080-808080808080, 'logout', 'Mahan logged out again');

```{{exec}}

✅ Select all data
```
SELECT * FROM events_by_user;
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
