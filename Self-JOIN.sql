--1:
/*
How many stops are in the database.
*/

SELECT COUNT(stops.id)
FROM stops

--2:
/*
Find the id value for the stop 'Craiglockhart'
*/

SELECT stops.id
FROM stops
WHERE name = 'Craiglockhart'

--3:
/*
Give the id and the name for the stops on the '4' 'LRT' service.
*/

SELECT id, name
FROM stops JOIN route ON stops.id = route.stop
WHERE num = '4';

--4:
/*
The query shown gives the number of routes that visit either London Road (149)
or Craiglockhart (53). Run the query and notice the two services that link these
stops have a count of 2. Add a HAVING clause to restrict the output to these two routes.
*/

SELECT company, num, COUNT(*)
FROM route WHERE stop=149 OR stop=53
GROUP BY company, num
HAVING COUNT(*) = 2


--5:
/*
Execute the self join shown and observe that b.stop gives all the places you can get
to from Craiglockhart, without changing routes. Change the query so that it shows the
services from Craiglockhart to London Road.
*/

-- Get 'London Road = 149 by ... SELECT * FROM stops WHERE name = 'London Road' --
SELECT a.company, a.num, a.stop, b.stop
FROM route a JOIN route b ON
  (a.company=b.company AND a.num=b.num)
WHERE a.stop=53 AND b.stop=149

--6:
/*
The query shown is similar to the previous one, however by joining two copies
of the stops table we can refer to stops by name rather than by number.
Change the query so that the services between 'Craiglockhart' and 'London Road' are shown.
If you are tired of these places try 'Fairmilehead' against 'Tollcross'
*/

SELECT a.company, a.num, stopa.name, stopb.name
FROM route a JOIN route b ON
  (a.company=b.company AND a.num=b.num)
  JOIN stops stopa ON (a.stop=stopa.id)
  JOIN stops stopb ON (b.stop=stopb.id)
WHERE stopa.name='Craiglockhart' AND stopb.name='London Road'

--7:
/*
Give a list of all the services which connect stops 115 and 137 ('Haymarket' and 'Leith')
*/

SELECT DISTINCT a.company, a.num
FROM route a
JOIN route b ON a.company = b.company AND a.num = b.num
WHERE a.stop = 115 AND b.stop = 137;

--8:
/*
Give a list of the services which connect the stops 'Craiglockhart' and 'Tollcross'
*/

SELECT DISTINCT a.company, a.num
FROM route a
JOIN route b ON a.company = b.company AND a.num = b.num
JOIN stops stopa ON a.stop = stopa.id
JOIN stops stopb ON b.stop = stopb.id
WHERE stopa.name = 'Craiglockhart'
AND stopb.name = 'Tollcross';

--9:
/*
Give a distinct list of the stops which may be reached from 'Craiglockhart'
by taking one bus, including 'Craiglockhart' itself, offered by the LRT company.
Include the company and bus no. of the relevant services.
*/

SELECT DISTINCT stopb.name AS reachable_stop, routeb.company, routeb.num
FROM route routea
JOIN route routeb ON routea.company = routeb.company AND routea.num = routeb.num
JOIN stops stopa ON routea.stop = stopa.id
JOIN stops stopb ON routeb.stop = stopb.id
WHERE stopa.name = 'Craiglockhart'
AND routeb.company = 'LRT'

--10:
/*
Find the routes involving two buses that can go from Craiglockhart to Lochend.
Show the bus no. and company for the first bus, the name of the stop for the transfer,
and the bus no. and company for the second bus.
*/

SELECT DISTINCT 
    first_route.num AS first_bus_no, 
    first_route.company AS first_bus_company, 
    transfer_stop.name AS transfer_stop_name, 
    second_route.num AS second_bus_no, 
    second_route.company AS second_bus_company
FROM 
    route first_route
JOIN 
    route transfer_route ON first_route.company = transfer_route.company 
                          AND first_route.num = transfer_route.num
JOIN 
    stops transfer_stop ON transfer_route.stop = transfer_stop.id
JOIN 
    route second_route ON transfer_stop.id = second_route.stop
JOIN 
    route final_route ON second_route.company = final_route.company 
                       AND second_route.num = final_route.num
JOIN 
    stops start_stop ON first_route.stop = start_stop.id
JOIN 
    stops end_stop ON final_route.stop = end_stop.id
WHERE 
    start_stop.name = 'Craiglockhart'
    AND end_stop.name = 'Lochend'
    AND transfer_stop.name != 'Craiglockhart'
ORDER BY 
    first_bus_no, 
    transfer_stop_name, 
    second_bus_no;
