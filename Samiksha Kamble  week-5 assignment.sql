use genzdataset;
SELECT * FROM  learning_aspirations;
SELECT * FROM  manager_aspirations;
SELECT * FROM  mission_aspirations;
SELECT * FROM  personalized_info;

#1)what percentage of male and female Genz wants to got to office every day?(use join function) 
SELECT gender, 
round((sum(case when p.gender like 'Male%' then 1 else 0 end)/count(*))*100,2) 
AS Male_aspirant,
round((sum(case when p.gender like 'Female%' then 1 else 0 end)/count(*))*100,2) 
AS Female_aspirant
FROM learning_aspirations l LEFT JOIN personalized_info p
ON l.ResponseID = p.ResponseID
where PreferredWorkingEnvironment like 'Every Day%';

#2)What percentage of Gen'z who have chosen their career in Bussiness Operations are most likely to be influenced by their Parents?

SELECT 
(SUM(CASE WHEN ClosestAspirationalCareer LIKE 'Business Operations%' THEN 1 ELSE 0 END) / COUNT(*)) * 100 
AS Genz_who_influenced_By_parents
FROM learning_aspirations
where CareerInfluenceFactor = 'My Parents';

#3)What percentage of Genz prefer opting for higher studies, give a gender wise approach?
-- personalized_info = gender , learning_Aspirations = HigherEducationAbroad( Yes, I wil )
SELECT 
round((sum(case when p.gender like 'Male%' then 1 else 0 end)/count(*))*100,2) 
AS Male_aspirant,
round((sum(case when p.gender like 'Female%' then 1 else 0 end)/count(*))*100,2) 
AS Female_aspirant
FROM  personalized_info p JOIN learning_aspirations l
ON p.ResponseID = l.ResponseID
where HigherEducationAbroad like 'yes%';

#4)What percentage of Genz willing & not willing to work for a company whose mission is misaligned with their public actions or even their products?
SELECT gender,
	100*sum(CASE WHEN p.gender like 'Male%' and MisalignedMissionLikelihood = 'Will work for them' THEN 1 ELSE 0 END)/count(*) AS Male_WiLLing_to_WORK,
    100*sum(CASE WHEN p.gender like 'Male%' and MisalignedMissionLikelihood = 'Will NOT work for them' THEN 1 ELSE 0 END)/count(*) AS Male_Not_WiLLing_to_WORK,
    100*sum(CASE WHEN p.gender like 'Female%' and MisalignedMissionLikelihood = 'Will work for them' THEN 1 ELSE 0 END)/count(*) AS Female_WiLLing_to_WORK,
    100*sum(CASE WHEN p.gender like 'Female%' and MisalignedMissionLikelihood = 'Will NOT work for them' THEN 1 ELSE 0 END)/count(*) AS Female_Not_WiLLing_to_WORK
    FROM personalized_info p INNER JOIN mission_aspirations m
ON  p.ResponseID = m.ResponseID;

-- 5)What is the most suitable environment according to female Genz?
SELECT gender,PreferredWorkingEnvironment,count(PreferredWorkingEnvironment ) as Female_prefrred_Work_Env
FROM learning_aspirations INNER JOIN personalized_info
ON learning_aspirations.ResponseID = personalized_info.ResponseID
GROUP BY gender like 'Female%'
order by PreferredWorkingEnvironment desc limit 1;

#6)What is the percentage of Males who expected to a salary 5 years >50k and also work under Employers who appreciates learning but doesn't enables an learning environment?
SELECT
round(( sum(case when pi.gender like 'Male%' then 1 else 0 end) /count(*)) *100,2) as Male_Aspirants   
FROM personalized_info pi
INNER JOIN mission_aspirations ma ON pi.ResponseID = ma.ResponseID
INNER JOIN manager_aspirations mna ON pi.ResponseID = mna.ResponseID
where ma.ExpectedSalary5Years not like '>30k%'
and mna.PreferredEmployer like '%appreciates%but%enables%';

#7)Calculate the total number of female who aspire to work in their Closest Aspirational career and have a No Social Impact Likelihood of "1 to 5"
select count(pi.gender) as Female_aspirants
from personalized_info  pi join learning_aspirations la 
on pi.ResponseID = la.ResponseID
join mission_aspirations ma
on pi.ResponseID = ma.ResponseID
where pi.gender like 'Female%' and ma.NoSocialImpactLikelihood between 1 and 5;

#8)Retrieve the male who are interested in Higher Education Abroad and have a Career Influnce Factor o 'My Parents'.
select pi.gender,la.HigherEducationAbroad, la.CareerInfluenceFactor
from personalized_info pi inner join learning_aspirations la
on pi.ResponseID = la.ResponseID
where pi.gender like 'Male%' and HigherEducationAbroad = "Yes, I wil" and CareerInfluenceFactor = "My Parents";

#9)Determine the percentage of gender who have a No Social Impact Likelihood of "8 to 10" among those who are interested in Higher Education Abroad
SELECT gender,
    100*sum(CASE WHEN (ma.NoSocialImpactLikelihood between 8 and 10) and (la.HigherEducationAbroad ='Yes, I wil' ) THEN 1 ELSE 0 END)/count(*) as No_SocialMediaLikelihood_And_IntresetedHigherEdu
FROM personalized_info pi
JOIN mission_aspirations ma ON pi.ResponseID = ma.ResponseID
JOIN learning_aspirations as la ON la.ResponseID = ma.ResponseID
group by gender;

#10)Give a detailed split of the GenZ preferences to work with Teams, Data Should include Male, female and Overall in counts and also the overall in %
select 
sum(case when p.gender like 'Male%' then 1 else 0 end) as male_count,
sum(case when p.gender like 'Female%' then 1 else 0 end) as male_count,
round((sum(case when p.gender  like 'Male%' then 1 else 0 end) / count(*)) * 100, 2) as male_percent,
round((sum(case when p.gender  like 'Female%' then 1 else 0 end) / count(*)) * 100, 2) as female_percent
from personalized_info p inner join manager_aspirations m
on p.ResponseID = m.ResponseID
where m.PreferredWorkSetup like '%Team%';

#11) Give a detailed breakdown of "Worklikelihood3Years" for each gender
select m.Worklikelihood3Years,
sum(case when p.gender like 'Male%' then 1 else 0 end) as male_count,
sum(case when p.gender like 'Female%' then 1 else 0 end) as male_count
from personalized_info p
inner join manager_aspirations m ON p.ResponseID = m.ResponseID
group by m.Worklikelihood3Years;

#12) Give a detailed breakdown of of "Worklikelihood3Years" for each currentCountry in India
SELECT 
   m.Worklikelihood3Years,
    sum(CASE WHEN p.CurrentCountry = "India" THEN 1 END) AS India_count
FROM personalized_info p
LEFT JOIN manager_aspirations m ON p.ResponseID = m.ResponseID
GROUP BY m.Worklikelihood3Years;

#14) what is Average Starting Salary expectations at 3 year mark for each gender
select p.gender, 
      avg(cast(substring_index(ExpectedSalary3Years, 'k', 1 ) as signed )) as avg_starting_salary
from personalized_info p
inner join mission_aspirations ms 
ON p.ResponseID = ms.ResponseID
group by p.gender;

#15) What is Average Starting Salary expectations at 5 year mark for each gender
select p.gender, 
      avg(cast(substring_index(ExpectedSalary5Years, 'k', 1 ) as signed )) as avg_starting_salary
from personalized_info p
inner join mission_aspirations ms 
ON p.ResponseID = ms.ResponseID
group by p.gender;
    
#16) What is Average Higher Bar  Salary expectations at 3 year mark for each gender
select p.gender,
avg(round(case when m.ExpectedSalary3Years like '31k%' then 40000
when m.ExpectedSalary3Years like '21k%' then 25000
when m.ExpectedSalary3Years like '>50k%' then 50000
when m.ExpectedSalary3Years like '26k%' then 30000
when m.ExpectedSalary3Years like '16k%' then 20000
when m.ExpectedSalary3Years like '41k%' then 50000
when m.ExpectedSalary3Years like '11k%' then 15000
when m.ExpectedSalary3Years like '5k%' then 10000 end)) as Avg_Expected_HighBar_Salary
from personalized_info as p
join mission_aspirations as m
on p.ResponseID =  m.ResponseID
group by  p.gender;

#17) What is Average Higher Bar  Salary expectations at 5 year mark for each gender
select p.gender,
avg(round(case when m.ExpectedSalary5Years like '111k%' then 130000
when m.ExpectedSalary5Years like '131k%' then 150000
when m.ExpectedSalary5Years like '30k%' then 50000
when m.ExpectedSalary5Years like '50k%' then 70000
when m.ExpectedSalary5Years like '71k%' then 90000
when m.ExpectedSalary5Years like '91k%' then 110000
when m.ExpectedSalary5Years like '>151k%' then 151000 end)) as Avg_Expected_HighBar_Salary
from personalized_info as p
join mission_aspirations as m
on p.ResponseID =  m.ResponseID
group by  p.gender;


#18)What is average starting salary expectations at 3 year mark for each gender and each state in India CurrentCountry
With AvgStartingSalaryIn3Years AS(
		Select
                ms.ExpectedSalary3Years,
                p.gender, p.CurrentCountry,
                case
                        when ms.ExpectedSalary3Years = '>50k' then 50000
                        else
							(cast(substring(ms.ExpectedSalary3Years,1,locate('k',ms.ExpectedSalary3Years)-1) as unsigned))*1000
						end
                        as salaryRange
		FROM personalized_info p
	    JOIN mission_aspirations ms ON p.ResponseID = ms.ResponseID
)
SELECT Gender, CurrentCountry,
    ROUND(AVG(salaryRange), 2) As AverageSalary 
FROM AvgStartingSalaryIn3Years
where Gender is not null
group by gender, CurrentCountry
order by AverageSalary DESC;
    
    
#19)What is average starting salary expectations at 5 year mark for each gender and each state in India
With AvgStartingSalaryIn3Years AS(
		Select
                ms.ExpectedSalary5Years,
                p.gender,p.CurrentCountry,
                case
                        when ms.ExpectedSalary5Years = '>50k' then 50000
                        else
							(cast(substring(ms.ExpectedSalary5Years,1,locate('k',ms.ExpectedSalary5Years)-1) as unsigned))*1000
						end
                        as salaryRange
		FROM personalized_info p
	    JOIN mission_aspirations ms ON p.ResponseID = ms.ResponseID
)
SELECT Gender, CurrentCountry,
    ROUND(AVG(salaryRange), 2) As AverageSalary 
FROM AvgStartingSalaryIn3Years
where Gender is not null
group by gender, CurrentCountry
order by AverageSalary DESC;
    
#20) What is the Average Higher Bar Salary Expectations at 3 year mark for each gender and each state in India?   
select p.gender, p.CurrentCountry,
avg(round(case when m.ExpectedSalary3Years like '31k%' then 40000
when m.ExpectedSalary3Years like '21k%' then 25000
when m.ExpectedSalary3Years like '>50k%' then 50000
when m.ExpectedSalary3Years like '26k%' then 30000
when m.ExpectedSalary3Years like '16k%' then 20000
when m.ExpectedSalary3Years like '41k%' then 50000
when m.ExpectedSalary3Years like '11k%' then 15000
when m.ExpectedSalary3Years like '5k%' then 10000 end)) as Avg_HigherBar_Salary_for_country_and_gender
from personalized_info as p
join mission_aspirations as m
on p.ResponseID =  m.ResponseID
group by  p.gender, p.CurrentCountry;


#21) What is the Average Higher Bar Salary Expectations at 5 year mark for each gender and each state in India?   
select p.gender, p.CurrentCountry,
avg(round(case when m.ExpectedSalary5Years like '111k%' then 130000
when m.ExpectedSalary5Years like '131k%' then 150000
when m.ExpectedSalary5Years like '30k%' then 50000
when m.ExpectedSalary5Years like '50k%' then 70000
when m.ExpectedSalary5Years like '71k%' then 90000
when m.ExpectedSalary5Years like '91k%' then 110000
when m.ExpectedSalary5Years like '>151k%' then 151000 end)) as Avg_HigherBar_Salary_for_country_and_gender
from personalized_info as p
join mission_aspirations as m
on p.ResponseID =  m.ResponseID
group by  p.gender, p.CurrentCountry;

#22) Give a detailed breakdown of the possibility of genZ working for an Org if the "Mission is misaligned" for each state in India
select gender, count(*) as possibility_count, currentcountry
from personalized_info as p join mission_aspirations as m
on p.responseid = m.responseid
where misalignedmissionlikelihood = 'Will work for them'
group by gender, currentcountry
order by currentcountry, gender;

