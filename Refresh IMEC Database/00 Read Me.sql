/*
The script files are prefixed in the order of execution, and the prefix numbers are organized in group:
0X - Steps related to getting the database up and running on the target server as 'tmpIMEC".  These steps may vary depend on the scenarios.
1X - Preparing the configuration data ready on the target database
2X - Remove old data and Data Cleansing
4X - Optional scripts for only some databases
5X - Once the database is prepared, run final database steps to attach that with desired database name and filename.
9X - Reports or queries to inspect the data.
*/