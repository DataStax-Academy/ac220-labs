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
First, you will add `Tire rotation` to Ira's `Chrysler` (VIN 2C3456) in `FEB`.

✅ Add the tire rotation
```
UPDATE customers SET service_history = service_history + {'FEB':'Tire rotation'}
  WHERE email = 'ira@example.com' AND vin = '2C3456';
```{{exec}}

✅ View the service history for Ira's `Chrysler`
```
SELECT service_history FROM customers
  WHERE email = 'ira@example.com' AND vin = '2C3456';
```{{exec}}

You should see the `Tire rotation` and the `Oil change`.

**Note:** The entries are not be ordered by *month*.
They are ordered by alphabetically by *key value*.
Cassandra knows that your keys are stored as `text` but it does not know how to interpret their meaning.  

You can also update a map by updating or inserting an element by its key.
The database shows that Noam's `Ford` had an `Oil change` in `JAN`. 
Update the database to sho that Noam's `Ford` had a 'Tune up` in `JAN`

✅ Add the tire rotation
```
UPDATE customers SET service_history['JAN'] = 'Tune up'
  WHERE email = 'noam@example.com' AND vin = '1H1234';
```{{exec}}

✅ View the service history for Noam's `Ford`
```
SELECT service_history FROM customers
  WHERE email = 'noam@example.com' AND vin = '1H1234';
```{{exec}}

You should see that Noam's `Ford` has a `Tune up` in `JAN`.

Finally, you can delete an element using from a map its key. 
Delete the `Oil change` for Ira's `Chevy` in `JAN`.

✅ Delete the `JAN` service history entry for Ira's `Chevy`
```
DELETE service_history['JAN'] FROM customers
  WHERE email = 'ira@example.com' AND vin = '5Y4567';
```{{exec}}


✅ View the service history for Ira's `Chevy`
```
SELECT service_history FROM customers
  WHERE email = 'ira@example.com' AND vin = '5Y4567';
```{{exec}}