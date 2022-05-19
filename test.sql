-- Tables: Pilots, Planes, Flights
-- Task 1 Напишите запрос, который выведет пилотов, которые в качестве второго пилота в августе
-- этого года трижды ездили в аэропорт Шереметьево.
SELECT name 
FROM Pilots
WHERE pilot_id IN (
    SELECT DISTINCT seccond_pilot_id FROM Flights
    WHERE destination = 'Шереметьево'
    AND YEAR(flight_dt) = 2022
    AND MONTH(flight_dt) = 8
    GROUP BY (seccond_pilot_id)
    HAVING COUNT(flight_id) = 3
)

-- Task 2 Выведите пилотов старше 45 лет, совершали полеты на самолетах с количеством пассажиров больше 30.
SELECT name
FROM Pilots
WHERE age > 45
AND pilot_id IN 
    (SELECT DISTINCT first_pilot_id 
    FROM Flights INNER JOIN Planes 
    ON Flights.plane_id = Planes.plane_id
    WHERE cargo_flg = 0
    AND capacity > 30
    UNION 
    SELECT DISTINCT seccond_pilot_id 
    FROM Flights INNER JOIN Planes 
    ON Flights.plane_id = Planes.plane_id
    WHERE cargo_flg = 0
    AND capacity > 30)
    
-- Task 3 Выведите ТОП 10 пилотов-капитанов (first_pilot_id), которые совершили
-- наибольшее число грузовых перелетов в этом году.
SELECT name 
FROM Pilots INNER JOIN Flights ON Pilots.pilot_id = Flights.first_pilot_id
            INNER JOIN Planes ON Planes.plane_id = Flights.plane_id
WHERE YEAR(flight_dt) = 2022 AND cargo_flg = 1 
GROUP BY pilot_id
ORDER BY COUNT(flight_id) DESC
LIMIT 10;
