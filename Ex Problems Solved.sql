USE `gringotts`;
/*Problem 1
Records’ Count
-- Import the database and send the total count of records to Mr. Bodrog. 
-- Make sure nothing got lost.*/
SELECT
	COUNT(*) AS 'count' 
FROM
	`wizzard_deposits`;


/*Problem 2
Longest Magic Wand
-- Select the size of the longest magic wand. Rename the new column appropriately.*/
SELECT
	MAX(`magic_wand_size`) AS 'longest_magic_wand'
FROM
	`wizzard_deposits`;


/*Problem 3
Longest Magic Wand per Deposit Groups
-- For wizards in each deposit group show the longest magic wand. Sort result by 
-- longest magic wand for each deposit group in increasing order, then by 
-- deposit_group alphabetically. Rename the new column appropriately.
*/
SELECT
	`deposit_group`, 
    MAX(`magic_wand_size`) AS 'longest_magic_wand'
FROM
	`wizzard_deposits`
GROUP BY 
	`deposit_group`
ORDER BY `longest_magic_wand`, `deposit_group`;


/*Problem 4
Smallest Deposit Group per Magic Wand Size
-- Select the deposit group with the lowest average wand size.*/
SELECT
	`deposit_group`
FROM
	`wizzard_deposits`
GROUP BY
	`deposit_group`
ORDER BY 
	AVG(`magic_wand_size`)
LIMIT 1;


/*Problem 5
Deposits Sum
-- Select all deposit groups and its total deposit sum. 
-- Sort result by total_sum in increasing order.*/
SELECT
	`deposit_group`,
    SUM(`deposit_amount`) AS 'total_sum'
FROM
	`wizzard_deposits`
GROUP BY
	`deposit_group`
ORDER BY `total_sum`;


/*Problem 6
Deposits Sum for Ollivander Family
-- Select all deposit groups and its total deposit sum but only for 
-- the wizards who has their magic wand crafted by Ollivander family. 
-- Sort result by deposit_group alphabetically.*/
SELECT 
    `deposit_group`, 
    SUM(`deposit_amount`) AS 'total_sum'
FROM
    `wizzard_deposits`
WHERE
    `magic_wand_creator` = 'Ollivander family'
GROUP BY `deposit_group`
ORDER BY `deposit_group`;


/*Problem 7
Deposits Filter
-- Select all deposit groups and its total deposit sum but only for 
-- the wizards who has their magic wand crafted by Ollivander family. 
-- After this, filter total deposit sums lower than 150000. 
-- Order by total deposit sum in descending order.*/
SELECT 
    `deposit_group`, 
    SUM(`deposit_amount`) AS 'total_sum'
FROM
    `wizzard_deposits`
WHERE
    `magic_wand_creator` = 'Ollivander family'
GROUP BY `deposit_group`
HAVING `total_sum` < 150000
ORDER BY `total_sum` DESC;


/*Problem 8
Deposit Charge
-- Create a query that selects:
-- •	Deposit group 
-- •	Magic wand creator
-- •	Minimum deposit charge for each group 
-- Group by deposit_group and magic_wand_creator.
-- Select the data in ascending order by magic_wand_creator and deposit_group.*/
SELECT
	`deposit_group`,
    `magic_wand_creator`,
    MIN(`deposit_charge`) AS 'min_deposit_charge'
FROM
	`wizzard_deposits`
GROUP BY `deposit_group`, `magic_wand_creator`
ORDER BY `magic_wand_creator`, `deposit_group`;


/*Problem 9
Age Groups
-- Write down a query that creates 7 different groups based on their age.
-- Age groups should be as follows:
-- •	[0-10]
-- •	[11-20]
-- •	[21-30]
-- •	[31-40]
-- •	[41-50]
-- •	[51-60]
-- •	[61+]
-- The query should return:
-- •	Age groups
-- •	Count of wizards in it
-- Sort result by increasing size of age groups.*/
SELECT 
	(CASE
		WHEN `age` BETWEEN 0 AND 10 THEN '[0-10]'
		WHEN `age` BETWEEN 11 AND 20 THEN '[11-20]'
		WHEN `age` BETWEEN 21 AND 30 THEN '[21-30]'
		WHEN `age` BETWEEN 31 AND 40 THEN '[31-40]'
		WHEN `age` BETWEEN 41 AND 50 THEN '[41-50]'
		WHEN `age` BETWEEN 51 AND 60 THEN '[51-60]'
		ELSE '[61+]'
	END) AS 'age_group', 
    COUNT(`age`)
FROM `wizzard_deposits`
GROUP BY `age_group`
ORDER BY `age_group`;



/*Problem 10
First Letter
-- Write a query that returns all unique wizard first letters of their 
-- first names only if they have deposit of type Troll Chest. 
-- Order them alphabetically. Use GROUP BY for uniqueness.*/
SELECT
	LEFT(`first_name`, 1) AS 'first_letter'
FROM
	`wizzard_deposits`
WHERE 
	`deposit_group` = 'Troll Chest'
GROUP BY `first_letter`;


/*Problem 11
Average Interest
-- Mr. Bodrog is highly interested in profitability. He wants to know the 
-- average interest of all deposits groups split by whether the deposit 
-- has expired or not. But that’s not all. He wants you to select deposits 
-- with start date after 01/01/1985. Order the data descending by 
-- Deposit Group and ascending by Expiration Flag.*/
SELECT
	`deposit_group`, 
    `is_deposit_expired`,
    AVG(`deposit_interest`) AS 'average_interest'
FROM
	`wizzard_deposits`
WHERE
	`deposit_start_date` > '1985-01-01'
GROUP BY `deposit_group`, `is_deposit_expired`
ORDER BY `deposit_group` DESC, `is_deposit_expired`;


/*Problem 12
Rich Wizard, Poor Wizard *
-- Give Mr. Bodrog some data to play his favorite game Rich Wizard, Poor Wizard. 
-- The rules are simple: You compare the deposits of every wizard with the wizard 
-- after him. If a wizard is the last one in the database, simply ignore it. 
-- At the end you have to sum the difference between the deposits:
--
-- host_wizard	host_wizard_deposit	guest_wizard	guest_wizard_deposit	difference	   
-- Harry		10 000				Tom				12 000					-2000	   
-- Tom			12 000				…				…						…	 
--
-- At the end your query should return a single value: the SUM of all differences:
--
-- sum_difference	   
-- 44393.97	 */
SELECT 
    SUM(`hw`.`deposit_amount` - `gw`.`deposit_amount`) AS 'sum_difference'
FROM
    `wizzard_deposits` AS `hw`,
    `wizzard_deposits` AS `gw`
WHERE
    `gw`.`id` - `hw`.`id` = 1;

-- Show details
SELECT 
    `hw`.`first_name` AS 'host_wizard',
    `hw`.`deposit_amount` AS 'host_wizard_deposit',
    `gw`.`first_name` AS 'guest_wizard',
    `gw`.`deposit_amount` AS 'guest_wizard_deposit',
    (`hw`.`deposit_amount` - `gw`.`deposit_amount`) AS 'difference'
FROM
    `wizzard_deposits` AS `hw`, `wizzard_deposits` AS `gw`
WHERE
     `gw`.`id` - `hw`.`id` = 1;
 










/*Problem 13
Employees Minimum Salaries
-- Select the minimum salary from the employees for departments with 
-- ID (2,5,7) but only for those who are hired after 01/01/2000. 
-- Sort result by department_id in ascending order.
-- Your query should return:
-- •	department_id
-- •	minimum_salary*/
USE `soft_unii`;
SELECT
	`department_id`,
    MIN(`salary`) AS 'minimum_salary'
FROM
	`employees`
WHERE 
	`department_id` IN (2,5,7) AND `hire_date` > '2000-01-01'
GROUP BY 
	`department_id`
ORDER BY `department_id`;




/*Problem 14
Employees Average Salaries
-- Select all high paid employees who earn more than 30000 into a new table. 
-- Then delete all high paid employees who have manager_id = 42 from the new table; 
-- Then increase the salaries of all high paid employees with department_id =1 
-- with 5000 in the new table. Finally, select the average salaries in each 
-- department from the new table. Sort result by department_id in increasing order.*/
USE `soft_unii`;
SELECT
	`department_id`,
    (CASE
		WHEN `department_id` = 1 THEN AVG(`salary`) + 5000
        ELSE (`salary`)
    END) AS 'avg_salary'
FROM
	`employees`
WHERE 
	`salary` > 30000 AND `manager_id` != 42
GROUP BY `department_id`
ORDER BY `department_id`, `avg_salary`;




/*Problem 15
Employees Maximum Salaries
-- Find the max salary for each department. Filter those which have max salaries not 
-- in the range 30000 and 70000. Sort result by department_id in increasing order.*/
SELECT
	`department_id`, MAX(`salary`) AS 'max_salary'
FROM
	`employees`
GROUP BY `department_id`
HAVING `max_salary` NOT BETWEEN 30000 AND 70000
ORDER BY `department_id`;



/*Problem 16
Employees Count Salaries
-- Count the salaries of all employees who don’t have a manager.*/
SELECT
	COUNT(`salary`) AS ''
FROM
	`employees`
WHERE
	`manager_id` IS NULL;




/*    Problem 17*   
3rd Highest Salary
-- Find the third highest salary in each department if there is such. 
-- Sort result by department_id in increasing order.*/
SELECT 
    DISTINCT `salary`
FROM
    `employees`
WHERE 		
	`department_id` = 1
ORDER BY `salary` DESC
LIMIT 2, 1;

SELECT 
    e.`department_id`,
    (SELECT DISTINCT
            e2.`salary`
        FROM
            `employees` AS e2
        WHERE
            e2.`department_id` = e.`department_id`
        ORDER BY `salary` DESC
        LIMIT 2 , 1) AS 'ths'
FROM
	`employees` AS e
WHERE 'ths' IS NOT NULL
GROUP BY e.`department_id`
HAVING `ths` IS NOT NULL
ORDER BY `department_id`;



/*    Problem 17*   */
SELECT
	AVG(e2.`salary`) AS 'avg'
FROM 
	`employees` AS e2
WHERE e2.`department_id` = 2
GROUP BY e2.`department_id`;

SELECT
	e.`first_name`, 
    e.`last_name`, 
    e.`department_id`
FROM	
	`employees` AS e
WHERE `salary` > 
	(SELECT
		AVG(e2.`salary`) AS 'avg'
	FROM 
		`employees` AS e2
	WHERE e2.`department_id` = e.`department_id`
	GROUP BY e2.`department_id`)
ORDER BY `department_id`, `employee_id`
LIMIT 10;
    
    
-- 19.	Departments Total Salaries
-- Create a query which shows the total sum of salaries for each department. Order by department_id.
-- Your query should return:	
-- •	department_id
-- •	total_salary

SELECT 
    `department_id`, SUM(`salary`) AS 'total_salary'
FROM
    `employees`
GROUP BY `department_id`
ORDER BY `department_id`;
    
    
    
    
/*Problem 19*/
SELECT
	`department_id`,
	SUM(`salary`) AS 'total_salary'
FROM
	`employees`
GROUP BY `department_id`;    
    
    
    
    