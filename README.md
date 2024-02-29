This are SQL queries with the purpose of cleaning a dirty housing data 
The data, excel format was imported to Sql server manager where the cleaning was done
Functions such as CONVERT() were used to convert the date type
SUBSTRING() was used to break down strings into different parts
PARSE_NAME() was also used to break the string into different parts
    --Except it requires periods as delimiters
    --Uses REPLACE() function to replace any other delimeter(commas in my case) to periods
ISNULL() function to replace NULL values to specified replacement values
ROW_NUMBER() to assign a unique sequential integer to each rowin result set based on specified ordering
CASE statement to change the values of columns based on the condition
ALTER keyword to modify the table by either addding or dropping a column
UPDATE keyword to modify the values of existing columns in the table
