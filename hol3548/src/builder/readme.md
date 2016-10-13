TM1 SDK HOL - TM1 REST API Tutorial - from data to insights

STEPS:
 - Building the model
 - Loading the data (with the REST API, could have used a TI here too, maybe show both?)
 - Querying the resulting model with the REST API
 - Putting a, REST API based, UI on top of it (using Canvas for TM1)

EXPLORE THE DATA, we'll create a simple cube with the data from the orders in the Northwind database
 - Take a look at what's available in the Northwind database by taking a look at the metadata: http://services.odata.org/V4/Northwind/Northwind.svc/$metadata
 - Products by Product Category: http://services.odata.org/V4/Northwind/Northwind.svc/Categories?$select=CategoryID,CategoryName&$orderby=CategoryName&$expand=Products($select=ProductID,ProductName;$orderby=ProductName)
 - Customers by Country, Region and City: http://services.odata.org/V4/Northwind/Northwind.svc/Customers?$orderby=Country%20asc,Region%20asc,%20City%20asc&$select=CustomerID,CompanyName,City,Region,Country
 - Employees by Country, Region and City: http://services.odata.org/V4/Northwind/Northwind.svc/Employees?$select=EmployeeID,LastName,FirstName,TitleOfCourtesy,City,Region,Country&$orderby=Country%20asc,Region%20asc,City%20asc 
 - Time span in the orders by looking at the first and last order dates:
   First: http://services.odata.org/V4/Northwind/Northwind.svc/Orders?$select=OrderDate&$orderby=OrderDate%20asc&$top=1
   Last: http://services.odata.org/V4/Northwind/Northwind.svc/Orders?$select=OrderDate&$orderby=OrderDate%20desc&$top=1
 - The orders, our data: http://services.odata.org/V4/Northwind/Northwind.svc/Orders?$select=CustomerID,EmployeeID,OrderDate&$expand=Order_Details($select=ProductID,UnitPrice,Quantity)
 
BUILDING THE MODEL (using Northwind sample database hosted on the odata.org website, queried using OData)
 - Create a data folder for the new model
 - Create the tm1s.cfg file with our desired Server name and HTTP port number
 - Start the new TM1 server
 
 
 
 
 
 
 
 =============
 ? Create user/user group and set security?
 * Use of Golang is just as an example, it's not the most efficient code but kept this way for simplicity.