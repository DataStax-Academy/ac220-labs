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

BEGIN BATCH
  UPDATE reviews_by_user 
    SET review = 'I love the churros.'
    WHERE user_id = 2 AND review_id = 102;

  UPDATE reviews_by_restaurant
    SET review = 'I love the churros.'
    WHERE restaurant_id = 500 AND review_id = 103;
APPLY BATCH;

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