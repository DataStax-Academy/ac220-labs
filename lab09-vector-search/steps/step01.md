In this step, you will create table to hold sentences and their vector embeddings.
Next, you will load the embeddings from a file and finally you will do some similarity searches with the embeddings.

**Note:** The embeddings in this lab were generated using Google's *Universal Sentence Encoder*. 
The embeddings have 512 dimensions and are to large examine in this lab.
Therefore both the embeddings that you will index in the database and the ones you will use to query for matches have been pre-generated and stored in files.

If you would like to explore embeddings in detail, check out this 
[colab](https://colab.research.google.com/github/tensorflow/docs/blob/master/site/en/hub/tutorials/semantic_similarity_with_tf_hub_universal_encoder.ipynb#scrollTo=zwty8Z6mAkdV)
from Google.

Start by connecting to the database using `cqlsh`.

✅ Use `cqlsh` to connect to the database
```
nodeA/bin/cqlsh 172.30.1.10
```{{exec}}

Create a keyspace in the cluster.

✅ Create the `vectors` keyspace
```
CREATE KEYSPACE vectors WITH replication = {
  'class':'NetworkTopologyStrategy',
  'datacenter1':1
};
```{{exec}}

✅ Use the `vectors` keyspace
```
USE vectors;
```{{exec}}

The data you will use in this lab consists of 10 English sentences and their 512d vector encodings from the Universal Sentence Encoder. 
The vectors are floating point values.

✅ Create the table
```
CREATE TABLE sentences (
    id int PRIMARY KEY,
    sentence text,
    vals VECTOR<float,512>
);
```{{exec}}

Create an index on the vector column for ANN using SAI. 


✅ Create the index
```
CREATE INDEX sentences_idx 
  ON sentences(vals) USING 'sai';
```{{exec}}

These are the sentences from which the embeddings were generated:

Security at the airport was moving slowly today.  
The flight attendants served drinks during the flight.  
She booked a flight to Paris for her vacation.  
She looked for her gate on the departure board.  
He waited in line to check in at the airport.  
Passengers boarded the airplane for an overnight flight.  
The airline delayed the flight due to bad weather.  
He packed his suitcase carefully for the trip.  
The cabin crew prepared the plane for landing.  
The plane taxied down the runway before takeoff.  

The pre-generated vectors (embedddings) are in a data file.
Load the file into the database using `COPY FROM`.

✅ Load the vector data
```
COPY sentences (id, sentence, vals)
  FROM '~/data/vectors.csv' WITH DELIMITER = '|';
```{{exec}}

Take a look at the sentences in the database.
The embeddings are too large so the `SELECT` statement only retrives the sentences.
There are 40 sentences, 10 each about food, bicycling, music, and geography.
Since the table has a single column primary key, the results of your query will not be grouped.

✅ View the senteces in the database
```
SELECT sentence FROM sentences;
```{{exec}}

✅ Exit `cqlsh`
```
exit
```{{exec}}

The format of the `SELECT` statements to do the ANN search is:

`SELECT sentence FROM vectors.sentences ORDER BY vals ANN OF` **EMBEDDING** `limit 5`

The queries, including the embedding to match, are in `data/match-food.cql` and `data/match-music.cql`.
Run the two queries below and see the ANN results.

✅ Find matches for "The stew was rich and comforting."
```
nodeA/bin/cqlsh 172.30.1.10 -f data/match-food.cql
```{{exec}}

![matches](https://killrcoda-file-store.s3.us-east-1.amazonaws.com/AC201/Lab16/the-stew.png)

All of the matches are food related and the first three relate to the *state* of the food or the author's perception of it. 
They look like pretty good matches from out limited set of embeddings.

✅ Find matches for "The guitar sounds a little flat." 
```
nodeA/bin/cqlsh 172.30.1.10 -f data/match-music.cql
```{{exec}}

![matches](https://killrcoda-file-store.s3.us-east-1.amazonaws.com/AC201/Lab16/the-guitar.png)

The first match is pretty strong and shares the word *guitar*.
The second is also music-related, but the sentence abou cycling doesn't seem to fit.
The last two are about music so they aren't bad.
Remember, you have a universe of only 40 embeddings so matches may be a bit tenuous.