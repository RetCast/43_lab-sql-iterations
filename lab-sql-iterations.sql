#Lab | SQL Iterations
-- In this lab, we will continue working on the Sakila database of movie rentals.

USE sakila;

#Instructions
-- Write queries to answer the following questions:
# 1. Write a query to find what is the total business (amount) done by each store.

SELECT st.store_id, ROUND(SUM(p.amount),2) AS total_sales
FROM payment AS p 
JOIN staff AS sf ON p.staff_id = sf.staff_id
JOIN store AS st ON sf.store_id = st.store_id
GROUP BY 1;

/* 2.Convert the previous query into a stored procedure that takes the input for store_id and displays the total sales for that store.
Declare a variable total_sales_value of float type, that will store the returned result 
(of the total sales amount for the store). Call the stored procedure and print the results*/ 

DROP PROCEDURE IF EXISTS get_total_sales_by_store;
DELIMITER // 
CREATE PROCEDURE get_total_sales_by_store (IN store_id VARCHAR(20), OUT total_sales DECIMAL(10,2))
	BEGIN
		SELECT ROUND(SUM(p.amount),2) INTO total_sales
		FROM payment AS p 
		JOIN staff AS sf ON p.staff_id = sf.staff_id
		JOIN store AS st ON sf.store_id = st.store_id
        WHERE st.store_id = store_id
        GROUP BY st.store_id;
    END //
DELIMITER ;
CALL get_total_sales_by_store('1', @total_sales_store_1);
CALL get_total_sales_by_store('2', @total_sales_store_2);

SELECT @total_sales_store_1;
SELECT @total_sales_store_2;

/* 3. In the previous query, add another variable flag. If the total sales value for the store is over 30.000, then label it as green_flag, 
otherwise label is as red_flag. Update the stored procedure that takes an input as the store_id and returns total sales value for that store and flag value.*/

DROP PROCEDURE IF EXISTS get_total_sales_by_store;
DELIMITER // 
CREATE PROCEDURE get_total_sales_by_store (IN store_id VARCHAR(20), OUT total_sales DECIMAL(10,2), OUT sales_label CHAR(10))
	BEGIN
		DECLARE flag CHAR(10) DEFAULT "";
    
		SELECT ROUND(SUM(p.amount),2) INTO total_sales
		FROM payment AS p 
		JOIN staff AS sf ON p.staff_id = sf.staff_id
		JOIN store AS st ON sf.store_id = st.store_id
        WHERE st.store_id = store_id
        GROUP BY st.store_id;
        
        IF total_sales > 30000 THEN
			SET flag = "green_flag";
		ELSE	
			SET flag = "red_flag";
		END IF;
        
        -- Asignar el valor de flag a sales_label.
        SET sales_label = flag;
    END //
DELIMITER ;

CALL get_total_sales_by_store('1', @total_sales_store_1, @sales_label_store_1);
CALL get_total_sales_by_store('2', @total_sales_store_2, @sales_label_store_2);

SELECT @total_sales_store_1, @sales_label_store_1;
SELECT @total_sales_store_2, @sales_label_store_2;
