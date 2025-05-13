In this step you will update the schema of the UDT.

Cassandra is not *schemaless*, but schemas in Cassandra are flexible.
In this case the *canonical* `address` type does not include the option to add an apartment number.
You will nees to add an `apt` column to store optional apratment numbers.
In Cassandra, you can use the `ALTER TYPE` command to add columns to a UDT (or table).
You can even alter types (or tables) that are already in use like the `address` type in the `employees` table.

When you add a column, all existing rows will have a `null` value in the new column.
The `null` value is simply absent and does not cause a *tombstone* in the database.

✅ Add the apartment nuber column
```
ALTER TYPE address ADD apt text;
```{{exec}}

✅ View the table
```
SELECT * FROM employees;
```{{exec}}

You should see the employee you entered (Yuri from fincance).
Yuri's `address` now has an `apt` field.
The `apt` field value is `null`

Yuri's apartment umber is *201A*,
Update the database to include Yuri's apartment number.

✅ Add Yuri's apartment number
```
UPDATE employees 
  SET home_address.apt = '201A'
  WHERE 
    department = 'finance' 
    AND 
    employee_id = 'emp001';
```{{exec}}

✅ View the table
```
SELECT * FROM employees;
```{{exec}}

You should see Yuri's apartment number in the table.