In this step you will update the schema of the table.

In Cassandra, you can modify table schemas.
You can add columns, but you cannot remove columns.

This table is missing some important information. 
It is missing contact information.

You will need to create a UDT to represent phone numbers and types.

✅ Create the `phone` UDT
```
CREATE TYPE phone (
  type text,
  number text,
);
```{{exec}}

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
This may seem strange but because the primary key is already in the table, the `INSERT` will *upsert* data and act just like an `UPDATE`.

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

✅ Use `UPDATE` to add a phone number to Dani H
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