##Nth Highest Salary

    ##MySQL -  join

CREATE FUNCTION getNthHighestSalary(N INT)
RETURNS INT
BEGIN
    RETURN(
        SELECT a.Salary
            FROM Employee a, Employee b
            Where a.Salary <= b.Salary
            GROUP BY a.Salary
            HAVING COUNT(distinct b.Salary) = N
);
END;
    ##MYSQL - limit, offset

CREATE FUNCTION getNthHighestSalary(N INT) RETURNS INT
BEGIN
    SET N = N - 1;
  RETURN (
      
    SELECT t.Salary
      FROM (
        SELECT distinct salary
            FROM Employee 
            ORDER BY salary DESC) t
      LIMIT N, 1
      
  );
END

    ##Window FUNCTION

CREATE FUNCTION getNthHighestSalary(N INT)
RETURNS INT
BEGIN
    RETURN(
        SELECT t.Salary 
            FROM (SELECT Salary, DENSE_RANK() OVER(Order by Salary DESC) as rank
                    FROM Employee ) t
            WHERE rank = N


    );

##178 Rank Scores

## join
SELECT scores.score, t.Rank
FROM scores
    LEFT JOIN 
        (SELECT a.score, COUNT(distinct b.score) as `Rank`
            FROM Scores a, Scores b
            Where a.score <= b.score
            GROUP BY a.score) t
    ON scores.score = t.score
    ORDER BY scores.score DESC;

##window FUNCTION

SELECT score, DENSE_RANK() OVER(ORDER BY score DESC)
FROM Scores;

##185 Department Top Three Salaries

SELECT c.Name as Department, a.Name as Employee, a.Salary
    From Employee a, Employee b, Department c
    Where a.DepartmentID = b.DepartmentID and a.Salary <= b.Salary and a.DepartmentId = c.Id
    GROUP BY a.DepartmentID, a.ID
    HAVING COUNT(distinct b.Salary) <= 3
ORDER BY c.Name, a.Salary DESC, a.Name;


## Trips and Users
SELECT Request_at Day, 
ROUND(1-SUM(CASE WHEN Status = "completed" THEN 1 else 0 END)/COUNT(*),2) As `Cancellation Rate`
FROM Trips a, Users b, Users c
WHERE a.Driver_ID = b.Users_ID AND a.Client_ID = c.Users_ID
    AND b.Banned = "No" AND c.Banned = "No"
    AND a.Request_at BETWEEN "2013-10-01" AND "2013-10-03"
GROUP BY Request_at
ORDER BY Request_at

##181 Employees earning more than managers

    ## Sub-query
select Name as Employee 
from Employee a
where a.Salary > (select salary from employee where id = a.ManagerId)


    ## join
select a.Name as employee
from employee a, employee b
where a.ManagerID = b.Id And b.Salary < a.Salary

##1179 Reformat Department Table
SELECT id
    , MAX(IF(month = "Jan", revenue, NULL)) as Jan_Revenue
    , MAX(IF(month = "Feb", revenue, NULL)) as Feb_Revenue
    , MAX(IF(month = "Mar", revenue, NULL)) as Mar_Revenue
    , MAX(IF(month = "Apr", revenue, NULL)) as Apr_Revenue
    , MAX(IF(month = "May", revenue, NULL)) as May_Revenue
    , MAX(IF(month = "Jun", revenue, NULL)) as Jun_Revenue
    , MAX(IF(month = "Jul", revenue, NULL)) as Jul_Revenue
    , MAX(IF(month = "Aug", revenue, NULL)) as Aug_Revenue
    , MAX(IF(month = "Sep", revenue, NULL)) as Sep_Revenue
    , MAX(IF(month = "Oct", revenue, NULL)) as Oct_Revenue
    , MAX(IF(month = "Nov", revenue, NULL)) as Nov_Revenue
    , MAX(IF(month = "Dec", revenue, NULL)) as Dec_Revenue
from department
GROUP BY id

##1270 All people report to the given manager

select a.employee_id
from Employees a
LEFT JOIN Employees b
ON a.manager_id = b.employee_id
LEFT JOIN Employees c
ON b.manager_id = c.employee_id
LEFT JOIN Employees d
ON c.manager_id = d.employee_id
WHERE d.manager_id = 1 and a.employee_id <> 1

## C626 Exchange Seats
    ##CTE
with t as

(select max(id) as m_id from seat)

SELECT (CASE WHEN id%2 = 1 AND id<m_id THEN id+1
            WHEN id%2 = 0 THEN id-1 
            ELSE id END) AS id, student     
FROM seat, t
ORDER BY id;

    ##Aggretation function in the CASE statement
SELECT (CASE WHEN id%2 = 1 AND id<(select max(id) from seat) THEN id+1
            WHEN id%2 = 0 THEN id-1 
            ELSE id END) AS id, student     
FROM seat
ORDER BY id;

## Consecutive Numbers
select distinct a.Num as ConsecutiveNums
from logs a, logs b, logs c
where a.num = b.num and b.num =c.num
    and a.Id = b.Id - 1 AND b.Id = c.ID -1 


## Department Highest Salary

select b.Name as Department
    , a.name as Employee
    , a.Salary
from Employee a, Department b
where a.departmentid = b.id
and a.Salary = (select max(salary) from employee c 
               where c.departmentid = a.departmentid)
ORDER BY Salary

    ##rank
with t as
(select b.name as Department
    , a.name as Employee
    , a.Salary
    , rank() OVER(PARTITION BY a.departmentid order by Salary DESC) as s_rank
FROM Employee a, Department b
where a.departmentid = b.id)

select Department, Employee, Salary
from t
where s_rank = 1
order by Salary

##615 Average Salary: Department VS Company

# Write your MySQL query statement below

with t as
(select distinct date_format(pay_date, "%Y-%m") as month, round(avg(amount),4) as c_salary
from salary 
group by date_format(pay_date, "%Y-%m"))

select  distinct date_format(a.pay_date, "%Y-%m") as pay_month
    , department_id
    , (case when round(avg(a.amount),4) > t.c_salary then "higher"
            when round(avg(a.amount),4) < t.c_salary then "lower"
            else "same" end) as comparison
from salary a
join employee b
on a.employee_id = b.employee_id
join t
on t.month = date_format(a.pay_date, "%Y-%m")
group by b.department_id, t.month;
















    

