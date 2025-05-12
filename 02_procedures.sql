# Output flight records with duplicate flight numbers
CREATE PROCEDURE proc_list_duplicate_flightnos()
BEGIN
  SELECT 
    flightno, 
    COUNT(*) AS cnt
  FROM flight
  GROUP BY flightno
  HAVING COUNT(*) > 1;
END;

# Export the number of flights for all aircraft in the last 60 days
CREATE PROCEDURE proc_audit_airplane_utilization()
BEGIN
  SELECT 
    airplane_id,
    COUNT(*) AS flights_last_60_days
  FROM flight
  WHERE departure >= CURDATE() - INTERVAL 60 DAY
  GROUP BY airplane_id;
END;

# Export the top 10 airports with the most departures in the last 30 days
CREATE PROCEDURE proc_top_busy_airports_last_30_days()
BEGIN
  SELECT 
    a.name AS airport_name,
    COUNT(*) AS flights_departed
  FROM flight f
  JOIN airport a ON f.`from` = a.airport_id
  WHERE f.departure >= CURDATE() - INTERVAL 30 DAY
  GROUP BY f.`from`, a.name
  ORDER BY flights_departed DESC
  LIMIT 10;
END;


