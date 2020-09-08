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

##1098 Unpopular Books
select distinct a.book_id, a.name
from books a
LEFT JOIN orders b
ON a.book_id = b.book_id
WHERE available_from < "2019-05-23"
GROUP BY a.book_id
HAVING SUM(CASE WHEN  dispatch_date between "2018-06-23" and "2019-06-23" THEN quantity ELSE 0 end) < 10

##1212 Team Scores in Football Tournament

with t as 
(select host_team as team_id,
SUM(CASE WHEN host_goals > guest_goals THEN 3 
     WHEN host_goals < guest_goals THEN 0
     ELSE 1 END) as points
FROM matches
GROUP BY host_team

UNION ALL

select guest_team as team_id,
SUM(CASE WHEN host_goals > guest_goals THEN 0 
      WHEN host_goals < guest_goals THEN 3
      ELSE 1 END) as points
FROM matches
group by guest_team)

select teams.team_id
    , team_name
    , IFNULL(sum(points),0) as num_points
FROM t
RIGHT JOIN teams
ON t.team_id = teams.team_id
GROUP BY teams.team_id
ORDER BY num_points desc, team_id;

##197 Rising Temperature

select a.id
from weather a, weather b
where DATEDIFF(a.recordDate, b.recordDate) = 1
    and a.Temperature > b.Temperature;


##1336 Number of Transactions pre Visit

with t1 as
(select visit_date, user_id, count(*) as num_visits
from visits
group by visit_date, user_id),

t2 as
(select transaction_date, user_id, count(*) as num_tran
from transactions
group by transaction_date, user_id),

t3 as
(SELECT row_number() over () as num_tran
        FROM transactions
 union
 select 0 )

select t3.num_tran as transactions_count, ifnull(visits_count,0) as visits_count

from (
    select ifnull(t2.num_tran,0) as transactions_count, ifnull(sum(num_visits),0) as visits_count
    from t1
        left join t2
        on t1.user_id = t2.user_id 
        and t1.visit_date = t2.transaction_date  
    group by transactions_count) t
    
right join t3
    on t.transactions_count = t3.num_tran
where t3.num_tran <= (select ifnull(max(num_tran),0) from t2)
order by t3.num_tran

;


##1132 Reported Posts

with t as

(select a.action_date, COUNT(distinct b.post_id)/COUNT(distinct a.post_id) as removal_rate

from actions a
left join removals b
on a.post_id = b.post_id

where extra = "spam"

group by a.action_date)
 
 select round(avg(removal_rate) * 100,2) as average_daily_percent
 
 from t

##569 Median Employee Salary
with t as 

	(select Company, COUNT(*) div 2  as half_num_emply from Employee group by company)

select min(Id), Company, Salary from 

	select a.Company, a.Salary
	from Employee a, Employee b
	where a.Company = b.Company and
		a.Salary < b.Salary
	group by a.Id
	having count(b.Id) = (select half_num_emply from t where t.company = b.company)

	union

	select a.Company, a.Salary
	from Employee a, Employee b
	where a.Company = b.Company and
		a.Salary > b.Salary
	group by a.Id
	having count(b.Id) = (select half_num_emply from t where t.company = b.company)

) temp

group by Company, Salary
order by Copmany, Salary

    # Window function

with t as 

(select Id, Company, Salary, 
 Row_number() OVER(Partition by Company Order by Salary DESC, Id DESC) as row_num, Count(1) OVER(Partition by Company) as num_emply

from employee)

select Id, Company, Salary
From t
where (row_num - 1) *2 = num_emply
    OR  row_num = (num_emply + 1) / 2
    OR row_num *2 = num_emply
    
order by Company, Salary


##1127 User Purchase Platform

with t1 as
(select spend_date, user_id, platform, amount
 from spending
 group by spend_date, user_id
 having count(distinct platform) = 1 and platform = "mobile"
),

t2 as
(select spend_date, user_id, platform, amount
 from spending
 group by spend_date, user_id
 having count(distinct platform) = 1 and platform = 'desktop'
),

t3 as
(select spend_date, user_id, "both" as platform, sum(amount) as amount
 from spending
 group by spend_date, user_id
 having count(distinct platform) = 2
),
t4 as
(select * from 
 (select "desktop" as platform, 1 as p_id
union
 select "mobile", 2 as p_id
union 
  select "both", 3 as p_id) tt1,
 (select distinct spend_date from spending ) tt2
 )

select  t4.spend_date, t4.platform, ifnull(sum(amount),0) as total_amount, ifnull(count(distinct user_id),0) as total_users
from 
(select * from t1
union 
select * from t2
union 
select * from t3)t

right join t4
on t.platform = t4.platform and t.spend_date = t4.spend_date

group by t4.spend_date, t4.platform
order by t4.p_id


##1393 Capital Gain/Loss

with t as 
(select *, (case when operation = "Buy" then -1 
                else 1 end) as sign

 from stocks)
 
 select stock_name, sum(price * sign)  as capital_gain_loss
 from t
 group by stock_name
 order by capital_gain_loss DESC


##1142 User Activity for the Past Days LIMIT

select ifnull(round(coalesce(count(distinct session_id),0)/count(distinct user_id),2),0) as average_sessions_per_user
from activity
where activity_date between "2019-06-28" and "2019-07-27"
 
##627 Swap Salary

update salary
set sex = case when sex = "f " then "m"
    else "f" end;


## 1412 Find the quiest students in all exams

with t as 

(select a.student_id, b.student_name, score , min(score) over w as min_score 
    , max(score) over w as max_score
from exam a, student b
where a.student_id = b.student_id
window w as 
(partition by exam_id)
 )
 
 select distinct student_id
    , student_name
from t
where score > min_score and score < max_score
and student_id not in
(select student_id from t where score = max_score
or score = min_score)

order by student_id


##1355 Activity Participants
 #Approach 1


with t as

(select activity, count(1) OVER(partition by activity) as cnt
from friends)

select distinct activity from t
where cnt < (select max(cnt) from t) and cnt > (select min(cnt) from t)

 #Approach 2 (nested aggregation functions with window function)

 with t as

WITH t as
(
SELECT activity, RANK() OVER (ORDER BY count(activity)) `rank`
FROM
Friends
group by activity
)
select activity
FROM
t
where
`rank` > 1
and `rank` < (select max(`rank`) FROM t)


    

