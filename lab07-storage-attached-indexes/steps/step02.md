In this step you will create some SAI indexes to support more queries in the `customers` table.

The data you entered contains customers from multiple countries. 
Execute a querie to retrieve all customers from the USA. and types.

✅ Retrieve USA customers
```
SELECT * FROM customers WHERE country = 'USA';
```{{exec}}


![USA](https://killrcoda-file-store.s3.us-east-1.amazonaws.com/AC220/Lab07/usa.jpg)









Many people have multiple phone numbers.
For example someone may have a cell phone and a work phone.
So you will modify the `customers` table to include a collection (`LIST`) of `phone` types.
You will have to declare the `phone` type `frozen` to nest it in a collection.

✅ Modify the `costomers` table
```
ALTER TABLE customers 
  ADD phones list<frozen<phone>>;
```{{exec}}

✅ View the table
```
SELECT * FROM customers;
```{{exec}}

For now there are no `phones` so the column is `null` for all customers.
Modifying the table *did not* create tombstones in the table.

Now, you are going to add phone numbers for the customers.
For the first customer you will us an `INSERT` to add the phone numbers. 
This may seem strange, but because the primary key is already in the table, the `INSERT` will *upsert* data and act just like an `UPDATE`.

**Note:** Normally you would add the phone numbers using an `UPDATE` command. To be certain that you are updating an existing row, you could use a *lightweight transaction (LWT)*.

✅ Use `INSERT` to add a phone number to Dani H
```
INSERT INTO customers (company, contact, phones) 
  VALUES(
    'AltoStrat',
    {first: 'Dani', last: 'H'},
    [
      {type: 'mobile', number: '555-1234'},
      {type: 'office', number: '555-5678'}
    ]
  );
```{{exec}}

✅ View the table
```
SELECT * FROM customers;
```{{exec}}

You should now see `mobile` and `office` phones for Dani H.

Now you will use `UPDATE` to add phones for Hao L.

✅ Use `UPDATE` to add a phone number
```
UPDATE customers SET phones =
  [
    {type: 'mobile', number: '555-1234'}
  ]
  WHERE
    company = 'AltoStrat'
  AND
    contact = {first: 'Hao', last: 'L'};
```{{exec}}

✅ View the table
```
SELECT * FROM customers;
```{{exec}}

You should now see phone numbers for both Hao L and Dani H.