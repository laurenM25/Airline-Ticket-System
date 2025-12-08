/* upcoming flights */
CREATE OR REPLACE VIEW upcoming_flights AS
SELECT
  f.airline_name,
  f.flight_num,
  f.departure_airport,
  a_dep.city AS departure_city,
  f.departure_time,
  f.arrival_airport,
  a_arr.city AS arrival_city,
  f.arrival_time,
  f.price,
  f.status,
  f.airplane_id
FROM flight f
JOIN airport a_dep ON f.departure_airport = a_dep.name
JOIN airport a_arr ON f.arrival_airport   = a_arr.name
WHERE f.status = 'upcoming';

/* in-progress flights */
CREATE OR REPLACE VIEW in_progress_flights AS
SELECT
  f.airline_name,
  f.flight_num,
  f.departure_airport,
  a_dep.city AS departure_city,
  f.departure_time,
  f.arrival_airport,
  a_arr.city AS arrival_city,
  f.arrival_time,
  f.price,
  f.status,
  f.airplane_id
FROM flight f
JOIN airport a_dep ON f.departure_airport = a_dep.name
JOIN airport a_arr ON f.arrival_airport   = a_arr.name
WHERE f.status = 'in-progress';

/* purchased flights */
CREATE OR REPLACE VIEW purchased_flights AS
SELECT
  p.ticket_id,
  p.customer_email,
  c.name AS customer_name,
  p.booking_agent_email,
  p.purchase_date,
  t.airline_name,
  t.flight_num,
  f.departure_airport,
  a_dep.city AS departure_city,
  f.departure_time,
  f.arrival_airport,
  a_arr.city AS arrival_city,
  f.arrival_time,
  f.price,
  f.status,
  f.airplane_id
FROM purchases p
JOIN ticket t   ON p.ticket_id = t.ticket_id
JOIN flight f   ON t.airline_name = f.airline_name AND t.flight_num = f.flight_num
JOIN customer c ON p.customer_email = c.email
JOIN airport a_dep ON f.departure_airport = a_dep.name
JOIN airport a_arr ON f.arrival_airport   = a_arr.name;

CREATE OR REPLACE VIEW browse_flights AS
SELECT uf.*, a.seat_capacity - COUNT(t.ticket_id) AS available_seats
FROM (upcoming_flights uf JOIN airplane a ON uf.airplane_id = a.id AND uf.airline_name = a.airline_name)
GROUP BY uf.flight_num
HAVING available_seats > 0;


/* spending (per-customer, per-purchase rows) */
CREATE OR REPLACE VIEW spending AS
SELECT
  p.customer_email,
  c.name AS customer_name,
  p.purchase_date,
  t.airline_name,
  t.flight_num,
  f.price AS ticket_price
FROM purchases p
JOIN customer c ON p.customer_email = c.email
JOIN ticket t   ON p.ticket_id = t.ticket_id
JOIN flight f   ON t.airline_name = f.airline_name AND t.flight_num = f.flight_num;


/* agent analytics */
CREATE OR REPLACE VIEW agent_analytics AS
SELECT
  p.booking_agent_email,
  p.ticket_id,
  p.customer_email,
  p.purchase_date,
  t.airline_name,
  t.flight_num,
  f.price AS sold_price,
  (f.price * 0.10) AS commission
FROM purchases p
JOIN ticket t ON p.ticket_id = t.ticket_id
JOIN flight f ON t.airline_name = f.airline_name AND t.flight_num = f.flight_num
WHERE p.booking_agent_email IS NOT NULL;

/* next 30 days flights (upcoming + in-progress, within next 30 days) */
CREATE OR REPLACE VIEW next_30_days_flights AS
SELECT
  f.airline_name,
  f.flight_num,
  f.departure_airport,
  a_dep.city AS departure_city,
  f.departure_time,
  f.arrival_airport,
  a_arr.city AS arrival_city,
  f.arrival_time,
  f.price,
  f.status,
  f.airplane_id
FROM flight f
JOIN airport a_dep ON f.departure_airport = a_dep.name
JOIN airport a_arr ON f.arrival_airport   = a_arr.name
WHERE f.status IN ('upcoming', 'in-progress')
  AND f.departure_time BETWEEN NOW() AND DATE_ADD(NOW(), INTERVAL 30 DAY);

/* customers list for flight */
CREATE OR REPLACE VIEW customers_list_for_flight AS
SELECT
  t.airline_name,
  t.flight_num,
  f.departure_time,
  f.arrival_time,
  p.ticket_id,
  p.purchase_date,
  p.booking_agent_email,
  p.customer_email,
  c.name AS customer_name
FROM ticket t
JOIN flight f   ON t.airline_name = f.airline_name AND t.flight_num = f.flight_num
JOIN purchases p ON p.ticket_id = t.ticket_id
JOIN customer c  ON p.customer_email = c.email;

/* customer analytics (tickets purchased per customer per airline) */
CREATE OR REPLACE VIEW customer_analytics AS
SELECT
  t.airline_name,
  p.customer_email,
  c.name AS customer_name,
  COUNT(*) AS tickets_purchased
FROM purchases p
JOIN ticket t   ON p.ticket_id = t.ticket_id
JOIN customer c ON p.customer_email = c.email
GROUP BY
  t.airline_name,
  p.customer_email,
  c.name;

/* sold tickets with airline (for convenience) */
CREATE OR REPLACE VIEW sold_tickets_w_airline AS
SELECT
    al.name AS airline_name,
    f.flight_num,
    t.ticket_id,
    p.customer_email,
    p.booking_agent_email,
    p.purchase_date
FROM airline   AS al
JOIN flight    AS f
  ON al.name = f.airline_name
JOIN ticket    AS t
  ON f.airline_name = t.airline_name
  AND f.flight_num   = t.flight_num
JOIN purchases AS p
  ON t.ticket_id    = p.ticket_id;

/* past flights (arrival_time already passed) */
CREATE OR REPLACE VIEW past_flights AS
SELECT
  f.airline_name,
  f.flight_num,
  f.departure_airport,
  a_dep.city AS departure_city,
  f.departure_time,
  f.arrival_airport,
  a_arr.city AS arrival_city,
  f.arrival_time,
  f.price,
  f.status,
  f.airplane_id
FROM flight f
JOIN airport a_dep ON f.departure_airport = a_dep.name
JOIN airport a_arr ON f.arrival_airport   = a_arr.name
WHERE f.arrival_time < NOW();

/* staff analytics */
CREATE OR REPLACE VIEW staff_analytics AS
SELECT
    -- flight info (from past_flights)
    pf.airline_name,
    pf.flight_num,
    pf.departure_airport,
    pf.departure_city,
    pf.departure_time,
    pf.arrival_airport,
    pf.arrival_city,
    pf.arrival_time,
    pf.price,
    pf.status,
    pf.airplane_id,

    -- ticket & sale info (from sold_tickets_w_airline)
    stwa.ticket_id,
    stwa.purchase_date,

    -- customer info
    stwa.customer_email,
    c.name AS customer_name,

    -- agent info
    stwa.booking_agent_email,
    ba.email AS agent_email,          -- same as booking_agent_email, but from booking_agent table

    -- agent analytics (per-ticket)
    aa.sold_price,
    aa.commission,

    -- customer analytics (per customer per airline)
    ca.tickets_purchased
    FROM sold_tickets_w_airline stwa
    JOIN past_flights pf
      ON stwa.airline_name = pf.airline_name
     AND stwa.flight_num   = pf.flight_num

    LEFT JOIN customer c
      ON stwa.customer_email = c.email

    LEFT JOIN booking_agent ba
      ON stwa.booking_agent_email = ba.email

    LEFT JOIN agent_analytics aa
      ON stwa.booking_agent_email = aa.booking_agent_email
     AND stwa.ticket_id          = aa.ticket_id

    LEFT JOIN customer_analytics ca
      ON stwa.customer_email = ca.customer_email
     AND stwa.airline_name   = ca.airline_name;


/* top destinations (tickets sold by destination city/airport, per airline) */
CREATE OR REPLACE VIEW top_destinations AS
SELECT
  t.airline_name,
  f.arrival_airport AS destination_airport,
  a_arr.city AS destination_city,
  COUNT(*) AS tickets_sold
FROM purchases p
JOIN ticket t ON p.ticket_id = t.ticket_id
JOIN flight f ON t.airline_name = f.airline_name AND t.flight_num = f.flight_num
JOIN airport a_arr ON f.arrival_airport = a_arr.name
GROUP BY
  t.airline_name,
  f.arrival_airport,
  a_arr.city;
















