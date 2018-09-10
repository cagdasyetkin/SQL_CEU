SELECT teams.conference AS conference,
       AVG(players.weight) AS average_weight
  FROM benn.college_football_players players
  JOIN benn.college_football_teams teams
    ON teams.school_name = players.school_name
 GROUP BY teams.conference
 ORDER BY AVG(players.weight) DESC
 
 /*Write a query that selects the school name, 
 player name, position, and weight for every player 
 in Georgia, ordered by weight (heaviest to lightest). 
 Be sure to make an alias for the table, 
 and to reference all column names in relation to the alias.*/
 
 select players.school_name, players.player_name, 
 players.position, players.weight
 FROM benn.college_football_players players
 ORDER BY players.weight DESC;
 
 /*Write a query that displays player names, school names 
 and conferences for schools in the 
 "FBS (Division I-A Teams)" division.*/
 
select p.player_name, t.division, t.school_name from benn.college_football_teams t
join benn.college_football_players p
on t.school_name = p.school_name
where t.division = 'FBS (Division I-A Teams)'

/*Write a query that performs an inner join between the 
tutorial.crunchbase_acquisitions table and the tutorial.crunchbase_companies table, 
but instead of listing individual rows, count the number of non-null rows in each table.*/

select count(c.permalink), count(a.company_permalink) 
from tutorial.crunchbase_companies c
join tutorial.crunchbase_acquisitions a
on c.permalink = a.company_permalink;

select count(c.permalink), count(a.company_permalink) 
from tutorial.crunchbase_acquisitions a 
left join tutorial.crunchbase_companies c
on c.permalink = a.company_permalink;

/*Count the number of unique companies (don't double-count companies) 
and unique acquired companies by state. Do not include results for 
which there is no state data, 
and order by the number of acquired companies from highest to lowest.*/

select c.state_code, count(distinct c.permalink) companies, count(distinct a.company_permalink) acquisitions
from tutorial.crunchbase_companies c 
left join tutorial.crunchbase_acquisitions a
on c.permalink = a.company_permalink
where c.state_code is not null
group by c.state_code
order by count(distinct a.company_permalink) desc;


select c.state_code, count(distinct c.permalink) companies, count(distinct a.company_permalink) acquisitions
from  tutorial.crunchbase_acquisitions a
right join tutorial.crunchbase_companies c 
on c.permalink = a.company_permalink
where c.state_code is not null
group by c.state_code
order by count(distinct a.company_permalink) desc;

/*Write a query that shows a company's name, "status" (found in the Companies table), 
and the number of unique investors in that company. 
Order by the number of investors from most to fewest. 
Limit to only companies in the state of New York.*/

select c.name, c.status, count(distinct i.investor_permalink)
from tutorial.crunchbase_companies c
left join tutorial.crunchbase_investments i
on i.company_permalink = c.permalink and c.state_code = 'NY'
group by 1, 2
order by 3 desc;

/*Write a query that lists investors based on the number of companies in which they are invested. 
Include a row for companies with no investor, and order from most companies to least.*/

select case when i.investor_name is null then 'No Investor' else i.investor_name end investor,
count(distinct c.permalink)
from tutorial.crunchbase_companies c
left join tutorial.crunchbase_investments i
on i.company_permalink = c.permalink
group by 1
order by 2 desc



