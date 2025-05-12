In this step you will insert, update, and replace service histories for some of the cars in the database.

Start by adding service histories for all three cars.
Initially, add `Oil change` in `JAN` for all three.

✅ Add the oil changes
```
UPDATE customers SET service_history = {'JAN':'Oil change'} 
  WHERE email = 'noam@example.com' AND vin = '1H1234';

UPDATE customers SET service_history = {'JAN':'Oil change'} 
  WHERE email = 'ira@example.com' AND vin = '2C3456';
UPDATE customers SET service_history = {'JAN':'Oil change'} 
  WHERE email = 'ira@example.com' AND vin = '5Y4567';
```{{exec}}

✅ View the updated table
```
SELECT * FROM customers;
```{{exec}}

Next you are going to make some changes to the service histories. 
First, you will add `Tire rotation` to Ira's Chrysler (VIN 2C3456) in February.

✅ Add the tire rotation
```
UPDATE customers SET service_history = service_history + {'FEB':'Tire rotation'}
  WHERE email = 'ira@example.com' AND vin = '2C3456';
```{{exec}}

✅ View the service history for Ira's Chrysler
```
SELECT service_history FROM customers
  WHERE email = 'ira@example.com' AND vin = '2C3456';
```{{exec}}

You should see the `Tire rotation` and the `Oil change`.

**Note:** The entries will not beordered by *month*.
They will be ordered by alphabetically by *key value*.
Cassandra knows your keys are `text` but does not now how to interpret them.  