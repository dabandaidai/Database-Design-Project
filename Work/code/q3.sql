-- For each venue, report the percentage of seats that are accessible.
SET SEARCH_PATH TO ticketchema, public;

DROP VIEW IF EXISTS count_accessible_for_each_venue CASCADE;
DROP VIEW IF EXISTS count_total_seat_for_each_venue CASCADE;

-- Counts the total number of accessible seats for each venue.
CREATE VIEW count_accessible_for_each_venue AS
    SELECT Venue.venue_id, coalesce(num_of_accessible, 0) AS num_of_accessible
    FROM Venue
    LEFT JOIN (
        SELECT venue_id, count(*) AS num_of_accessible
        FROM Seat 
        WHERE accessible = TRUE
        GROUP BY venue_id
    ) count_accessible_per_venue 
    ON Venue.venue_id = count_accessible_per_venue.venue_id
;

-- Counts the total number of seats for each venue.
CREATE VIEW count_total_seat_for_each_venue AS
    SELECT venue_id, count(*) AS num_of_seats
    FROM Seat 
    GROUP BY venue_id
;


SELECT ca.venue_id, name, 
    num_of_accessible * 100.0 / num_of_seats AS percentage
FROM count_accessible_for_each_venue ca
JOIN count_total_seat_for_each_venue ct ON ca.venue_id = ct.venue_id
RIGHT JOIN Venue ON ca.venue_id = Venue.venue_id
;