/*Write a query that separates the `location` field into separate fields 
for latitude and longitude. It must show the same numbers like lon and lat columns.
location field looks like this: (37.709725805163, -122.413623946206)
So we will need to cut it into 2 and then trim the paranthesis
*/

SELECT lon, lat, location, 

TRIM(leading '(' FROM LEFT(location, STRPOS(location, ',')-1)) AS my_lat,
TRIM(trailing ')' FROM RIGHT(location, STRPOS(location, ' ')-1)) AS my_lon

FROM tutorial.sf_crime_incidents_2014_01

/*concat them back*/

SELECT lon, lat, location, 
CONCAT('(', lon, ' ,', lat, ')')
FROM tutorial.sf_crime_incidents_2014_01

/*We want to convert the date format into YYYY-MM-DD please...*/

SELECT date, SUBSTR(date, 7, 4) || '-' || LEFT(date, 2) || '-' || SUBSTR(date, 4, 2) AS format_date 
FROM tutorial.sf_crime_incidents_2014_01
