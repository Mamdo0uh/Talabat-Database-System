use Talabat
--QUERIES WITH INSIGHTS
-- 1 Total revenue by restaurant
SELECT r.name, SUM(od.unit_price * od.quantity) AS Total_Sales
FROM Restaurants r
JOIN Orders o ON r.res_id = o.res_id
JOIN Order_Details od ON o.order_id = od.order_id
GROUP BY r.name
ORDER BY Total_Sales DESC;

-- 2 Top 5 items by quantity
SELECT TOP 5 m.name, SUM(od.quantity) AS Times_Ordered
FROM Menu_items m
JOIN Order_Details od ON m.item_id = od.item_id
GROUP BY m.name
ORDER BY Times_Ordered DESC;

-- 3 Top 5 customers(VIPs)
SELECT TOP 5 c.name, SUM(od.unit_price * od.quantity) AS Total_Spent
FROM Customers c
JOIN Orders o ON c.customer_id = o.customer_id
JOIN Order_Details od ON o.order_id = od.order_id
GROUP BY c.name
ORDER BY Total_Spent DESC;

-- 4 successfully delivered orders per driver
SELECT d.driver_id, d.license_plate, COUNT(o.order_id) AS Total_Deliveries
FROM Drivers d
JOIN Orders o ON d.driver_id = o.del_id
WHERE o.status = 'delivered'
GROUP BY d.driver_id, d.license_plate;

-- 5 Average Order Value (AOV)
SELECT AVG(OrderTotal) AS Global_Average_Order_Value
FROM (
    SELECT o.order_id, SUM(od.unit_price * od.quantity) AS OrderTotal
    FROM Orders o
    JOIN Order_Details od ON o.order_id = od.order_id
    GROUP BY o.order_id
) AS SubQuery;

-- 6 items that have never been ordered
SELECT m.name AS Unsold_Item
FROM Menu_items m
LEFT JOIN Order_Details od ON m.item_id = od.item_id
WHERE od.item_id IS NULL;

-- 7 active branches per location
SELECT location, COUNT(bran_id) AS Active_Branches
FROM Branches
WHERE is_active = 'YES'
GROUP BY location;

-- 8 restaurants with a menu (more than 5 items)
SELECT cat.name AS Category_Name, COUNT(ic.item_id) AS Item_Count
FROM Categories cat
JOIN Items_Cat ic ON cat.cat_id = ic.cat_id
GROUP BY cat.name;

-- 9 orders by their current status
SELECT status, COUNT(order_id) AS Total_Orders
FROM Orders
GROUP BY status;

-- 10 peak days
SELECT DATENAME(dw, created_at) AS Day_Name, COUNT(order_id) AS Order_Count
FROM Orders
GROUP BY DATENAME(dw, created_at)
ORDER BY Order_Count DESC;

-- 11 percentage of orders with coupons
SELECT 
    (SELECT COUNT(*) FROM Coupons WHERE cop_id IS NOT NULL) * 100.0 / 
    NULLIF((SELECT COUNT(*) FROM Orders), 0)AS Coupon_Usage_Percentage;

-- 12 most expensive item for each restaurant
SELECT TOP 3 name, base_price 
FROM Menu_items 
ORDER BY base_price DESC;

-- 13 Count drivers using vehicle( Motorcycle)
SELECT COUNT(*) AS Halawa_Drivers
FROM Drivers
WHERE vechile_type LIKE '%Motorcycle%';

-- 14 customers located in(Maadi)
SELECT name
FROM Customers
WHERE customer_id IN (SELECT customer_id FROM Addresses WHERE city = 'Maadi');

-- 15 restaurants(Bottom 3 by revenue)
SELECT TOP 3 r.name, SUM(od.unit_price * od.quantity) AS Total_Revenue
FROM Restaurants r
JOIN Orders o ON r.res_id = o.res_id
JOIN Order_Details od ON o.order_id = od.order_id
GROUP BY r.name
ORDER BY Total_Revenue ASC;

-- 16 items above 45 EGP
SELECT name, base_price FROM Menu_items WHERE base_price > 45;

-- 17 number of orders by each customer
SELECT c.name, COUNT(o.order_id) AS Orders_Count
FROM Customers c
LEFT JOIN Orders o ON c.customer_id = o.customer_id
GROUP BY c.name
ORDER BY Orders_Count DESC;

-- 18 restaurants with inactive branches
SELECT DISTINCT r.name
FROM Restaurants r
JOIN Branches b ON r.res_id = b.res_id
WHERE b.is_active = 'NO';

-- 19 Total number of individual food units sold per restaurant
SELECT r.name, SUM(od.quantity) AS Total_Units_Sold
FROM Restaurants r
JOIN Orders o ON r.res_id = o.res_id
JOIN Order_Details od ON o.order_id = od.order_id
GROUP BY r.name;

-- 20 Monthly revenue
SELECT MONTH(created_at) AS Month_Num, SUM(od.unit_price * od.quantity) AS Monthly_Revenue
FROM Orders o
JOIN Order_Details od ON o.order_id = od.order_id
GROUP BY MONTH(created_at)
ORDER BY Month_Num;