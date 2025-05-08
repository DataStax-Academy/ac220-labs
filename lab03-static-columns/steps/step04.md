In this step, you will take a look at how Cassandra stores static data.
You will use `nodetool` to flush data from the memtable to disk.
Once the data has been written to disk you will use `sstabledump` to see haw the data is stored.

Exit `cqlsh` do you can use command-line tools in a Linux shell.

✅ Exit `cqlsh`
```
exit
```{{exec}}

Use `nodetool` to cause Cassandra to flush data from the memtable and write it to SSTables.

✅ Flush the memtables
```
nodeA/bin/nodetool status
```{{exec}}

✅ Navigate to the SSTables
```
cd nodeA/data/data
```{{exec}}


