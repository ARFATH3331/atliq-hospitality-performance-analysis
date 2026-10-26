select top 5 * from dbo.fact_aggregated_bookings_stage;
select top 5 * from dbo.fact_bookings;
select top 5 * from dbo.dim_date;
select top 5 * from dbo.dim_hotels;



-- 1.Bookings and revenue by city: For each city, find total bookings, revenue generated, and revenue realized.


select h.city, count(*) as total_booking, sum(revenue_generated) as revenue_generated, sum(revenue_realized) as revenue_realized
from dbo.fact_bookings as f
inner join dbo.dim_hotels as h
on f.property_id = h.property_id
group by h.city
order by revenue_realized desc;



-- 2.Booking status: How many bookings are Cancelled, Checked Out, and No Show? What percentage of all bookings is each status?

select booking_status,
count(*) as total_booking,
CAST(
    ROUND(
    COUNT(*) * 100.0 / (SELECT COUNT(*) FROM dbo.fact_bookings),
    2)
    AS decimal(5,2)
) AS percentage_of_bookings
from dbo.fact_bookings
group by booking_status
order by percentage_of_bookings desc;


-- 3.Monthly occupancy: For each month, calculate occupancy as total successful bookings divided by total room capacity.Also calculate the overall occupancy.


    select 
        YEAR(b.check_in_date) as booking_year,
        MONTH(b.check_in_date) as booking_month, 
        sum(b.successful_bookings) as successful_bookings,
        CAST(
            ROUND(
                sum(b.successful_bookings)*100.0/ sum(b.capacity),
                2
       ) as decimal(5,2) 
        ) AS occupancy_percentage
    from dbo.fact_aggregated_bookings as b
    group by 
        YEAR(b.check_in_date),
        MONTH(b.check_in_date);

-- 4. Occupancy by city: What is the occupancy percentage for each city?


select 
h.city, 
CAST(
    ROUND(
        sum(f.successful_bookings) *100.0 /  sum(f.capacity),2
        ) As decimal(5,2)
   ) as Occupancy_percentage
    from dbo.fact_aggregated_bookings as f
     join dbo.dim_hotels as h
    on f.property_id = h.property_id
    group by h.city;


   

-- 5. Revenue by month: For each month, find revenue generated and revenue realized.



  SELECT
    YEAR(TRY_CONVERT(date, check_in_date, 105)) AS booking_year,
    MONTH(TRY_CONVERT(date, check_in_date, 105)) AS booking_month,
    SUM(revenue_generated) AS total_revenue_generated,
    SUM(revenue_realized) AS total_revenue_realized
FROM dbo.fact_bookings
GROUP BY
    YEAR(TRY_CONVERT(date, check_in_date, 105)),
    MONTH(TRY_CONVERT(date, check_in_date, 105))
ORDER BY
    booking_year,
    booking_month;

-- 6. Revenue by hotel: Which hotels have the highest and lowest realized revenue?


select 
    h.property_name,
    sum(f.revenue_realized) as realized_revenue
from dbo.fact_bookings as f
join dbo.dim_hotels as h
    on f.property_id = h.property_id
group by
    h.property_name
order by
    realized_revenue desc;


-- 7.Booking platform: How many bookings came from each booking platform, and what was each platform’s share of total bookings?


SELECT
    booking_platform,
    COUNT(booking_id) AS total_bookings,
    CAST(
        ROUND(
            COUNT(booking_id) * 100.0 /
            (SELECT COUNT(booking_id) FROM dbo.fact_bookings),
            2
        ) AS decimal(5,2)
    ) AS percentage_of_bookings
FROM dbo.fact_bookings
GROUP BY booking_platform;


-- 8.Weekday vs. weekend: Compare booking counts and realized revenue for weekday and weekend bookings.



select 
    d.day_type,
    count(*) as booking_count,
    sum(f.revenue_realized) as realized_revenue
from dbo.fact_bookings as f
inner join dbo.dim_date as d
on TRY_CONVERT(date, f.check_in_date, 105) = d.date
group by 
    d.day_type
order by
    booking_count,
    realized_revenue asc;



-- 9. Average rating: What is the average guest rating by city and by room category?


select 
    h.city,
    f.room_category,
    avg(f.ratings_given) as avg_rating
from fact_bookings as f
join dbo.dim_hotels as h
on h.property_id = f.property_id
group by 
    h.city,
    f.room_category
order by 
    f.room_category asc;



-- 10.Cancellation analysis: Which cities and booking platforms have the highest cancellation rates?
-- city by cancellation rates

select 
    h.city, 
    CAST(
    ROUND(
sum(CASE
    WHEN booking_status = 'Cancelled' THEN 1
    else 0
    end)*100.0 /count(*),2
     ) as decimal (5,2)
         ) as cancellation_rates
from  dbo.fact_bookings as f
join dbo.dim_hotels as h
    on f.property_id =h.property_id
group by
    h.city
order by
    cancellation_rates desc
;
-- platform by cancellation rate


select 
    f.booking_platform, 
    CAST(
    ROUND(
sum(CASE
    WHEN booking_status = 'Cancelled' THEN 1
    else 0
    end)*100.0 /count(*),2
     ) as decimal (5,2)
         ) as cancellation_rates
from  dbo.fact_bookings as f
join dbo.dim_hotels as h
    on f.property_id =h.property_id
group by
    f.booking_platform
order by
    cancellation_rates desc
;

-- 11.Room category: For each room category, compare booking count, revenue realized, and occupancy.


with booking_summery as (
    select 
        room_category,
        count(booking_id) as booking_count,
        sum(revenue_realized) as total_revenue
    from dbo.fact_bookings
    group by room_category
),
occupancy_summery as (
    select 
        room_category,
        sum(successful_bookings) as successful_bookings,
        sum(capacity) as total_capacity,
        cast(
        ROUND(
        sum(successful_bookings) *100.0 / sum(capacity),2
        ) as decimal(5,2)
        )
        as occupancy
    from dbo.fact_aggregated_bookings
    group by room_category
)
select 
    b.room_category,
    b.booking_count,
    b.total_revenue,
    f.successful_bookings,
    f.total_capacity,
    f.occupancy
from booking_summery as b
join occupancy_summery as f
    on b.room_category = f. room_category
order by
    b.room_category;

-- 12.Daily trend: Which check-in date had the most bookings, and which had the fewest?



select top 1 
    check_in_date,
    count(booking_id) as booking_counts
from dbo.fact_bookings 
group by 
    check_in_date
order by booking_counts asc;
    

select top 1 
    check_in_date,
    count(booking_id) as booking_counts
from dbo.fact_bookings 
group by 
    check_in_date
order by booking_counts desc;

