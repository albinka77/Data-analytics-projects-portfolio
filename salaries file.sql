create database Salary_Survey;
use Salary_Survey;

select * from salaries;
-- 1. Average Salary by Industry and Gender 
SELECT 
    Industry,
    Gender,
    round(AVG(Annual_Salary),2) AS AverageSalary
FROM 
    salaries 
GROUP BY 
    Industry,
    Gender
ORDER BY 
  AVG(Annual_Salary) DESC ;



-- 2. Total Salary Compensation by Job Title 
SELECT Job_Title, SUM(Annual_salary + (Additional_Monetary_Compensation)) AS Total_salary_compenstion
FROM Salaries
GROUP BY Job_Title
ORDER BY COUNT(Additional_Monetary_Compensation)DESC ;



-- 3. Salary Distribution by Education Level
SELECT highest_level_of_education_completed,
       AVG(Annual_salary) AS Avgsalary,
	   MIN(Annual_salary) AS Minsalary,
	   MAX(Annual_salary) AS Maxsalary
FROM Salaries
GROUP BY highest_level_of_education_completed
ORDER BY Avgsalary DESC;



-- 4. Number of Employees by Industry and Years of Experience 
select Industry, Years_of_professional_experience_overall,
       COUNT(*) AS No_of_employees
FROM Salaries
GROUP BY Industry, Years_of_professional_experience_overall
ORDER BY Industry, Years_of_professional_experience_overall DESC;



-- 5. Median Salary by Age Range and Gender
WITH SalaryRanked AS (
    SELECT 
        Age_Range,
        Gender,
        Annual_Salary,
        ROW_NUMBER() OVER (PARTITION BY Age_Range, Gender ORDER BY Annual_Salary) as RowNum,
        COUNT(*) OVER (PARTITION BY Age_Range, Gender) as TotalCount
    FROM 
        salaries
)
SELECT 
    Age_Range,
    Gender,
    AVG(Annual_Salary) AS MedianSalary
FROM 
    SalaryRanked
WHERE 
    RowNum IN ((TotalCount + 1) / 2, (TotalCount + 2) / 2)
GROUP BY 
    Age_Range,
    Gender
ORDER BY 
    Age_Range,
    Gender;



-- 6. Job Titles with the Highest Salary in Each Country
WITH RankedSalaries AS (
     SELECT 
	      Country,
		  Job_title,
		  Annual_salary,
		  ROW_NUMBER() OVER (PARTITION BY Country ORDER BY Annual_Salary DESC)AS SalaryRank
 FROM Salaries
 )
 SELECT Country,
        Job_title,
		Annual_salary AS Highestslary
FROM RankedSalaries
WHERE SalaryRank = 1
ORDER BY Country;



-- 7. Average Salary by City and Industry
SELECT City, Industry, AVG(Annual_salary) AS Average_salary
FROM Salaries
GROUP BY City, Industry
ORDER BY AVG(Annual_salary) DESC ;



-- 8. Percentage of Employees with Additional Monetary Compensation by Gender 
SELECT Gender,
       SUM(CASE WHEN Additional_Monetary_Compensation IS NOT NULL THEN 1 ELSE 0 END) * 100.0/ COUNT(*) AS Percentage_with_compensation
FROM Salaries
GROUP BY Gender;



-- 9. Total Compensation by Job Title and Years of Experience 
SELECT Job_title, Years_of_professional_experience_overall,
SUM(Annual_salary + (Additional_monetary_compensation)) AS Total_compensation
FROM Salaries
GROUP BY Job_title, Years_of_professional_experience_overall
ORDER BY Job_title, Years_of_professional_experience_overall;



-- 10. Average Salary by Industry, Gender, and Education Level 
SELECT Gender, Industry, Highest_level_of_education_completed,
AVG(Annual_salary) AS Average_salary
FROM Salaries
GROUP BY Gender, Industry, Highest_level_of_education_completed
ORDER BY Gender, Industry, Highest_level_of_education_completed;

 

