-- For each concert, report the total value of all tickets sold and the 
-- percentage of the venue that was sold.
SET SEARCH_PATH TO ticketchema, public;

DROP VIEW IF EXISTS Concert_revenue CASCADE;
DROP VIEW IF EXISTS Total_seats CASCADE;

-- The concerts and their total value of tickets.
CREATE VIEW Concert_revenue AS 
    SELECT Concert.concert_id AS concert, coalesce(sum(price), 0) as revenue, 
    CAST (count(Ticket.ticket_id) AS FLOAT) as seat_taken, venue_id
    FROM TicketType
    JOIN Ticket ON TicketType.type_id = Ticket.type_id
    JOIN "Order" ON Ticket.ticket_id = "Order".ticket_id
    RIGHT JOIN Concert ON Concert.concert_id = TicketType.concert_id
    GROUP BY Concert.concert_id
    ;

-- Total number of seats for each venue.
CREATE VIEW Total_seats AS 
    SELECT venue_id as venue, CAST (count(*) AS FLOAT) as seat_num
    FROM Seat
    GROUP BY venue_id
    ORDER BY venue_id
    ;

SELECT concert, revenue, seat_taken /seat_num AS ratio
FROM Concert_revenue JOIN Total_seats ON 
Concert_revenue.venue_id = Total_seats.venue
ORDER BY concert
;


