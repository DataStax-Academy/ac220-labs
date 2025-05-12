In this step, you will use `nodetool` to flush data from the memtable to disk.
Once the data has been written to disk you will use `sstabledump` to display the SSTable filein JSON format.

Exit `cqlsh` so you can use command-line tools in a Linux shell.

✅ Exit `cqlsh`
```
exit
```{{exec}}

Use `nodetool` to cause Cassandra to flush data from the memtable and write it to SSTables.

✅ Flush the memtables
```
nodeA/bin/nodetool flush
```{{exec}}


To see how static columns are stored in Cassandra, you are going to use the `sstabledump` utility.
This tool displays the contents of an SSTable file in a human-readable JSON format.

Cassandra stores SSTables files in its `data/data` directory.
The directory contains subdirectories for each keyspace in the cluster.
The keyspace directories are in the form `*_KEYSPACE_NAME-XXXX_*` where `*_XXXX_*` is a hexadecimal encoded *UUID*. 
The name of the SSTable file is `nb-1-big-Data-db`.

There is also a similarly named directory that contains data *snapshots*.
Since there is no way of knowing the UUID values in advance, when you run `sstabledump` you will use the output of a complex `find` command to find the aprpriate data file.

✅ Use `sstabledump` to view the SSTable file
```
~/nodeA/tools/bin/sstabledump \
  "$(find ~/nodeA/data/data/sales/orders-* \
  -type d -name snapshots -prune -o \
  -type f -name nb-1-big-Data.db -print)"
```{{exec}}

