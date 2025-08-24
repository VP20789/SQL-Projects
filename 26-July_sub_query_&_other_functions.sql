use sakila;
SELECT * FROM actor
where sakila.actor.first_name = 'P%'

use hr;
select employee.employee_id, employee.first_name, dependents.dependdents_id, dependents.first_name  from employees right outer join dependents on employees.employee_id = dependents.dependents_id;

USE hr
#fetch list of all employees with their depeartment name
#find out the relationship
#cardinality
#identify pf & FK in both the files

USE hr;
Select employees.employee_id, employees.first_name, jobs.job_title from employees left outer join jobs on employees.job_id = jobs.job_id;
select min(employees.salary) from employees;

select * from employees;
select avg(salary) from employees;

select count(manager_id) from employees;

select department_id, avg(salary) from employees group by employees.department_id
having avg(salary)>7000

#find no. of reportees for each manager
select manager_id, count(employee_id) from employees group by manager_id;

#count of dependents from each employee
select employees.first_name, count(dependents.dependent_id) from employees join dependents on dependents.employee_id = employees.employee_id group by employees.first_name

#count of department's max salary
select department_id, max(salary) from employees group by department_id;

#average salary for each department group by department name

# Select execution order:
#From->Where->Group by->Having->Select->Order by->limit->offset


USE HR;

Select employees.employee_id, employees.first_name, employees.last_name, departments.department_name, departments.department_idfrom employees
join employees on employees.department_id = departments.department_id where departments.department_name = "Accounting";

select country_id, country_name from countries
where
region_id = (select region_id from regions where region_name = "Europe");












# Valid places where subquery can be placed/executed: Where; Select; from; having;
#VVIMP

select first_name, last_name, salary, dept_salary.avg_salary from employees
inner join (select department_id, avg(salary) as avg_salary from employees group by department_id) as dept_salary
on employees.department_id = dept_salary.department_id
where employees.salary > dept_salary.avg_salary;

#find department id, name where count of employees are higher than Avg(no. of employees) from each dept.

select employees.department_id, count(employees.employee_id), departments.department_name
from employees  inner join departments
on employees.department_id = departments.department_id
group by employees.department_id
having count(employees.employee_id) > (select Avg(count_emp)
				from (select department_id, count(employee_id) as count_emp
				from employees
                group by department_id) as dept_count);
                

#fetch list of employees and related department name
select employee_id, first_name, last_name, (select department_name from departments where departments.department_id = employees.department_id)
from employees;

use sakila;
select * from payment;

#select query can allow you to do mathematical functions and create temporary column as a calculation result
select amount as old_amount, round(amount + (amount * 0.1),2) as new_amount from payment;

#ceil will round up to higher no. i.e. 2.99 will be 3
#floor will round up to lower no. i.e. 2.99 will be 2
select amount, ceil(amount), floor(amount) from payment;

#pow will show raised to value & sqrt will show suuare root of perticular nos.
select amount, round(pow(amount,3),5), round(sqrt(amount),5) from payment;

#Modulo operator: shows Remainder i.e. 10 % 3 = 1
select amount, mod(amount,2) from payment;

#ROUND funtion will add 0's into the decimal point unlike ROUND function
select amount, format(amount,0), format(amount,1), format(amount,2), format(amount,3), format(amount,4) from payment;

select lower(first_name) from customer;
#CONCAT
select first_name, last_name, concat(customer_id," -> ",first_name," ",last_name)as Full_Name from customer;

#SUB STRING---> Extract  a part of data from column

select first_name, substring(first_name,1,7) from actor;

#TRIM() will remove extra spaces from word, column name etc.
#LTRIM() will remove all the spaces from left side of the word
#RTRIM() will remove all the spaces from right side of the word

#Replace() function will allow you to replace the part of your string
Select first_name, replace(first_name, "N", "vai") from actor;

#FETCH SYSTEM/SERVER DATA, TIME

SELECT NOW() as current_date_time, curdate() as date, curtime() as time;

#extract year, month & day as well as hour, minute & second from existing column
select last_update, year(last_update), month(last_update), day(last_update) from actor;
select last_update, hour(last_update), minute(last_update), second(last_update) from actor;

#date_format() %d indicate DD, %m indicate MM & %y indicate YY & %Y indicate YYYY

select last_update, date_format(last_update,"%d %m %y") from actor;

#date_format() %D, %M & %Y indicate day'th', month in words & YYYY accordingly i.e. 15th February 2006
select last_update, date_format(last_update,"%D %M %Y") from actor;

select last_update, date_format(last_update, "%D %M %Y ||| TIME ON: %hh :%im :%ss") from actor;

#Day, name & Weekday
select last_update, dayname(last_update), weekday(last_update) from actor;

#DATE_ADD() to add the date
#DATE_SUB() to minus the date

select last_update, date_add(last_update, interval 10 year) from actor;
select last_update, date_add(last_update, interval 10 month) from actor;
select last_update, date_add(last_update, interval 3 day) from actor;

select last_update, date_sub(last_update, interval 6 year) from actor;
select last_update, date_sub(last_update, interval 1 month) from actor;
select last_update, date_sub(last_update, interval 10 day) from actor;

#datediff() WILL GIVE THE OUTPUT IN DAYS AND WILL CALCULATE THE DIFFERENCE  BETWEEN 2 DATES
SELECT LAST_UPDATE, datediff(CURDATE(), LAST_UPDATE) FROM ACTOR;

#TIMESTAMPDIFF() WILL ALLOW YOU TO GET THE OUTPUT IN DAYS OR MONTHS OR YEARS
SELECT LAST_UPDATE, timestampdiff(YEAR,LAST_UPDATE, CURDATE()) FROM ACTOR;

#INDEXES & VIEWS
#INDEX : INDEXING WILL ALWAYS BE DONE ON PROMARY KEY COLUMNS;

#VIEW:
#SMALL WINDOW TO YOUR DB
use hr;
CREATE VIEW AVERAGE_PAYMENT AS SELECT AMOUNT, AVG(AMOUNT) FROM PAYMENT;
SELECT * FROM AVERAGE_PAYMENT;

drop view average_payment;


