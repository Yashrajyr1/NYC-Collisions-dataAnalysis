create table nyc_collisions_cleaned(
Collision_ID int primary key,
Date date,
Time time,
Borough varchar,
Street_Name varchar,
Cross_Street varchar,
Latitude varchar,
Longitude varchar,
Contributing_Factor varchar,
Vehicle_Type varchar,
Persons_Injured int,
Persons_Killed int,
Pedestrians_Injured int,
Pedestrian_Killed int,
Cyclists_Injured int,
Cyclists_Killed int,
Motorists_Injured int,
Motorists_Killed int,
Month varchar,
Year int,
Hour int,
Day_Night varchar,
Weekday varchar
)

-- cleaned data imported from nyc_collisions_cleaned_noheader

select * from nyc_collisions_cleaned

with tab1 as(
select year, borough, count(borough) as count
from nyc_collisions_cleaned
group by year, borough
)
select year, borough, count, rank() over (partition by year order by count desc)
from tab1

with tab2 as( 
select year, borough, count(*) as count
from nyc_collisions_cleaned 
where Vehicle_Type='Transport' OR Vehicle_Type='Taxi' -- similarly check for emergency vahicle, bicycle, bus
group by year, borough
)
select year, borough, count, rank() over(partition by year order by count desc)
from tab2

with tab3 as(
select year, borough, Contributing_Factor, count(*) as count
from nyc_collisions_cleaned
where Contributing_Factor='Driver Inexperience' --similarly check for alcohol involvement, drugs, Road rage, etc..
group by year, borough, Contributing_Factor
)
select year, borough, Contributing_Factor, count, rank() over(partition by year order by count desc)
from tab3

with tab4b as(
with tab4a as(
with tab4 as(
select year, borough, Contributing_Factor,Street_Name, count(*) as count
from nyc_collisions_cleaned
where Contributing_Factor='Unsafe Speed' 
group by year, borough, Contributing_Factor,Street_Name
)
select year, borough, Contributing_Factor,Street_Name, count, rank() over(partition by year order by count desc)
from tab4
)
select year, borough, Contributing_Factor,Street_Name, count, rank() over(partition by year order by count desc)
from tab4a
where rank between 1 and 10
)
select distinct street_name, borough from tab4b


select year, sum(Persons_Injured)
from nyc_collisions_cleaned
group by year

select year, sum(Persons_Killed)
from nyc_collisions_cleaned
group by year

select year, sum(Pedestrians_Injured)
from nyc_collisions_cleaned
group by year

select year, sum(Pedestrian_Killed)
from nyc_collisions_cleaned
group by year

select year, sum(Cyclists_Injured)
from nyc_collisions_cleaned
group by year

select year, sum(Cyclists_Killed)
from nyc_collisions_cleaned
group by year

select year, sum(Motorists_Injured)
from nyc_collisions_cleaned
group by year

select year, sum(Motorists_Killed)
from nyc_collisions_cleaned
group by year
