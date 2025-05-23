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

- Security at the airport was moving slowly today.  
- The flight attendants served drinks during the flight.  
- She booked a flight to Paris for her vacation.  
- She looked for her gate on the departure board.  
- He waited in line to check in at the airport.  
- Passengers boarded the airplane for an overnight flight.  
- The airline delayed the flight due to bad weather.  
- He packed his suitcase carefully for the trip.  
- The cabin crew prepared the plane for landing.  
- The plane taxied down the runway before takeoff.  

The pre-generated vectors (embedddings) are in a data file.
Load the file into the database using `COPY FROM`.

✅ Load the vector data
```
COPY sentences (id, sentence, vals)
  FROM '~/data/vectors.csv' WITH DELIMITER = '|';
```{{exec}}


✅ View the senteces in the database
```
SELECT sentence FROM sentences;
```{{exec}}