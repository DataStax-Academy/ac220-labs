In this step, you will execute an Vector Search using ANN.
Then you will calculate similarity values for all of the sentences in the database.

Here are the sentences you loaded in the database.

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

The first thing you will do is execute a Vector Search using ANN.

You will look for a match for this sentence:  

"Travelers lined up at the gate as the final boarding call was announced."

The query you are going to run looks like this:

```
SELECT sentence FROM vectors.sentences  
  ORDER BY vals ANN OF [0.004221492912620306,  
  -0.010184873826801777, -0.05917729064822197,  
  -0.03681538999080658, -0.015110083855688572,  
  ...] LIMIT 5;

```

Since you are running the query from a file, you will have to get out of `cqlsh` and run it from the command line.

✅ Exit `cqlsh`
```
exit
```{{exec}}

✅ Run the ANN query
```
nodeA/bin/cqlsh 172.30.1.10 -f \
  data/match-lined-up.cql
```{{exec}}

You should see the 5 closest matches for:

"Travelers lined up at the gate as the final boarding call was announced."

The closest match also talks about a *gate* and the second closest talks about being *in line*.

Next, you are going to get a list of the similarity metrics for the same sentence with the 10 sentences in the database.

This is what the query looks like:

```
SELECT 
  sentence, similarity_cosine(  
     vals,[0.004221492912620306, -0.010184873826801777,  
    -0.05917729064822197, -0.03681538999080658, ...])  
  AS similarity FROM sentences  
  ORDER BY vals ANN OF [0.004221492912620306,  
    -0.010184873826801777, -0.05917729064822197,  
    -0.03681538999080658, ...]  
  LIMIT 10; 
```

✅ Check the similarity values
```
nodeA/bin/cqlsh 172.30.1.10 -f \
  data/similarity-lined-up.cql
```{{exec}}