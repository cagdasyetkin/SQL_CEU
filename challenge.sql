/*Pivot the Occupation column in OCCUPATIONS so that each Name is sorted alphabetically 
and displayed underneath its corresponding Occupation. 
The output column headers should be Doctor, Professor, Singer, and Actor, respectively.

Note: Print NULL when there are no more names corresponding to an occupation.

The OCCUPATIONS table is described as follows: Columns > Name, Occupation
Occupation will only contain one of the following values: Doctor, Professor, Singer or Actor.

Sample Output:

Jenny    Ashley     Meera  Jane
Samantha Christeen  Priya  Julia
NULL     Ketty      NULL   Maria

Explanation

The first column is an alphabetically ordered list of Doctor names. 
The second column is an alphabetically ordered list of Professor names. 
The third column is an alphabetically ordered list of Singer names. 
The fourth column is an alphabetically ordered list of Actor names. 
The empty cell data for columns with less than the maximum number of 
names per occupation (in this case, the Professor and Actor columns) are filled with NULL values.

hajra!
*/

/*this is a tricky one. start with exploring what the hack is this*/

SELECT * 
FROM OCCUPATIONS
ORDER BY NAME;

/*this outputs all my names and occupations:

Output:
Aamina Doctor 
Ashley Professor 
Belvet Professor 
Britney Professor 
Christeen Singer 
Eve Actor 
Jane Singer 
Jennifer Actor 
Jenny Singer 
Julia Doctor 
Ketty Actor 
Kristeen Singer 
Maria Professor 
Meera Professor 
Naomi Professor 
Priya Doctor 
Priyanka Professor 
Samantha Actor */

/*Now case_when kicks in. I will count them as well:*/

set @r1=0, @r2=0, @r3=0, @r4=0;
  select case when Occupation='Doctor' then (@r1:=@r1+1)
            when Occupation='Professor' then (@r2:=@r2+1)
            when Occupation='Singer' then (@r3:=@r3+1)
            when Occupation='Actor' then (@r4:=@r4+1) end as RowNumber,
    case when Occupation='Doctor' then Name end as Doctor,
    case when Occupation='Professor' then Name end as Professor,
    case when Occupation='Singer' then Name end as Singer,
    case when Occupation='Actor' then Name end as Actor
  from OCCUPATIONS
  order by Name;

/*
Output:
RowNumber: Dr_Name: Prof_Name: Singer_Name: Actor_Name:
1 Aamina NULL NULL NULL 
1 NULL Ashley NULL NULL 
2 NULL Belvet NULL NULL 
3 NULL Britney NULL NULL 
1 NULL NULL Christeen NULL 
1 NULL NULL NULL Eve 
2 NULL NULL Jane NULL 
2 NULL NULL NULL Jennifer 
3 NULL NULL Jenny NULL 
2 Julia NULL NULL NULL 
3 NULL NULL NULL Ketty 
4 NULL NULL Kristeen NULL 
4 NULL Maria NULL NULL 
5 NULL Meera NULL NULL 
6 NULL Naomi NULL NULL 
3 Priya NULL NULL NULL 
7 NULL Priyanka NULL NULL 
4 NULL NULL NULL Samantha */

/*Finally the code aggregates the rows together using the group by RowNumber 
and the min statement. As stated below 'min()/max() will return a name for specific 
index and specific occupation. If there is a name, it will return it, if not, return NULL'.*/

set @r1=0, @r2=0, @r3=0, @r4=0;
select min(Doctor), min(Professor), min(Singer), min(Actor)
from(
  select case when Occupation='Doctor' then (@r1:=@r1+1)
            when Occupation='Professor' then (@r2:=@r2+1)
            when Occupation='Singer' then (@r3:=@r3+1)
            when Occupation='Actor' then (@r4:=@r4+1) end as RowNumber,
    case when Occupation='Doctor' then Name end as Doctor,
    case when Occupation='Professor' then Name end as Professor,
    case when Occupation='Singer' then Name end as Singer,
    case when Occupation='Actor' then Name end as Actor
  from OCCUPATIONS
  order by Name
) Temp
group by RowNumber;

/*Output:
Aamina Ashley Christeen Eve 
Julia Belvet Jane Jennifer 
Priya Britney Jenny Ketty 
NULL Maria Kristeen Samantha 
NULL Meera NULL NULL 
NULL Naomi NULL NULL 
NULL Priyanka NULL NULL */


/*Query the sum of Northern Latitudes (LAT_N) 
from STATION having values greater than 38.7880  and less than 137.2345. 
Truncate your answer to  decimal places..*/

SELECT ROUND(SUM(mytable.LAT_N),4)
FROM (SELECT * FROM STATION
      WHERE LAT_N > 38.7880 AND LAT_N < 137.2345) mytable

/*Query the greatest value of the Northern Latitudes (LAT_N) from STATION 
that is less than 137.2345. Truncate your answer to 4 decimal places.*/

SELECT ROUND(MAX(mytable.LAT_N),4)
FROM (SELECT * FROM STATION
      WHERE LAT_N < 137.2345) mytable


/*Query the Western Longitude (LONG_W) for the largest Northern Latitude 
(LAT_N) in STATION that is less than 137.2345. Round your answer to 4 decimal places.*/

SELECT ROUND(LONG_W,4) FROM STATION
WHERE LAT_N = (SELECT MAX(mytable.LAT_N)
FROM (SELECT * FROM STATION
      WHERE LAT_N < 137.2345) mytable)

/*Query the smallest Northern Latitude (LAT_N) from STATION that is greater than 38.7780. 
Round your answer to 4 decimal places.*/

SELECT ROUND(MIN(mytable.LAT_N),4)
FROM (SELECT * FROM STATION
      WHERE LAT_N > 38.7780) mytable

/*Query the Western Longitude (LONG_W)where the smallest 
Northern Latitude (LAT_N) in STATION is greater than 38.7780. Round your answer to 4 decimal places.*/

SELECT ROUND(LONG_W,4) FROM STATION
WHERE LAT_N = (SELECT MIN(mytable.LAT_N)
FROM (SELECT * FROM STATION
      WHERE LAT_N > 38.7780) mytable)

/*Consider P1(A,B)  and P2(C,D) to be two points on a 2D plane.

 A happens to equal the minimum value in Northern Latitude (LAT_N in STATION).
 B happens to equal the minimum value in Western Longitude (LONG_W in STATION).
 C happens to equal the maximum value in Northern Latitude (LAT_N in STATION).
 D happens to equal the maximum value in Western Longitude (LONG_W in STATION).

 Query the Manhattan Distance between points P1 and P2 and round it to a scale of 4 decimal places.

THIS MEANS:

 P1(A,B) P2(C,D) > MANHATTAN > ABS(A-C) + ABS(B-D)
A - SELECT MIN(LAT_N) FROM STATION
B - SELECT MIN(LONG_W) FROM STATION
C - SELECT MAX(LAT_N) FROM STATION
D - SELECT MAX(LONG_W) FROM STATION  */

SELECT ROUND(ABS((SELECT MIN(LAT_N) FROM STATION) - (SELECT MAX(LAT_N) FROM STATION)) + ABS((SELECT MIN(LONG_W) FROM STATION) - (SELECT MAX(LONG_W) FROM STATION)),4)

/* it is also possible to produce another version with Euclidean distance*/

Select round(sqrt(power((min(lat_n)-max(lat_n)),2) + power((min(long_w)-max(long_w)),2)),4) From station;

/*A median is defined as a number separating the higher half of a data set from the lower half. 
Query the median of the Northern Latitudes (LAT_N) from STATION and round your answer to 4 decimal places.*/

SELECT ROUND(x.LAT_N,4) from STATION x, STATION y
GROUP BY x.LAT_N
HAVING SUM(SIGN(1-SIGN(y.LAT_N-x.LAT_N)))/COUNT(*) > .5
LIMIT 1;

/*
The total score of a hacker is the sum of their maximum scores 
for all of the challenges. 

Write a query to print the hacker_id, name, and total score 
of the hackers 

ordered by the descending score. 

If more than one hacker achieved the same total score, then sort the result by ascending hacker_id. 
Exclude all hackers with a total score of 0 from your result. */

SELECT best_scores.hacker_id, best_scores.name, SUM(best_scores.score) total_score
FROM (SELECT S.hacker_id hacker_id, H.name name, S.challenge_id challenge_id, MAX(S.score) score
      FROM Submissions S
      LEFT JOIN Hackers H
      ON H.hacker_id = S.hacker_id
      GROUP BY 1,2,3) best_scores
GROUP BY 1,2
HAVING total_score > 0
ORDER BY total_score DESC, hacker_id
