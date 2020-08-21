##601. Human Traffic of Stadium
##Write a query to display the records which have 3 or more consecutive rows and the amount of people more than 100(inclusive). 

select DISTINCT D1.* from docs D1, docs D2, docs D3
where (D1.people>=100 and D2.people>=100 and D3.people>=100)
and ((D2.date-D1.date=1 and D3.date-D2.date = 1) 
    or (D1.date-D2.date =1 and D3.date-D1.date = 1)
     or (D1.date-D2.date = 1 and D2.date-D3.date = 1)
    )
order by D1.id;

##626. Exchange the seat
##
SELECT (CASE   WHEN id%2=1 and id!=max_id THEN id+1
               wHEN id%2=0 THEN id-1
               WHEN id%2=1 and id=max_id THEN id
               END) as id, student
FROM seat, (SELECT count(*) as max_id FROM seat) as B
ORDER by id

##181. Employees earn more than their managers

SELECT E2.name as Employee
FROM Employee E1, Employee E2
WHERE E1.Id = E2.ManagerId and E1.Salary<E2.Salary

#183. Customers Who Never Order

SELECT Name as Customers
FROM Customers
LEFT JOIN Orders
ON Customers.Id = Orders.CustomerId
WHERE isNULL(Orders.Id)

#596. Classes More Than 5 Students
SELECT class 
FROM courses
GROUP BY class
HAVING count(DISTINCT student)>=5

#180. Consecutive Numbers

SELECT DISTINCT n1.Num as ConsecutiveNums
FROM logs n1, logs n2, logs n3
WHERE n2.Num = n1.Num and n1.num = n3.num and ((n2.id-n1.id =1 and n3.id-n2.id = 1) OR (n1.id-n2.id = 1 and n3.id-n1.id = 1) OR (n1.id-n2.id = 1 and n2.id-n3.id = 1))

#176. Second Highest Salary

SELECT IFNULL( (SELECT max(salary) 
FROM (SELECT * from Employee 
     WHERE
      salary!= (SELECT max(salary) FROM Employee)) as A), NULL) as SecondHighestSalary
      
 #184. Department Highest Salary
 
# Write your MySQL query statement below
SELECT D.Name as Department,E.name as Employee, Salary
FROM Employee E 
JOIN Department D
ON E.DepartmentId = D.Id
Where Salary = (Select max(Salary) From Employee E2 Where E2.DepartmentId = E.DepartmentId )
