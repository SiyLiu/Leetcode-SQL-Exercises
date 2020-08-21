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
    

