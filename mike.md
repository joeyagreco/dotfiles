recipe




1.
Figure out the data that you want to store (ingredients, recipes, etc).
Get it down to the minimal amount of data (no replication across tables!).
Look into "Database Normalization" here if you would like.
Here's a little guide for that: https://www.geeksforgeeks.org/introduction-of-database-normalization/

2.
Map out your tables.
For each table, decide the:
- table name (ingredients, etc)
- table column names (name, millegrams, etc)
- table column types (text, integer, etc)
Each table should have a primary key (you can let SQL auto generate this). Guide: https://www.geeksforgeeks.org/postgresql-create-auto-increment-column-using-serial/
If a table needs to reference another table, you will need a column that references that other table so you do not have duplicate information.
This is done via a foreign key: https://www.geeksforgeeks.org/foreign-key-constraint-in-sql/
The TLDR is that by using a foreign key, you can REFERENCE information that should be needed instead of RECORDING the data. 
Since you use a REFERENCE (the foreign key), you no longer need to update/maintain the data in multiple locations!
Example: Say you have an ingredient name that changes.
You only need to update a single row in a single table.
If you do not use foreign keys and instead store the ingredient names in each recipe, you would need to also update each recipe (and any other table) that uses this recipe name.

For me, it helps to visualize my tables before I do anything with them. 
I use an app here: https://www.lucidchart.com/pages/ that has a free trial I've used for 5+ years without paying.
I use a thing under Shapes > Entity Relationship
This is optional, do what you are comfortable with (you could even do all of this right in Excel!)
Here's a guide: https://www.lucidchart.com/pages/er-diagrams

3.
Host your database.
This should be cheap or free. Look for a cloud-hosted SQL database.
PostgreSQL is the industry standard for SQL databases and has the most support, but any of the major types should work just fine (MySQL, MicrosoftSQL, etc)
I've used Neon before for cheap/free: https://console.neon.tech/app/projects
You can put all of your tables into a single database. 

4. 
Connect to your database.
You will eventually use Excel to connect to your database to read from it and update it. 
To get everything set up (create tables, etc) I'd recommend having a nice user interface.
I've used TablePlus for many years: https://tableplus.com/
It's free and relatively easy to use.
Grab your SQL connection string and use it to connect in TablePlus (or Excel, etc)

5.
Set up your database.
Create your database: https://neon.tech/postgresql/postgresql-administration/postgresql-create-database
This part is optional and not really needed if you don't want to. SQL has a default database called "public" that you can put all of your tables in.
Create each table: https://neon.tech/postgresql/postgresql-tutorial/postgresql-create-table
Add any data into your tables that you want to get started (ingredients, recipes, etc): https://neon.tech/postgresql/postgresql-tutorial/postgresql-insert

6.
Use it all!
Now you should be able to use your connection string in Excel to query your database.
You can also update your database from Excel and maintain it!


