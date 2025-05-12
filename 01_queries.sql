#Flights with high occupancy rates
WITH booked AS
(SELECT b.flight_id,f.flightno,count(*) AS booknum,a.capacity FROM booking b 
JOIN flight f ON b.flight_id =f.flight_id
JOIN airplane a on f.airplane_id = a.airplane_id
GROUP BY b.flight_id)
SELECT flightno, sum(booknum)/sum(capacity) AS occupancy_rate FROM booked
GROUP BY flightno
ORDER BY occupancy_rate DESC

#Which route do passengers prefer for their first booking
WITH booked AS
(SELECT b.flight_id,rank() over (partition by passenger_id ORDER BY departure) as rk FROM booking b 
JOIN flight f ON b.flight_id = f.flight_id)
SELECT f.airline_id, count(*) AS cnt FROM booked bd
JOIN flight f ON f.flight_id = bd.flight_id
WHERE rk = 1
GROUP BY airline_id 
ORDER BY cnt DESC

#The busiest time of day at each airport
WITH ttl AS 
(SELECT f.`from` AS ap, HOUR(departure) AS tm FROM flight f 
  UNION ALL
  SELECT f.`to` AS ap, HOUR(arrival) AS tm FROM flight f),
rk AS 
(SELECT a.name, ttl.ap, ttl.tm, COUNT(*) AS cnt FROM ttl
  JOIN airport a ON ttl.ap = a.airport_id
  GROUP BY ttl.ap, ttl.tm, a.name),
rn AS
(SELECT name, tm as Busytime, cnt, dense_rank() over (partition by name order by cnt desc) as num from rk)
select name AS airport_name, Busytime AS Most_Busytime from rn
WHERE num = 1

#High-value travelers
WITH tmp AS
(select *,avg(price) over (partition by flight_id) as avgprice FROM booking b) 
SELECT p.passenger_id, p.emailaddress, p.telephone FROM tmp
JOIN passengerdetails p ON tmp.passenger_id = p.passenger_id
WHERE price > avgprice
GROUP BY passenger_id 
HAVING COUNT(*) > 5

#Which airports are most frequently used as transit airports
WITH flight_pairs AS (
  SELECT
    f1.flight_id AS flight_id_1,
    f2.flight_id AS flight_id_2,
    f1.`to` AS transfer_airport,
    f1.arrival AS first_arrival,
    f2.departure AS next_departure,
    TIMESTAMPDIFF(MINUTE, f1.arrival, f2.departure) AS layover_minutes
  FROM flight f1
  JOIN flight f2
    ON f1.`to` = f2.`from`                          
   AND f1.arrival < f2.departure                    
   AND TIMESTAMPDIFF(MINUTE, f1.arrival, f2.departure) BETWEEN 0 AND 360 
)
SELECT
  a.name AS airport_name,
  fp.transfer_airport,
  COUNT(*) AS transfer_count,
  ROUND(AVG(fp.layover_minutes)) AS avg_layover_minutes
FROM flight_pairs fp
JOIN airport a ON a.airport_id = fp.transfer_airport
GROUP BY fp.transfer_airport, a.name
ORDER BY transfer_count DESC