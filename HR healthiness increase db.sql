-- create a join table
-- Connecting ID column from Abseneteeism table to Compensation table
-- Connect reason for absence # on Absenteeism table with reason # on Reasons table
select * from Absenteeism_at_work a
left join compensation b
on a.ID = b.ID
left join Reasons r on
a.Reason_for_absence = r.Number

--- find the healthiest people (don't smoke, don't drink, healthy bmi, less than average absennteeism)
select * from Absenteeism_at_work
where Social_drinker = 0 and Social_smoker = 0 and Body_mass_index < 25 
and Absenteeism_time_in_hours < (select AVG(Absenteeism_time_in_hours) from Absenteeism_at_work)

-- Calculate compensation rate increase for non-smokers/ budget ($983,221) 
--- 40 hrs x 52 weeks = 2080 hours x 686 employees = 1,426,880
--- $983,221 / 1,426,880 = 0.68 increase/hr. x 2080 hours ---> $1,414.40 given to employee/yr. 
select COUNT(*) as nonsmokers from Absenteeism_at_work
where Social_smoker = 0

--Optimize Query (get rid of ID column in joined table)

select a.ID, r.Reason, Month_of_absence, Body_mass_index,
--Group BMI into category
CASE WHEN Body_mass_index < 18.5 then 'Underweight'
	 WHEN Body_mass_index between 18.5 and 25 then 'Healthy'
	 WHEN Body_mass_index between 25 and 30 then 'Overweight'
	 WHEN Body_mass_index >31 then 'Obese'
	 ELSE 'Unknown' end as 'BMI Category',
--Group month of absence into season
CASE WHEN Month_of_absence IN (12,1,2) Then 'Winter'
	 WHEN Month_of_absence IN (3,4,5) Then 'Spring'
	 WHEN Month_of_absence IN (6,7,8) Then 'Summer'
	 WHEN Month_of_absence IN (9,10,11) Then 'Fall'
	 ELSE 'Unknown' END as Season_names,

-- Group tables by select columns
Month_of_absence, Day_of_the_week, Transportation_expense, Son, Social_drinker, Social_smoker, Pet, Weight, Height, 
Work_load_Average_day, Distance_from_Residence_to_Work, Age, Hit_target,Disciplinary_failure, Service_time, Seasons, Absenteeism_time_in_hours
from Absenteeism_at_work a
left join compensation b
on a.ID = b.ID
left join Reasons r on
a.Reason_for_absence = r.Number