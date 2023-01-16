# min_to_max_pgs_extension

Postgres PL/pgSQL extension with aggregate functions for numeric,text,json inputs

## Installation 

This package installs like any Postgres extension. 
After downloading the repo to the directory you want on the server, you need to run the following command.

```bash 
make && sudo make install
```

after running the above command you will see output similar to below: 

```bash 
/bin/mkdir -p '/usr/share/postgresql/14/extension'
/bin/mkdir -p '/usr/share/postgresql/14/extension'
/usr/bin/install -c -m 644 .//min_to_max.control '/usr/share/postgresql/14/extension/'
/usr/bin/install -c -m 644 .//min_to_max--0.0.1.sql  '/usr/share/postgresql/14/extension/'
```

You will need to have pg_config in your path, but normally that is already the case. You can check with which pg_config. 
(If you have multiple Postgres installed, make sure that pg_config points to the right one.)

Then in the database of your choice you can create extension as shown below:

```bash 
CREATE EXTENSION min_to_max;
```
## Aggregate functions - Details

```text
NUMERIC: 

This code(min_to_max--0.0.1.sql) creates two functions and an aggregate in the PostgreSQL database management system using the PL/pgSQL language.

The first function, "min_to_max_trans_numeric", takes in two inputs: "agg" and "val". "agg" is a numeric array and "val" is a numeric value. 
The function returns a numeric array. The purpose of this function is to update the minimum and maximum values in the "agg" array 
by comparing "val" to the current values in the array.

The second function, "get_min_to_max_numeric_fin", takes in one input "cagg" which is a numeric array. The function returns a text value. 
The purpose of this function is to format the "cagg" array as a string with the format "cagg[1] -> cagg[2]"

The third statement creates an aggregate called "min_to_max" that takes in a numeric value. 
The aggregate uses the "min_to_max_trans" function as its "SFUNC" (state transition function), 
which updates the minimum and maximum values of the aggregate, "STYPE" is numeric array, 
"FINALFUNC" is "get_min_to_max_numeric_fin" which returns the final result as text, and "INITCOND" is set to '{NULL,NULL}', 
which is the initial value for the aggregate.

TEXT:

The aggregate function "min_to_max(text)" finds the minimum and maximum values of a set of text data. 
The transition function "min_to_max_trans_text" takes in two arguments: "agg", an array containing the current minimum and maximum values, and "val", 
the value being processed. It first checks if the first element of the "agg" array is null or if "val" is less than the first element, 
if so it sets the first element to "val". Then it checks if the second element of the "agg" array is null or if "val" is greater than the second element, 
if so it sets the second element to "val". Finally, it returns the updated aggregate array. The final function "get_min_to_max_text_fin" 
takes in one argument "cagg", an array containing the final minimum and maximum values. It sets the first and second elements of the final aggregate 
array to the first and second elements of the input aggregate array if the first element is not null. 
Then it concatenate the first and second elements of the final aggregate array with an arrow separator and return the result.

JSON:

The first function, "min_to_max_jsonb_trans", takes in two arguments: "agg" and "val". "agg" is an array of jsonb data types and "val" is a single jsonb data type.
This function compares the "val" to the first and second elements of the "agg" array. If "val" is less than the first element of the "agg" array or the first element is null, 
the first element of the "agg" array is set to "val". If "val" is greater than the second element of the "agg" array or the second element is null, the second element of the "agg" array is set to "val". 
The updated "agg" array is then returned.

The second function, "min_to_max_jsonb_final", takes in a single argument "cagg", an array of jsonb data types. This function declares a new variable "agg" which is set to an array with two null jsonb values. 
The function then checks if the first element of the "cagg" array is not null, if it is not then the first and second elements of "agg" are set to the first and second elements of "cagg". 
Finally, the function returns a text value that is the concatenation of the first element of "agg" casted as text, a string " -> " and the second element of "agg" also casted as text.

Lastly, the aggregate function "min_to_max" is created. This aggregate function takes in jsonb data type as input and it uses the two functions created above as its SFUNC (state transition function) 
and FINALFUNC (final function). The STYPE is jsonb[] and the INITCOND is a jsonb array with two null values. This aggregate can be used to find the minimum and maximum values of a jsonb column in a table.
```

## Testing Extension

For the tests, the following table was created and data was inserted into it.

<img width="689" alt="image" src="https://user-images.githubusercontent.com/46605193/212560062-a91b9ed8-3707-4c4f-a462-244eebf62df9.png">


sql commands:
```sql
SELECT min_to_max(numeric_col) FROM my_table;
SELECT min_to_max(varchar_col) FROM my_table;
SELECT min_to_max(text_col) FROM my_table;
SELECT min_to_max(jsonb_col) FROM my_table;
```

results: 

<img width="685" alt="image" src="https://user-images.githubusercontent.com/46605193/212560089-0348ddd7-3633-420b-ac36-f71458426b84.png">



You can also test without creating a table as follows.

sql commands:
```sql
select min_to_max(val) from (values(5),(3),(6),(7),(9),(10),(7)) t(val);
select min_to_max(val) from (values(null::int),(-15::int),(5000::numeric),(42::bigint),(15699.6152)) t(val);
select min_to_max(val) from (values(null::int),(null::int)) t(val);
select min_to_max(val) from (values('Mah'::text),('Mahmut'::text)) t(val);
```

results: 

<img width="685" alt="image" src="https://user-images.githubusercontent.com/46605193/212560107-5bc08359-1790-4914-97c7-cea0a769bb1e.png">

Author

Mahmut ÇAĞLAYAN
