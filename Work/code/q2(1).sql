-- For each owner, report how many venues they own.
SET SEARCH_PATH TO ticketchema, public;

SELECT name, phone, num_of_venues
FROM Owner 
JOIN (
    SELECT owner, count(*) AS num_of_venues
    FROM Venue 
    GROUP BY owner
) OwnerCount
ON phone = owner;
