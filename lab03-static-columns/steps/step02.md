In this step you will update the status for LumaCore.
You will also use `SSTableDump` to see what happens when you make updates.

Imagine a data entry error, all of the status entries for LumaCore are incorrect.
LumaCore is a `GOLD` status customer but status for each order was entered as `BASIC`.
Change the `status` for LumaCore to `GOLD`.

✅ Change the status
```
UPDATE orders SET status = 'GOLD' WHERE customer = 'LumaCore';
```{{exec}}

The update failed!

![uodate failed](https://killrcoda-file-store.s3.us-east-1.amazonaws.com/AC220/Lab03/failed-update.jpg)

According to the error message the `UPDATE` did not includ the clustering column, `order_id`. 
The update had to fully specify the primary key: all the *partition key* and *clustering key* columns.

Try the update again with the clustering column.

✅ Change the status
```
UPDATE orders SET status = 'GOLD' WHERE customer = 'LumaCore' AND order_id = 2100;
```{{exec}}

Look at the results. 

✅ View the data
```
SELECT * FROM orders;
```{{exec}}



The status is now `GOLD` but only for order `2100`.

