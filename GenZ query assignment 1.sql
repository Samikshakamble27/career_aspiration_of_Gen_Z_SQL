use genzdataset;

SHOW TABLES;

SELECT * FROM  learning_aspirations;

select * from personalized_info;

SELECT *
FROM learning_aspirations AS LA
JOIN manager_aspirations AS MA ON LA.ResponseID = MA.ResponseID
JOIN mission_aspirations AS MSA ON LA.ResponseID = MSA.ResponseID
JOIN personalized_info AS PI ON LA.ResponseID = PI.ResponseID;



#1)how many males have responded to the survey from india- (gender, Country)
SELECT COUNT(*) AS TotalMalesFromIndia
FROM learning_aspirations AS LA
JOIN manager_aspirations AS MA ON LA.ResponseID = MA.ResponseID
JOIN mission_aspirations AS MSA ON LA.ResponseID = MSA.ResponseID
JOIN personalized_info AS PI ON LA.ResponseID = PI.ResponseID
WHERE gender LIKE 'Male%'
AND currentcountry LIKE 'India%';



#2)how many females have responded to the survey from india- (gender, Country)
SELECT COUNT(*) AS TotalFemalesFromIndia
FROM learning_aspirations AS LA
JOIN manager_aspirations AS MA ON LA.ResponseID = MA.ResponseID
JOIN mission_aspirations AS MSA ON LA.ResponseID = MSA.ResponseID
JOIN personalized_info AS PI ON LA.ResponseID = PI.ResponseID
WHERE gender LIKE 'Female%'
AND currentcountry LIKE 'India%';

#3)how many of the Gen-Z are influenced by their parents in regards to their career choices from India - (CareerInfluenceFactor, currentcountry)
SELECT COUNT(*) AS countOfGenZWithInfluncedParents
FROM learning_aspirations AS LA
JOIN personalized_info AS PI ON LA.ResponseID = PI.ResponseID
WHERE currentcountry LIKE '%India'
AND CareerInfluenceFactor LIKE '%My Parents%';

#4)How many of female Gen Z are influenced by their parents in regard to their career choices from india
SELECT COUNT(*) AS countOfFemaleGenZWithInfluncedParents
FROM learning_aspirations AS LA
JOIN personalized_info AS PI ON LA.ResponseID = PI.ResponseID
WHERE currentcountry LIKE '%India'
AND CareerInfluenceFactor LIKE '%My Parents%'
AND gender LIKE '%Female%';


#5)How many of male Gen Z are influenced by their parents in regard to their career choices from india
SELECT COUNT(*) AS countOfFemaleGenZWithInfluncedParents
FROM learning_aspirations AS LA
JOIN personalized_info AS PI ON LA.ResponseID = PI.ResponseID
WHERE currentcountry LIKE '%India'
AND CareerInfluenceFactor LIKE '%My Parents%'
AND gender LIKE '%Male%';

#6)How many of the Male and Female(indivisually display in 2 different columns, but as a part of the same query) Gen-Z are influenced by their parents in regards to therir career choices from india
SELECT
    SUM(CASE WHEN gender LIKE '%Male%' AND TRIM(CareerInfluenceFactor) LIKE '%My Parents%' THEN 1 ELSE 0 END) AS MaleCount,
    SUM(CASE WHEN gender LIKE '%Female%' AND TRIM(CareerInfluenceFactor) LIKE '%My Parents%' THEN 1 ELSE 0 END) AS FemaleCount
FROM learning_aspirations AS LA
JOIN personalized_info AS PI ON LA.ResponseID = PI.ResponseID
WHERE currentcountry LIKE 'India';


#7)how many gen-Z are influenced by social media and Influencer together from India
SELECT COUNT(*) AS TotalCount
FROM learning_aspirations AS LA
JOIN personalized_info AS PI ON LA.ResponseID = PI.ResponseID
WHERE currentcountry = "India" and CareerInfluenceFactor 
IN ('Social Media like LinkedIn', 'Influencers who had successful careers');



#8)How many Gen-Z are influenced by social media and influencers together, display for Male and Female seperately from India
SELECT COUNT(gender='Male%')AS MaleCount,
COUNT(gender='Female%')AS FemaleCount
FROM learning_aspirations AS LA
JOIN personalized_info AS PI ON LA.ResponseID = PI.ResponseID
WHERE currentcountry = "India" and CareerInfluenceFactor 
IN ('Social Media like LinkedIn', 'Influencers who had successful careers');


#9)How many of the Gen-Z who are influenced by the social media for their career aspiration are looking to go abroad
SELECT COUNT(*) AS Inspired_GenZ_Count
FROM learning_aspirations
WHERE HigherEducationAbroad = 'Yes, I wil'
AND CareerInfluenceFactor = 'Social Media like LinkedIn';
 

#10)How many Of the Gen-Z who are influenced by "people in their circle" for career aspiration are looking to go abroad
SELECT COUNT(*) AS Inspired_GenZ_Count
FROM learning_aspirations
WHERE HigherEducationAbroad = 'Yes, I wil'
AND CareerInfluenceFactor = 'People from my circle, but not family members';


