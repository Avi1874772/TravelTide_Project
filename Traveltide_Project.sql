WITH CTE1 AS (
    SELECT
        DISTINCT s.user_id, 
        COUNT(s.session_id) AS session_count,
        ROUND(SUM(EXTRACT(EPOCH FROM (s.session_end - s.session_start)) / 60.0), 2) AS total_duration_minutes
    FROM sessions s
    WHERE s.session_start > '2023-01-04 00:00:00'
    GROUP BY s.user_id
    HAVING COUNT(s.session_id) > 7
)

SELECT
    f.trip_id, CTE1.user_id, f.origin_airport, f.destination,
    f.seats, f.destination_airport, f.return_flight_booked,
    f.departure_time, f.return_time, f.checked_bags,
    f.trip_airline, f.destination_airport_lat, f.destination_airport_lon, f.base_fare_usd,
    h.hotel_name, h.nights as Nights_stayed, h.rooms as Rooms_booked,
    h.check_in_time, h.check_out_time, h.hotel_per_room_usd,
    CTE1.session_count, CTE1.total_duration_minutes, s.session_start,
    s.flight_discount, s.hotel_discount, s.flight_discount_amount,
    s.hotel_discount_amount, s.flight_booked, s.hotel_booked,
    u.birthdate, u.gender, u.married, u.has_children,
    u.home_country, u.home_city, u.home_airport,
    u.home_airport_lat, u.home_airport_lon,
    u.sign_up_date
FROM sessions s
LEFT JOIN flights f ON s.trip_id = f.trip_id
LEFT JOIN hotels h ON s.trip_id = h.trip_id 
LEFT JOIN users u ON s.user_id = u.user_id
JOIN CTE1 ON s.user_id = CTE1.user_id
WHERE s.session_start > '2023-01-04 00:00:00';



