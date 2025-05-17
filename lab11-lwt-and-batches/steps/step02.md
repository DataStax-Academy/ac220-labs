In this step, you will preform the queries for which these tables were designed.

✅ Find all the reviews by user `1`
```
SELECT restaurant_name, review 
  FROM reviews_by_user WHERE user_id = 1;
```{{exec}}

Here is the other:
✅ Find all the reviews for restaurant `500`
```
SELECT restaurant_name, review 
  FROM reviews_by_restaurant 
  WHERE restaurant_id = 500;
```{{exec}}

Let's look at all the data from both tables again.

✅ Select all data from `reviews_by_user`
```
SELECT * FROM reviews_by_user;
```{{exec}}

✅ Select all data from `reviews_by_restaurant`
```
SELECT * FROM reviews_by_restaurant;
```{{exec}}

You should see that the review from user `2` of `Taco Town` is: *I love the burritos.*
You are going to change that to *I love the churros.*
Of course, you will need to update both tables, so you will use a batch to keep them in sync,

✅ Run the query
```
BEGIN BATCH
  UPDATE reviews_by_user 
    SET review = 'I love the churros.'
    WHERE user_id = 2 AND review_id = 102;

  UPDATE reviews_by_restaurant
    SET review = 'I love the churros.'
    WHERE restaurant_id = 500 AND review_id = 103;
APPLY BATCH;
```{{exec}}

Now, find all the reviews from user `2`.

✅ Run the query
```
  SELECT * FROM reviews_by_user 
    WHERE user_id = 2;
```{{exec}}

User `2` only has one review (Taco Town) and you just updated it.

Now, find all the reviews of Taco Town (`500`)

✅ Run the query
```
  SELECT * FROM reviews_by_restaurant 
    WHERE restaurant_id = 500;
```{{exec}}

![null](https://killrcoda-file-store.s3.us-east-1.amazonaws.com/AC220/Lab11/null.jpg)

Wait a minute!
What happened?
The original review `I love the burritos.` is still there, and now there is a new review with `null` in the `restaurant_name` and `user_id` columns.

If you look back at the second `UPDATE` in the `BATCH` you see that the command used the wrong `review_id`.
It should have been `102` but the command used `103`.
So, the `UPDATE` acted as an *upsert* and created a new row.

You are going to fix this in two steps.
First you will delete the *phantom* row.
Then, you will update the existing review.

✅ Delete the *phantom* row
```
DELETE FROM reviews_by_restaurant
    WHERE restaurant_id = 500 and review_id = 103;
```{{exec}}

Now, retrive all the reviews of Taco Town (`500`)

✅ Run the query
```
SELECT * FROM reviews_by_restaurant 
  WHERE restaurant_id = 500;
```{{exec}}

The *phantom* review should be gone. 
Next, you will update the existing review. 
This time you will use an LWT to guarantee that the row exists so you do not do an *upsert*.
In this example you will use `IF EXISTS`,

✅ Run the query
```
UPDATE reviews_by_restaurant
  SET review = 'I love the churros.'
  WHERE restaurant_id = 500 AND review_id = 102
  IF EXISTS;
```{{exec}}

You should see that the `UPDATE` was successfully applied:

![applied](https://killrcoda-file-store.s3.us-east-1.amazonaws.com/AC220/Lab11/applied.jpg)

View the reviews (by restaurant) again.
This time, you should see the updated review.

✅ Run the query
```
SELECT * FROM reviews_by_restaurant 
  WHERE restaurant_id = 500;
```{{exec}}

**Note:** Cassandra does not LWTs in batches, so we could not have used an LWT in the initial update batch.

