In this step, you will use `cqlsh` to create a keyspace and a table.
The table will track user interactions on a web site.
You will use a `timeuuid` to track time and ensure uniqueness.
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
USE website;
```{{exec}}

Next you will create a table.
The table will track user interaction with a website. 
Since you are tracking data by user, `user_id` is the partition key.
This table uses a `timeuud` as the clustering column.
The `timeuuid records` the event time, and ensures uniqueness of the primary key.
The `CLUSTERING ORDER` is `DESC` so most recent events can be retrieved first.

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
The first three events happen on March 18, 2025, and the second three events happen on April 21, 2025.

✅ Insert some entry data
```
-- March 18, 2025
INSERT INTO events_by_user (user_id, event_time, event_type, description)
VALUES ('mahan', 824b7a80-041e-11f0-95ed-d98d7c0ecdb9, 'login', 'Mahan logged in');

INSERT INTO events_by_user (user_id, event_time, event_type, description)
VALUES ('mahan', a6a75700-041e-11f0-8ef0-b18dcbf8d28d, 'click', 'Clicked on homepage banner');

INSERT INTO events_by_user (user_id, event_time, event_type, description)
VALUES ('mahan', ef5f1000-041e-11f0-ae2f-14e03761abc6, 'logout', 'Mahan logged out');

--- April 21, 2025
INSERT INTO events_by_user (user_id, event_time, event_type, description)
VALUES ('mahan', 42e5d300-1e8f-11f0-804b-65ec2fe5723b, 'login', 'Mahan logged in');

INSERT INTO events_by_user (user_id, event_time, event_type, description)
VALUES ('mahan', 6446bf00-1e8f-11f0-87dd-ff02348e7363, 'click', 'Clicked on account page');

INSERT INTO events_by_user (user_id, event_time, event_type, description)
VALUES ('mahan', b556b300-1e8f-11f0-a2ef-5cd9499f9b37, 'logout', 'Mahan logged out');

```{{exec}}

Take a look at the data noting the times the events occurred.

✅ Select all the data extracting `timestamp`s from the `timeuuid`s.
```
SELECT user_id, toTimeStamp(event_time), description, event_type FROM events_by_user;
```{{exec}}

Next, you are going to select Mahan's first event from March 18.
In your query, you will need to narrow the partition to `mahan`.
You will also need to limit the query to March 18.
Since the partitions are in descending order by `event_time`, you will need to specify `ASC` for the results to get the earliest event.

✅ Select Mahan's first event from March 18
```
SELECT user_id, toTimeStamp(event_time), description, event_type 
  FROM events_by_user 
  WHERE user_id = 'mahan' 
    AND event_time >= minTimeUUID('2025-03-18') 
    AND event_time < minTimeUUID('2025-03-19') 
      ORDER BY event_time ASC LIMIT 1;
```{{exec}}

You should see that Mahan logged in on March 18 at 17:29:13.

Finally, look up Mahan's last event from March 18.
Since the partition is already in descending order by `event_time` you do not need to change the order in your query.

✅ Select Mahan's last event from March 18
```
SELECT user_id, toTimeStamp(event_time), description, event_type 
  FROM events_by_user 
  WHERE user_id = 'mahan' 
    AND event_time >= minTimeUUID('2025-03-18') 
    AND event_time < minTimeUUID('2025-03-19')
      LIMIT 1;
```{{exec}}

You should see that Mahan logged out at 17:32:16.