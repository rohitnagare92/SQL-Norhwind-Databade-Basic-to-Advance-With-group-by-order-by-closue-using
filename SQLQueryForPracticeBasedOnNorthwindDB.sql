




                         --Queries based on 'NORTHWIND' database



---1- Find the number of orders sent by each shipper.

select s.CompanyName,COUNT(*) Total_Orders
from Orders o
join Shippers s
on o.ShipVia=s.ShipperID
group by s.CompanyName


--2- Find the number of orders sent by each shipper, sent by each employee


select o.ShipName, e.FirstName,COUNT(*) Total_Order
from Orders o
join Employees e 
on o.EmployeeID=e.EmployeeID
group by e.FirstName,o.ShipName

--3- Find  name  of  employees who has registered more than 100 orders.

select e.FirstName+' '+e.LastName,COUNT(*) Total_Order
from Orders o
join Employees e 
on o.EmployeeID=e.EmployeeID
group by e.FirstName+' '+e.LastName
having COUNT(*) >100

--4-Find if the employees "Davolio" or "Fuller" have registered more than 25 orders.

select e.LastName,COUNT(*) Total_Orders
from Orders o
join Employees e
on o.EmployeeID=e.EmployeeID
where e.LastName='fuller'or e.LastName='Davolio'
group by e.LastName

--5-Find the customer_id and name of customers who had placed orders more than one time and how many times they have placed the order

select c.ContactName,COUNT(*) Total_Orders
from Orders o
join Customers c 
on o.CustomerID=c.CustomerID
group by c.ContactName
having COUNT(*)>1

--6-Select all the orders where the employee’s city and order’s ship city are same.


select*
from Orders o
join Employees e on o.EmployeeID=e.EmployeeID
where o.ShipCity=e.City

--7-Create a report that shows the order ids and the associated employee names for orders that shipped after the required date.

select o.OrderID,e.FirstName+' '+e.LastName,o.ShippedDate,o.RequiredDate
from Orders o
join Employees e 
on o.EmployeeID=e.EmployeeID
where o.ShippedDate>o.RequiredDate
--8-Create a report that shows the total quantity of products ordered fewer than 200.

select p.ProductName,sum(od.Quantity) Total_Quantity
from [Order Details] od
join Products p 
on od.ProductID=p.ProductID
group by p.ProductName
having sum(od.Quantity)<200
--9-Create a report that shows the total number of orders by Customer since December 31, 1996 and the NumOfOrders is greater than 15.

select  c.ContactName,count(*) Total_Orders
from Orders o 
join Customers c 
on o.CustomerID=c.CustomerID
where o.OrderDate>31/12/1996
group by c.ContactName
having count(*)>15
--10-Create a report that shows the company name, order id, and total price of all products of which Northwind
-- has sold more than $10,000 worth.

go
with ProductList as
(
select p.ProductName,o.OrderID,s.CompanyName,(od.Quantity*od.UnitPrice)*(1-od.Discount) Sale,ROW_NUMBER() over(partition by p.ProductName order by o.OrderID) Serial_Num
from [Order Details] od
join Products p 
on od.ProductID=p.ProductID
join Orders o 
on od.OrderID=o.OrderID
join Suppliers s 
on p.SupplierID=s.SupplierID
),
SalesList as
(
	select pl.ProductName,sum(pl.Sale)Total_Sale
	from ProductList pl
	group by pl.ProductName
)

select pl.ProductName,pl.OrderID,sl.Total_Sale,pl.CompanyName,pl.Serial_Num
from ProductList pl
join SalesList sl 
on pl.ProductName=sl.ProductName
where sl.Total_Sale>10000

--11-Create a report showing the Order ID, the name of the company that placed the order,
--and the first and last name of the associated employee. Only show orders placed after January 1, 1998 
--that shipped after they were required. Sort by Company Name.

select o.OrderID,c.CompanyName,e.FirstName+' '+e.LastName Emp_Name,o.OrderDate
from Orders o
join Customers c 
on o.CustomerID=c.CustomerID
join Employees e 
on o.EmployeeID=e.EmployeeID
where o.OrderDate>1/1/1998 
order by 2 
--12-Get the phone numbers of all shippers, customers, and suppliers

select  sh.Phone Shipper_Phone, c.Phone Customer_Phone,sp.Phone Supplier_Phone
from [Order Details] od
join Orders o 
on od.OrderID=o.OrderID
join Products p 
on od.ProductID=p.ProductID
join Suppliers sp 
on p.SupplierID=sp.SupplierID
join Shippers sh 
on o.ShipVia=sh.ShipperID
join Customers c 
on o.CustomerID=c.CustomerID

--13-Create a report showing the contact name and phone numbers for all employees,customers, and suppliers.

select c.ContactName,e.FirstName,s.ContactName,c.Phone,e.HomePhone,s.Phone
from [Order Details] od
join Orders o 
on od.OrderID=o.OrderID
join Products p 
on od.ProductID=p.ProductID
join Employees e 
on o.EmployeeID=e.EmployeeID
join Customers c 
on o.CustomerID=c.CustomerID
join Suppliers s 
on p.SupplierID=s.SupplierID
--14-Fetch all the orders for a given customer’s phone number 030-0074321.

select*
from Orders o
join Customers c 
on o.CustomerID=c.CustomerID
where c.Phone='030-0074321'

--15-Fetch all the products which are available under Category ‘Seafood’.

select p.ProductName,c.CategoryName
from Products p
join Categories c 
on p.CategoryID=c.CategoryID
where c.CategoryName='Seafood'

--16-Fetch all the products which are supplied by a company called ‘Pavlova, Ltd.’


select p.ProductName,s.CompanyName
from Products p
join Suppliers s 
on p.SupplierID=s.SupplierID
where s.CompanyName='Pavlova, Ltd.'

--17-All orders placed by the customers belong to London city.

select o.*,c.City
from Orders o
join Customers c 
on o.CustomerID=c.CustomerID
where c.City='London'

--18-All orders placed by the customers not belong to London city.

select o.*,c.City
from Orders o
join Customers c 
on o.CustomerID=c.CustomerID
--19-All the orders placed for the product Chai.

select od.*,p.ProductName
from [Order Details] od
join Products p 
on od.ProductID=p.ProductID
where p.ProductName='Chai'
--20-Find the name of the company that placed order 10290.

select c.CompanyName,o.OrderID
from Orders o
join Customers c 
on c.CustomerID=o.CustomerID
where o.OrderID=10290

--21-Find the Companies that placed orders in 1997

select distinct c.CompanyName, year(o.OrderDate) 
from Orders o
join Customers c 
on c.CustomerID=o.CustomerID
where YEAR(o.OrderDate)=1997

--22-Get the product name , count of orders processed 

 select p.ProductName,COUNT(*) Total_Orders
 from [Order Details] od
 join Products p 
 on od.ProductID=p.ProductID
 group by p.ProductName

--23-Get the top 3 products which has more orders

select top 3 p.ProductName,COUNT(*) Total_Orders
 from [Order Details] od
 join Products p 
 on od.ProductID=p.ProductID
 group by p.ProductName
 order by 2 desc
--24-Get the list of employees who processed the order “chai”

select distinct e.FirstName+' '+e.LastName Emp_Name
from [Order Details] od
join Products p 
on od.ProductID=p.ProductID
join Orders o 
on od.OrderID=o.OrderID
join Employees e 
on o.EmployeeID=e.EmployeeID
where p.ProductName='Chai'
--25-Get the shipper company who processed the order categories “Seafood” 

select distinct s.CompanyName,c.CategoryName
from Orders o
join [Order Details] od 
on o.OrderID=od.OrderID
join Products p 
on od.ProductID=p.ProductID
join Categories c 
on p.CategoryID=c.CategoryID
join Shippers s 
on o.ShipVia=s.ShipperID
where c.CategoryName='Seafood'

--26-Get category name , count of orders processed by the USA employees 

select c.CategoryName ,e.Country, count(*) No_of_Orders
from Orders o
join [Order Details] od 
on o.OrderID=od.OrderID
join Products p 
on od.ProductID=p.ProductID
join Categories c 
on p.CategoryID=c.CategoryID
join Employees e 
on o.EmployeeID=e.EmployeeID
where e.Country='USA'
group by  c.CategoryName ,e.Country

--27-Select CategoryName and Description from the Categories table sorted by CategoryName.

select CategoryName,Description
from Categories
order by 1 asc

--28-Select ContactName, CompanyName, ContactTitle, and Phone from the Customers table sorted byPhone.

select ContactName,CompanyName,ContactTitle,Phone
from Customers
order by 4 asc

--29-Create a report showing employees' first and last names and hire dates sorted from newest to oldest employee
--30-Create a report showing Northwind's orders sorted by Freight from most expensive to cheapest. Show OrderID, 
--OrderDate, ShippedDate, CustomerID, and Freight

select o.OrderID,o.OrderDate,o.ShippedDate,c.CustomerID,o.Freight
from Orders o 
join Customers c 
on o.CustomerID = c.CustomerID
order by 5 desc

--31-Select CompanyName, Fax, Phone, HomePage and Country from the Suppliers table sorted by Country in descending 
--order and then by CompanyName in ascending order

select CompanyName,Fax,Phone,HomePage,Country
from Suppliers
order by 5 desc,1

--32-Create a report showing all the company names and contact names of Northwind's customers in Buenos Aires

select c.CompanyName,c.ContactName
from Customers c
where c.City='Buenos Aires'

--33-Create a report showing the product name, unit price and quantity per unit of all products that are out of stock

select p.ProductName,p.UnitPrice,p.QuantityPerUnit
from Products p
where p.UnitsInStock<p.UnitsOnOrder
--34-Create a report showing the order date, shipped date, customer id, and freight of all orders placed on May 19, 1997

select o.OrderDate,o.ShippedDate,o.CustomerID,o.Freight
from Orders o
where year(o.OrderDate)=1997 and MONTH(o.OrderDate)=5 and DAY(o.OrderDate)=19

--35-Create a report showing the first name, last name, and country of all employees not in the United States.

select e.FirstName,e.LastName,e.Country
from Employees e
where e.Country not in ('USA')
--36-Create a report that shows the city, company name, and contact name of all customers who are in cities that begin with "A" or "B."

select c.City,c.CompanyName,c.ContactName
from Customers c
where c.City like ('A%') or c.City like ('B%')
order by 1
--37-Create a report that shows all orders that have a freight cost of more than $500.00.

select o.*
from Orders o
where o.Freight>500
--38-Create a report that shows the product name, units in stock, units on order, and reorder level of all
-- products that are up for reorder

--39-Create a report that shows the company name, contact name and fax number of all customers that have a fax number.

select c.CompanyName,c.ContactName,c.Fax
from Customers c
where c.Fax is not null
--40-Create a report that shows the first and last name of all employees who do not report to anybody

select e.FirstName,e.LastName
from Employees e
where e.ReportsTo is null
--41-Create a report that shows the company name, contact name and fax number of all customers that have a fax number, 
--Sort by company name.

select c.CompanyName,c.ContactName,c.Fax
from Customers c
where c.Fax is not null
order by 1
--42-Create a report that shows the city, company name, and contact name of all customers who are in cities 
--that begin with "A" or "B." Sort by contact name in descending order

select c.City,c.CompanyName,c.ContactName
from Customers c
where c.City like ('A%') or c.City like ('B%')
order by 2 desc 
--43-Create a report that shows the first and last names and birth date of all employees born in the 1950s

select e.FirstName,e.LastName,e.BirthDate
from Employees e
where year(e.BirthDate)>=1950 and year(e.BirthDate)<=1959
--44-Create a report that shows the shipping postal code, order id, and order date for all orders with a ship postal code 
--beginning with "02389".

select o.ShipPostalCode,o.OrderID,o.OrderDate
from Orders o
where o.ShipPostalCode like ('02389%')
--45-Create a report that shows the contact name and title and the company name for all customers whose contact title
-- does not contain the word "Sales".

select c.ContactName,c.ContactTitle,c.CompanyName
from Customers c
where c.ContactTitle not like ('%Sales%')
--46-Create a report that shows the first and last names and cities of employees from cities other than Seattle
-- in the state of Washington.

select e.FirstName,e.LastName,e.City
from Employees e
where e.City not in ('Seattle')
--47-Create a report that shows the company name, contact title, city and country of all customers in Mexico 
--or in any city in Spain except Madrid.

select c.CompanyName,c.ContactTitle,c.City,c.Country
from Customers c
where c.Country in('Mexico','Spain') and c.City not in ('Madrid')
--48-List of Employees along with the Manager

select e.FirstName+' '+e.LastName Employee_Name,emp.FirstName+' '+emp.LastName
from Employees e
left join Employees emp 
on e.ReportsTo=emp.EmployeeID
--49-List of Employees along with the Manager and his/her title

select e.FirstName+' '+e.LastName Employee_Name,emp.FirstName+' '+emp.LastName Manager_Name,emp.Title
from Employees e
join Employees emp 
on e.ReportsTo=emp.EmployeeID
--50-Provide Agerage Sales per order

select od.OrderID,sum((od.UnitPrice*od.Quantity)*(1-od.Discount)) Sales
from [Order Details] od
group by od.OrderID
--51-Employee wise Agerage Freight

select e.FirstName+' '+e.LastName Emp_Name,sum(o.Freight) Total_Freight
from Orders o
join Employees e 
on o.EmployeeID=e.EmployeeID
group by e.FirstName+' '+e.LastName 
--52-Agerage Freight per employee

select e.FirstName+' '+e.LastName Emp_Name,sum(o.Freight) Total_Freight
from Orders o
join Employees e 
on o.EmployeeID=e.EmployeeID
group by e.FirstName+' '+e.LastName 

--53-Average no. of orders per customer

go
with CustomerList as
(
select c.ContactName,count(*) Total_Orders
from [Order Details] od
join Orders o 
on od.OrderID=o.OrderID
join Customers c 
on o.CustomerID=c.CustomerID
group by  c.ContactName
)
select AVG(cl.Total_Orders) Average_Order
from CustomerList cl

--54-AverageSales per product within Category


--55-PoductName which have more than 100 no.of UnitsinStock

select ProductName,UnitsInStock
from Products
where UnitsInStock>100

--56-Query to Provide Product Name and Sales Amount for Category Beverages

select p.ProductName,c.CategoryName,Sum((od.UnitPrice*od.Quantity)*(1-od.Discount) )Sales
from [Order Details] od
join Products p 
on od.ProductID=p.ProductID
join Categories c 
on p.CategoryID=c.CategoryID
where c.CategoryName='Beverages'
group by p.ProductName,c.CategoryName

--57-Query That Will Give  CategoryWise Yearwise number of Orders

select  distinct c.CategoryName,YEAR(o.OrderDate) YearWise,count(*) Total_Orders
from [Order Details] od 
join Products p 
on od.ProductID=p.ProductID
join Categories c 
on p.CategoryID=c.CategoryID
join Orders o 
on o.OrderID=od.OrderID
group by c.CategoryName,YEAR(o.OrderDate)

--58-Query to Get ShipperWise employeewise Total Freight for shipped year 1997

select o.ShipName,e.FirstName,Sum(o.Freight) Total_Freight
from Orders o
join Employees e 
on o.EmployeeID=e.EmployeeID
where year(o.OrderDate)=1997
group by  o.ShipName,e.FirstName

--59-Query That Gives Employee Full Name, Territory Description and Region Description

select  e.FirstName+' '+e.LastName,t.TerritoryDescription, r.RegionDescription
from Employees e
join EmployeeTerritories et 
on e.EmployeeID=et.EmployeeID
join Territories t 
on et.TerritoryID=t.TerritoryID
join Region r 
on t.RegionID=r.RegionID

--60-Query That Will Give Managerwise Total Sales for each year 

select  emp.FirstName+' '+emp.LastName Manager_name,Sum((od.UnitPrice*od.Quantity)*(1-od.Discount) )Sales
,YEAR(o.OrderDate) YearWise
from Employees e
join Employees emp 
on e.ReportsTo=emp.EmployeeID
join Orders o 
on emp.EmployeeID=o.EmployeeID
join [Order Details] od 
on o.OrderID=od.OrderID
group by emp.FirstName+' '+emp.LastName,YEAR(o.OrderDate)

--61-Names of customers to whom we are sellinng less than average sales per cusotmer

go
with CustList as
(
select c.ContactName,sum((od.Quantity*od.UnitPrice)*(1-od.Discount))Total_Sales
from [Order Details] od
join Orders o 
on od.OrderID=o.OrderID
join Customers c 
on o.CustomerID=c.CustomerID
group by c.ContactName
),
Avg_Sales as 
(
	select AVG(cl.Total_Sales)Avg_Sales
	from CustList cl
)
select cl.ContactName,cl.Total_Sales,aas.Avg_Sales
from Avg_Sales aas
cross join CustList cl
where aas.Avg_Sales>cl.Total_Sales
--62-Query That Gives Average Freight Per Employee and Average Freight Per Customer

select e.FirstName,c.ContactName,AVG(o.Freight) Avg_Freight1
from Orders o
join Employees e 
on e.EmployeeID=o.EmployeeID
join Customers c 
on c.CustomerID=o.CustomerID
group by e.FirstName,c.ContactName
order by 2
--63-Query That Gives Category Wise Total Sale Where Category Total Sale < the Average Sale Per Category

go 
with ProductList as
(
select c.CategoryName,sum((od.Quantity*od.UnitPrice)*(1-od.Discount)) Total_Sales
from [Order Details] od
join Products p 
on od.ProductID=p.ProductID
join Categories c 
on p.CategoryID=c.CategoryID
group by c.CategoryName
),
Prod_AvgList as
(
	select avg(pl.Total_Sales) Average_Sales
	from ProductList pl
)
select pl.CategoryName,pl.Total_Sales,pal.Average_Sales
from Prod_AvgList pal
cross join ProductList pl 
where pl.Total_Sales<pal.Average_Sales
--64-Query That Provides Month No and Month OF Total Sales < Average Sale for Month for Year 1997

go
with MonthsList as
(
select MONTH(o.OrderDate)Months,sum((od.Quantity*od.UnitPrice)*(1-od.Discount)) Total_Sales
from [Order Details] od
join Orders o 
on od.OrderID=o.OrderID
where YEAR(o.OrderDate)=1997
group by MONTH(o.OrderDate)
),
Avg_Sale as
(
	select AVG(Total_Sales) Average_Sales
	from MonthsList ml
)
select ml.Months,ml.Total_Sales,aas.Average_Sales
from Avg_Sale aas
cross join MonthsList ml
where ml.Total_Sales<aas.Average_Sales
--65-Find out the contribution of each employee towards the total sales done by Northwind for selected year

go 
with Emp_Sales as
(
select e.FirstName+' '+e.LastName Emp_Name,Sum((od.UnitPrice*od.Quantity)*(1-od.Discount)) Sales,YEAR(o.OrderDate)Years
from Orders o
join [Order Details] od 
on o.OrderID=od.OrderID
join Employees e 
on o.EmployeeID=e.EmployeeID

group by  e.FirstName+' '+e.LastName,YEAR(o.OrderDate)
),
Total_Sale as
(
	select sum(es.Sales)Total_Sales
	from Emp_Sales es
)
select es.Emp_Name,((es.Sales/ts.Total_Sales)*100) Contribution,ts.Total_Sales,es.Years
from Total_Sale ts
cross join Emp_Sales es
where es.Years=1997
--66-Give the Customer names that contribute 80% of the total sale done by Northwind for given year

go 
with CustList as
(
select  c.ContactName,sum((od.Quantity*od.UnitPrice)*(1-od.Discount))Sales,year(o.OrderDate)Years
from [Order Details] od
join Orders o 
on od.OrderID=o.OrderID
right join Customers c 
on o.CustomerID=c.CustomerID
group by c.ContactName,year(o.OrderDate)
),
Total_Sale as
(
	select sum(es.Sales)Total_Sales
	from CustList es
),
SalesList as
(
select cl.ContactName,ts.Total_Sales,cl.Sales,((cl.Sales/ts.Total_Sales)*100)Contribution,cl.Years
from Total_Sale ts
cross join CustList cl
)
select sl.ContactName,sl.Contribution,sl.Sales,sl.Total_Sales,sl.Years
from SalesList sl
where sl.Years=1997 and sl.Contribution>20
--67-Top 3 performing employees by freight cost for given year

select top 3 e.FirstName+' '+e.LastName,sum(o.Freight)
from Orders o
join Employees e 
on o.EmployeeID=e.EmployeeID
group by e.FirstName+' '+e.LastName
order by 2 desc

--68-Find the bottom 5 customers per product based on Sales Amount

go
With Astar as
(
select  p.ProductName,c.ContactName,Sum((od.UnitPrice*od.Quantity)*(1-od.Discount))Sale
,ROW_NUMBER() over(partition by p.ProductName order by Sum((od.UnitPrice*od.Quantity)*(1-od.Discount)) asc)Serial_Num
from [Order Details] od
join Orders o 
on od.OrderID=o.OrderID
join Customers c 
on o.CustomerID=c.CustomerID
join Products p 
on od.ProductID=p.ProductID
group by  p.ProductName,c.ContactName
)
select a.*
from Astar a
where a.Serial_Num<6


--69-Display first and the last row of the table

go
with Emp_first as
(
select top 1*
from Employees
),
Emp_last as
(
select top 1*
from Employees e
order by 1 desc
)

select ef.*,el.*
from Emp_first ef
cross join Emp_last el
--70-Display employee doing highest sale and lowest sale in each year

go
with Emp_List as
(
select e.FirstName+' '+e.LastName Emp_Name,sum((od.UnitPrice*od.Quantity)*(1-od.Discount)) Sale,o.OrderDate
from [Order Details] od
join Orders o 
on od.OrderID=o.OrderID
join Employees e 
on o.EmployeeID=e.EmployeeID
group by e.FirstName+' '+e.LastName,o.OrderDate 
),
Lowest as
(
select el.Emp_Name,el.Sale,YEAR(el.OrderDate) Years,ROW_NUMBER() over (partition by YEAR(el.OrderDate) order by el.Sale asc) Serial_Num
from Emp_List el
),
Highest as
(
select el.Emp_Name,el.Sale,YEAR(el.OrderDate) Years,ROW_NUMBER() over (partition by YEAR(el.OrderDate) order by el.Sale desc) Serial_Num
from Emp_List el
),
Low as
(
select  distinct l.Years,l.Emp_Name,l.Sale Lowest_Sale,l.Serial_Num
from Lowest l
join Highest h 
on l.Emp_Name=h.Emp_Name
join Emp_List el 
on h.Emp_Name=el.Emp_Name
where l.Serial_Num=1

),
High as
(
select  distinct h.Years,h.Emp_Name,h.Sale Highest_Sale,h.Serial_Num
from Lowest l
join Highest h 
on l.Emp_Name=h.Emp_Name
join Emp_List el 
on h.Emp_Name=el.Emp_Name
where h.Serial_Num=1

)
select l.Years,l.Emp_Name,l.Lowest_Sale,h.Emp_Name,h.Highest_Sale
from Low l
join High h 
on l.Years=h.Years
order by l.Years asc
--71-Top 3 products of each employee by sales for given year

go 
with Emp_List as
(
select p.ProductName, e.FirstName+' '+e.LastName Emp_Name,sum((od.UnitPrice*od.Quantity)*(1-od.Discount)) Sale
from [Order Details] od 
join Orders o 
on od.OrderID=o.OrderID
join Employees e 
on o.EmployeeID=e.EmployeeID
join Products p 
on od.ProductID=p.ProductID
group by  e.FirstName+' '+e.LastName,p.ProductName
),


