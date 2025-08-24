use lms;
select * from assessment_submission;


-- Q1. List all the cources with their category names
-- Retrieve a list of courses along with the name of the category to which each course belongs

select 
course_id,
course_name,
categories.category_name 
from courses
left join categories on courses.category_id = categories.category_id
order by
course_id
_____________________________________________________________________________________________________________________________________________________
_____________________________________________________________________________________________________________________________________________________
-- Q2. Count the Number of Courses in Each Category
-- For each category, count how many courses exist.
select 
categories.category_id,
categories.category_name,
count(courses.course_name) as total_no_of_courses 
from categories
join courses on courses.category_id = categories.category_id
group by 
categories.category_name, categories.category_id
order by
categories.category_id
_____________________________________________________________________________________________________________________________________________________
_____________________________________________________________________________________________________________________________________________________
--  Q3. List All Students’ Full Names and Email Addresses
-- Retrieve the full names and email addresses for all users with the role 'student'
select
concat(first_name,' ',last_name) as Full_Name, email from user
where
role = 'student'
order by
Full_Name
_____________________________________________________________________________________________________________________________________________________
_____________________________________________________________________________________________________________________________________________________
-- Q4. Retrieve All Modules for a Specific Course Sorted by Module Order
-- For a given course (e.g., course_id = 1), list its modules sorted by their order.
select 
modules.module_order,
modules.module_id,
courses.course_id,
modules.module_name,
courses.course_name
from modules
left join courses on courses.course_id = modules.course_id
where
courses.course_id = 1
order by modules.module_order
_____________________________________________________________________________________________________________________________________________________
_____________________________________________________________________________________________________________________________________________________
-- Q5. List All Content Items for a Specific Module
-- Retrieve all content items for a specific module (for example, module_id = 2)
Select 
module_id,
content_id,
title,
content_type,
url 
from content
where
module_id = 2
order by content_id
_____________________________________________________________________________________________________________________________________________________
_____________________________________________________________________________________________________________________________________________________
-- Q6. Find the Average Score for a Specific Assessment
-- Calculate the average score of submissions for a given assessment (e.g., assessment_id = 1)
select 
assessment_submission.assessment_id,
assessment_submission.submission_id,
assessments.assessment_name,
assessment_submission.user_id,
assessment_submission.submission_data,
round(avg(score)) as Average_Score
from assessment_submission
left join assessments on assessments.assessment_id = assessment_submission.assessment_id
where
assessment_submission.assessment_id = 1
group by assessment_submission.user_id, assessment_submission.assessment_id, assessment_submission.submission_id
_____________________________________________________________________________________________________________________________________________________
_____________________________________________________________________________________________________________________________________________________
-- Q7 List All Enrollments with Student Names and Course Names
--  Retrieve a list of enrollments that shows the student’s full name, the course name, and the enrollment date.
select 
courses.course_id,
enrollments.enrollment_id,
concat(user.first_name,' ',user.last_name) as Full_Name,
courses.course_name,
enrollments.enrolled_at as Enrollment_date_and_time 
from user
inner join enrollments on user.user_id = enrollments.user_id
inner join courses on courses.course_id = enrollments.course_id
order by enrollments.enrollment_id
_____________________________________________________________________________________________________________________________________________________
_____________________________________________________________________________________________________________________________________________________
-- Q8 Retrieve All Instructors’ Full Names
-- List the full names and email addresses of all users with the role 'instructor'
select 
concat(first_name,' ', last_name) as Full_Name,
email,
role 
from user
where
role = "instructor"
order by
Full_Name
_____________________________________________________________________________________________________________________________________________________
_____________________________________________________________________________________________________________________________________________________
-- Q9 Count the Number of Assessment Submissions per Assessment
-- For each assessment, count how many submissions have been made

select 
assessments.assessment_id,
assessments.assessment_name,
count(assessment_submission.submission_id) as No_of_submissions 
from assessment_submission
left join assessments on assessments.assessment_id = assessment_submission.assessment_id
group by 
assessment_id
_____________________________________________________________________________________________________________________________________________________
_____________________________________________________________________________________________________________________________________________________
-- Q10 List the Top Scoring Submission for Each Assessment
--  Retrieve, for each assessment, the submission that achieved the highest score
select 
assessment_id,
submission_data,
submission_id,
max(score) as Max_Score_By_Assessment 
from assessment_submission
group by 
submission_id
____________________________________________________________________________________________
SELECT assessment_submission.assessment_id,
assessments.assessment_name,
assessment_submission.submission_id,
assessment_submission.user_id,
assessment_submission.score,
assessment_submission.submitted_at
FROM (
SELECT assessment_submission.assessment_id,
MAX(assessment_submission.score) AS max_score
FROM assessment_submission
GROUP BY assessment_submission.assessment_id
) as Maximum_Score
JOIN assessment_submission
ON assessment_submission.assessment_id = Maximum_Score.assessment_id
AND assessment_submission.score = Maximum_Score.max_score
JOIN assessments
ON assessments.assessment_id = assessment_submission.assessment_id
ORDER BY Maximum_Score.assessment_id, assessment_submission.submission_id
_____________________________________________________________________________________________________________________________________________________
_____________________________________________________________________________________________________________________________________________________
-- Q11 Retrieve Courses Created After a Specific Date
-- List courses that were created after '2023-04-01'

select * from courses
where
created_at > '2023-04-01'
order by course_id
_____________________________________________________________________________________________________________________________________________________
_____________________________________________________________________________________________________________________________________________________
-- Q12 Find Students Who Have Not Submitted Any Assessments
-- Retrieve a list of students who do not have any records in the assessment_submission table
select 
user.user_id,
assessment_submission.submission_id,
concat(user.first_name,' ',user.last_name) as Full_Name,
user.role 
from user
left JOIN assessment_submission on user.user_id = assessment_submission.user_id
where
role = 'student'
and
submission_id in ('null','Null','NULL')
order by
Full_Name
_____________________________________________________________________________________________________________________________________________________
_____________________________________________________________________________________________________________________________________________________
-- Q13 List the Content for Courses in the 'Programming' Category
-- Retrieve all content items for courses whose category is 'Programming'.
-- Table used Content to Modules to Courses to Categories

select 
content.content_id,
content.module_id,
content.title,
content.content_type,
content.url,
Programming_Course_and_category.category_name 
from content
join modules on 
modules.module_id = content.module_id
inner join (select categories.category_id, categories.Category_name, courses.course_id from Categories
join courses on courses.category_id = categories.category_id
where
categories.category_name = "Programming") as Programming_Course_and_category
on Programming_Course_and_category.course_id = modules.course_id
______________________________________________________________________________________________
SELECT 
content.content_id,
content.title,
content.content_type,
content.url,
courses.course_name,
modules.module_name
FROM categories
JOIN courses
ON courses.category_id = categories.category_id
JOIN modules
ON modules.course_id = courses.course_id
JOIN content
ON content.module_id = modules.module_id
WHERE categories.category_name = 'Programming'
ORDER BY courses.course_id, modules.module_order, content.content_id;
_____________________________________________________________________________________________________________________________________________________
_____________________________________________________________________________________________________________________________________________________
-- Q14 Retrieve Modules That Have No Associated Content
-- List modules that do not have any content items linked to them.
Select 
modules.module_id,
module_name,
null_content_id.content_id 
from modules
left join (select content_id, module_id from content) as null_content_id
on null_content_id.module_id = modules.module_id
where
null_content_id.content_id is null
_____________________________________________________________________________________________________________________________________________________
select 
modules.module_id,
modules.module_name,
content.content_id,
modules.course_id 
from modules
left join content on content.module_id = modules.module_id
where
content.content_id in ('NULL','null','Null')
order by 
modules.course_id, modules.module_id
_____________________________________________________________________________________________________________________________________________________
_____________________________________________________________________________________________________________________________________________________
-- Q15 List Courses with the Total Number of Enrollments
-- For each course, display the course name along with the count of enrollments
select 
courses.course_id, 
course_name, 
count(enrollments.enrollment_id) as Enrollment_count 
from courses
inner join enrollments on enrollments.course_id = courses.course_id
group by 
courses.course_id, course_name
order by 
courses.course_id
_____________________________________________________________________________________________________________________________________________________
_____________________________________________________________________________________________________________________________________________________
-- Q16 Find the Average Assessment Submission Score for Each Course
-- Calculate the average score of all assessment submissions for each course by joining courses, modules, assessments, and submissions.
SELECT 
courses.course_id, 
courses.course_name, 
AVG(assessment_submission.score) AS avg_submission_score
FROM courses
JOIN modules ON modules.course_id = courses.course_id
JOIN assessments ON assessments.module_id = modules.module_id
JOIN assessment_submission ON assessment_submission.assessment_id = assessments.assessment_id
GROUP BY courses.course_id, courses.course_name
ORDER BY courses.course_id;
_____________________________________________________________________________________________________________________________________________________
_____________________________________________________________________________________________________________________________________________________
-- Q17 List Users with Their Number of Enrollments
-- Retrieve a list of all users along with the count of courses they are enrolled in.
select 
user.user_id, 
concat(first_name,' ',last_name) as full_name, 
count(enrollments.enrollment_id) as No_of_enrollments 
from user
left join enrollments on enrollments.user_id = user.user_id
group by user.user_id
order by user.user_id
_____________________________________________________________________________________________________________________________________________________
_____________________________________________________________________________________________________________________________________________________
-- Q18 Find the Assessment with the Highest Average Score
-- Identify the assessment that has the highest average submission score.
WITH Average_Score as
(
select assessments.assessment_id, assessments.assessment_name, Avg(Assessment_submission.score) as avg_score from assessments
join assessment_submission on assessment_submission.assessment_id = Assessments.assessment_id
group by
assessments.assessment_id, assessments.assessment_name
)
select Average_Score.assessment_id, Average_Score.assessment_name, Max_Score.max_avg from Average_Score
join (select Max(avg_score) as max_avg from Average_Score) as Max_Score on Average_Score.avg_score = Max_Score.max_avg
group by
Average_Score.Assessment_id, Average_Score.avg_score
_____________________________________________________________________________________________________________________________________________________
_____________________________________________________________________________________________________________________________________________________
-- Q19 List Courses Along with Their Modules and Content in Hierarchical Order
-- Retrieve a hierarchical list that shows each course, its modules, and the content items within each module
-- 
SELECT 
courses.course_id,
courses.course_name,
modules.module_id,
modules.module_name,
modules.module_order,
content.content_id,
content.title AS content_title,
content.content_type,
content.url
FROM courses
LEFT JOIN modules
ON modules.course_id = courses.course_id
LEFT JOIN content
ON content.module_id = modules.module_id
ORDER BY courses.course_id, modules.module_order, modules.module_id, content.content_id;
_____________________________________________________________________________________________________________________________________________________
_____________________________________________________________________________________________________________________________________________________
-- Q20 Find the Total Number of Assessments Per Course
-- For each course, count the total number of assessments available by joining courses, modules, and assessments

SELECT 
courses.course_id,
courses.course_name,
COUNT(assessments.assessment_id) AS assessment_count
FROM courses
LEFT JOIN modules
ON modules.course_id = courses.course_id
LEFT JOIN assessments
ON assessments.module_id = modules.module_id
GROUP BY courses.course_id, courses.course_name
ORDER BY courses.course_id;
_____________________________________________________________________________________________________________________________________________________
_____________________________________________________________________________________________________________________________________________________
-- Q21 List All Enrollments from May 2023
-- Retrieve all enrollment records where the enrollment date falls within May 2023

select * 
from enrollments
where
-- enrolled_at between '2023-05-01' and '2023-05-31'
enrolled_at >= '2023-05-01' and enrolled_at < '2023-06-01'
_____________________________________________________________________________________________________________________________________________________
_____________________________________________________________________________________________________________________________________________________
-- Q22 Retrieve Assessment Submission Details Along with Course and Student Information
-- For each assessment submission, display the submission details along with the corresponding course name, student name, and assessment name.

Select 
assessment_submission.submission_id,
assessment_submission.assessment_id,
user.user_id,
concat(first_name,' ',last_name) as Student_name,
courses.course_name,
assessment_submission.submitted_at,
assessment_submission.score,
assessment_submission.submission_data 
from assessment_submission
join user on user.user_id = assessment_submission.user_id
join assessments on assessments.assessment_id = assessment_submission.assessment_id
join modules on modules.module_id = assessments.module_id
join courses on modules.course_id = courses.course_id
order by
assessment_submission.submitted_at, assessment_submission.submission_id
_____________________________________________________________________________________________________________________________________________________
_____________________________________________________________________________________________________________________________________________________
-- Q23 List All Users with Their Roles
-- Retrieve a list of all users showing their full names and roles.
select 
user_id, 
concat(first_name,' ',last_name) as Full_Name, 
role 
from user
order by 
user_id
_____________________________________________________________________________________________________________________________________________________
_____________________________________________________________________________________________________________________________________________________
-- Q24 Find the Percentage of Passing Submissions for Each Assessment
-- Assuming a passing score is 60 or above, calculate the passing percentage for each assessment.
select 
assessment_submission.submission_id,
assessment_submission.assessment_id,
assessment_submission.user_id,
assessments.assessment_name,
concat(round((assessment_submission.score/assessments.max_score)*100),'%') as Passing_percentage
from assessment_submission
join assessments on assessments.assessment_id = assessment_submission.assessment_id
group by
assessment_submission.assessment_id, assessments.assessment_name, assessment_submission.user_id,assessment_submission.submission_id
_____________________________________________________________________________________________________________________________________________________
_____________________________________________________________________________________________________________________________________________________
-- Q25 Find Courses That Do Not Have Any Enrollments
-- List the courses for which there are no enrollment records.

select 
courses.course_id, 
courses.course_name, 
courses.description 
from courses
left join enrollments on enrollments.course_id = courses.course_id
where
enrollments.enrollment_id is Null
order by
courses.course_id