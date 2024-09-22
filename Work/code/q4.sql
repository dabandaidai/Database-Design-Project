-- Report the username of the person who has purchased the most tickets. 
-- If there is a tie, report them all.
SET SEARCH_PATH TO ticketchema, public;

DROP VIEW IF EXISTS count_tickets_per_user CASCADE;

-- Count the number of tickets each user has purchased.
CREATE VIEW count_tickets_per_user AS
    SELECT u.username, coalesce(num_of_tickets, 0) AS num_of_tickets
    FROM "User" u
    LEFT JOIN (
        SELECT username, count(ticket_id) AS num_of_tickets
        FROM "Order"
        GROUP BY username 
    ) ticket_counts
    ON u.username = ticket_counts.username
;

SELECT count_tickets_per_user.*
FROM count_tickets_per_user
WHERE num_of_tickets = (
    SELECT MAX(num_of_tickets) AS max FROM count_tickets_per_user
);
    