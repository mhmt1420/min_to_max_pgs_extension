# min_to_max_pgs_extension
Postgres PL/pgSQL extension with aggregate functions for numeric,text,json inputs

Installing

This package installs like any Postgres extension. 
After downloading the repo to the directory you want on the server, you need to run the following command.

make && sudo make install

after running the above command you will see output similar to below:

/bin/mkdir -p '/usr/share/postgresql/14/extension'
/bin/mkdir -p '/usr/share/postgresql/14/extension'
/usr/bin/install -c -m 644 .//min_to_max.control '/usr/share/postgresql/14/extension/'
/usr/bin/install -c -m 644 .//min_to_max--0.0.1.sql  '/usr/share/postgresql/14/extension/'

You will need to have pg_config in your path, but normally that is already the case. You can check with which pg_config. 
(If you have multiple Postgres installed, make sure that pg_config points to the right one.)

Then in the database of your choice you can create extension as shown below:

CREATE EXTENSION min_to_max;

Aggregate functions - Details

This code(min_to_max--0.0.1.sql) creates two functions and an aggregate in the PostgreSQL database management system using the PL/pgSQL language.

The first function, "min_to_max_trans", takes in two inputs: "agg" and "val". "agg" is a numeric array and "val" is a numeric value. 
The function returns a numeric array. The purpose of this function is to update the minimum and maximum values in the "agg" array by comparing "val" to the current values in the array.

The second function, "uagg_m2m_fin", takes in one input "cagg" which is a numeric array. The function returns a text value. The purpose of this function is to format the "cagg" array as a string with the format "cagg[1] -> cagg[2]"

The third statement creates an aggregate called "min_to_max" that takes in a numeric value. The aggregate uses the "min_to_max_trans" function as its "SFUNC" (state transition function), 
which updates the minimum and maximum values of the aggregate, "STYPE" is numeric array, "FINALFUNC" is "uagg_m2m_fin" which returns the final result as text, and "INITCOND" is set to '{NULL,NULL}', which is the initial value for the aggregate.

You can apply the above logic to other data types(json,text etc.) as well.

Testing Extension

For the tests, the following table was created and data was inserted into it.


<img width="689" alt="image" src="https://user-images.githubusercontent.com/46605193/212556766-bc205c0d-b546-4e64-9bc2-f850cfaecffd.png">





sql commands:

SELECT min_to_max(numeric_col) FROM my_table;
SELECT min_to_max(varchar_col) FROM my_table;
SELECT min_to_max(text_col) FROM my_table;
SELECT min_to_max(jsonb_col) FROM my_table;



results:

<img width="678" alt="image" src="https://user-images.githubusercontent.com/46605193/212556786-b2a48ca9-fc11-4589-99c2-9babe5bfda8a.png">





You can also test without creating a table as follows.
sql commands:
select min_to_max(val) from (values(5),(3),(6),(7),(9),(10),(7)) t(val);
select min_to_max(val) from (values(null::int),(-15::int),(5000::numeric),(42::bigint),(15699.6152)) t(val);
select min_to_max(val) from (values(null::int),(null::int)) t(val);
select min_to_max(val) from (values('Mah'::text),('Mahmut'::text)) t(val);


results:

<img width="683" alt="image" src="https://user-images.githubusercontent.com/46605193/212556805-fe50d14a-fe2d-43a1-bbd3-2ad414f4dd89.png">


Author
Mahmut ÇAĞLAYAN

