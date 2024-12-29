CREATE DATABASE TENANT;
USE TENANT;
select * from profiles;
select * from houses;
select * from Employee_Details;
select * from Addresses;
select * from Referrals;
select * from tenancy_histories;

/*CREATING PROFILES TABLE*/
CREATE TABLE PROFILES (
	PROFILE_ID INT NOT NULL PRIMARY KEY IDENTITY(1,1),
	FIRST_NAME VARCHAR(255),
	LAST_NAME VARCHAR (255),
	EMAIL VARCHAR(255) NOT NULL ,
	PHONE VARCHAR(255) NOT NULL ,
	CITY_HOMETOWN VARCHAR(255),
	PAN_CARD VARCHAR (255),
	CREATED_AT DATE NOT NULL ,
	GENDER VARCHAR(255)NOT NULL ,
	REFERRAL_CODE VARCHAR(255),
	MARITAL_STATUS VARCHAR(255)
);

/*CREATING TABLE HOUSES*/
CREATE TABLE HOUSES(
	HOUSE_ID INT NOT NULL PRIMARY KEY IDENTITY(1,1),
	HOUSE_TYPE VARCHAR(255),
	BHK_DETAILS VARCHAR(255),
	BED_COUNT INT NOT NULL ,
	FURNISHING_TYPE VARCHAR(255),
	BED_VACANTS INT NOT NULL 
);

/*CREATING TABLE TENANCY HISTORIES*/
 CREATE TABLE TENANCY_HISTORIES(
	ID INT NOT NULL PRIMARY KEY IDENTITY(1,1),
	PROFILE_ID INT NOT NULL ,
	HOUSE_ID INT NOT NULL,
	MOVE_IN_DATE DATE NOT NULL,
	MOVE_OUT_DATE DATE,
	RENT INT NOT NULL,
	BED_TYPE VARCHAR(255),
	MOVE_OUT_REASON VARCHAR(255),
	FOREIGN KEY (PROFILE_ID) REFERENCES PROFILES (PROFILE_ID),
	FOREIGN KEY (HOUSE_ID) REFERENCES HOUSES (HOUSE_ID)
 ); 

 /*CREATING TABLE ADDRESSES*/

CREATE TABLE ADDRESSES (
	AD_ID INT NOT NULL PRIMARY KEY IDENTITY(1,1),
	NAME VARCHAR(255),
	DESCRIPTION TEXT,
	PINCODE INT ,
	CITY VARCHAR(255),
	HOUSE_ID INT NOT NULL ,
	FOREIGN KEY (HOUSE_ID) REFERENCES HOUSES (HOUSE_ID)
);

/*CREATING TABLE REFERRALS*/
CREATE TABLE REFERRALS (
	REF_ID INT NOT NULL PRIMARY KEY IDENTITY(1,1),
	REFERRER_ID INT NOT NULL,
	REFERRER_BONUS_AMOUNT FLOAT,
	REFERRAL_VALID TINYINT ,
	VALID_FROM DATE,
	VALID_TILL DATE,
	FOREIGN KEY (REFERRER_ID) REFERENCES PROFILES (PROFILE_ID)
);

/*CREATING TABLE EMPLOYMENT_DETAILS */

CREATE TABLE EMPLOYMENT_DETAILS (
	ID INT NOT NULL PRIMARY KEY IDENTITY(1,1),
	PROFILE_ID INT NOT NULL ,
	LATEST_EMPLOYER VARCHAR(255),
	OFFICIAL_MAIL_ID VARCHAR(255),
	YRS_EXPERIENCE INT ,
	OCCUPATIONAL_CATEGORY VARCHAR(255),
	FOREIGN KEY (PROFILE_ID) REFERENCES PROFILES (PROFILE_ID)
);



/*Queries*/
/*1. Profile ID, Full Name, and Contact Number of the tenant with the longest stay:*/
SELECT TOP 1 
	P.PROFILE_ID,
	P.FIRST_NAME + ' '+P.LAST_NAME AS FULL_NAME,
	P.PHONE AS CONTACT_NUMBER
FROM TENANCY_HISTORIES TH
JOIN PROFILES P ON TH.PROFILE_ID = P.PROFILE_ID
WHERE TH.MOVE_OUT_DATE IS NOT NULL
ORDER BY DATEDIFF ( DAY , TH.MOVE_IN_DATE, TH.MOVE_OUT_DATE ) DESC;


/*--------------------------------------------------------------------------------------------------------------*/
SELECT TOP 1 
    PROFILE_ID,
    (SELECT P.FIRST_NAME + ' ' + P.LAST_NAME 
     FROM PROFILES P 
     WHERE P.PROFILE_ID = TENANCY_HISTORIES.PROFILE_ID) AS Full_Name,
    (SELECT P.PHONE 
     FROM PROFILES P 
     WHERE P.PROFILE_ID = TENANCY_HISTORIES.PROFILE_ID) AS Contact_Number
FROM 
    TENANCY_HISTORIES
WHERE 
    MOVE_OUT_DATE IS NOT NULL
ORDER BY 
    DATEDIFF(DAY, MOVE_IN_DATE, MOVE_OUT_DATE) DESC;

select * from PROFILES

/*2. Tenants who are married and paying rent > 9000 using subqueries:*/
SELECT P.FIRST_NAME + ' '+ P.LAST_NAME AS FULL_NAME, P.EMAIL_ID, P.PHONE
FROM PROFILES P 
WHERE P.MARITAL_STATUS = 'y' 
	AND P.PROFILE_ID 
		IN 
		(SELECT PROFILE_ID 
		 FROM TENANCY_HISTORIES 
		 WHERE RENT > 9000);

/*3. Details of tenants living in Bangalore or Pune between Jan 2015 and Jan 2016, sorted by rent:*/
SELECT 
    P.profile_id, 
    P.first_name + ' ' + P.last_name AS full_name,
    P.phone, 
    P.email_id, 
    P.city, 
    TH.house_id, 
    TH.move_in_date, 
    TH.move_out_date, 
    TH.rent, 
    (SELECT COUNT(*) 
     FROM REFERRALS R 
     WHERE R.profile_id = P.profile_id) AS total_referrals,
    ED.latest_employer, 
    ED.occupational_category
FROM 
    PROFILES P
JOIN 
    TENANCY_HISTORIES TH ON P.profile_id = TH.profile_id
JOIN 
    Employee_Details ED ON P.profile_id = ED.profile_id
WHERE 
    P.city IN ('Bangalore', 'Pune') 
    AND TH.move_in_date >= '2015-01-01' 
    AND TH.move_in_date <= '2016-01-31'
ORDER BY 
    TH.rent DESC;

SELECT 
    P.profile_id, 
    P.first_name + ' ' + P.last_name AS full_name,
    P.phone, 
    P.email_id, 
    P.city, 
    TH.house_id, 
    TH.move_in_date, 
    TH.move_out_date, 
    TH.rent
FROM 
    PROFILES P
JOIN 
    TENANCY_HISTORIES TH ON P.profile_id = TH.profile_id
WHERE 
    P.profile_id IN (
        SELECT profile_id
        FROM TENANCY_HISTORIES
        WHERE move_in_date BETWEEN '2015-01-01' AND '2016-01-31'
    )
    AND P.city IN ('Bangalore', 'Pune')
ORDER BY 
    TH.rent DESC;



SELECT * FROM EMPLOYEE_DETAILS
SELECT * FROM REFERRALS
/*4. Tenants who have referred more than once and total bonus amount:*/
SELECT 
    P.profile_id,
    P.first_name + ' ' + P.last_name AS full_name,
    P.email_id,  
    COUNT(R.referrer_bonus_amount) AS total_referrals,
    SUM(R.referrer_bonus_amount) AS total_bonus_amount
FROM 
    REFERRALS R
JOIN 
    PROFILES P ON R.profile_id = P.profile_id
GROUP BY 
    P.profile_id, P.first_name, P.last_name, P.email_id  -- Added email_id to GROUP BY
HAVING 
    COUNT(R.referrer_bonus_amount) > 1;  

select * from Referrals
select * from Profiles	
SELECT 
    P.first_name + ' ' + P.last_name AS full_name,
    P.email_id,
    P.phone,
    P.referral_code,
    COUNT(R.ID) AS total_referrals,
    SUM(R.referrer_bonus_amount) AS total_bonus_amount
FROM 
    PROFILES P
JOIN 
    REFERRALS R ON P.profile_id = R.profile_id
WHERE 
    R.referral_valid = 1  
GROUP BY 
    P.profile_id, 
    P.first_name, 
    P.last_name, 
    P.email_id, 
    P.phone, 
    P.referral_code
HAVING 
    COUNT(R.ID) > 1;  

SELECT 
    P.profile_id, 
    P.first_name + ' ' + P.last_name AS full_name,
    P.email_id,
    P.phone,  -- Added phone number
    P.referral_code,  -- Added referral code
    COUNT(R.ID) AS total_referrals,  -- Count the number of valid referrals
    SUM(R.referrer_bonus_amount) AS total_bonus_amount  -- Sum of valid bonus amounts
FROM 
    REFERRALS R
JOIN 
    PROFILES P ON R.profile_id = P.profile_id
WHERE 
    R.referral_valid = 1  -- Only consider valid referrals
GROUP BY 
    P.profile_id, 
    P.first_name, 
    P.last_name, 
    P.email_id, 
    P.phone,  -- Added phone to GROUP BY
    P.referral_code  -- Added referral code to GROUP BY
HAVING 
    COUNT(R.ID) > 1;  -- More than one referral


	select a.first_name +' '+ a.last_name  as full_name,
		a.phone,
		a.email_id,
		Sum(b.referrer_bonus_amount) as total_bonus,
		count(b.referrer_bonus_amount) as total_referrals
	from Profiles as a
	join Referrals as b
	on a.profile_id = b.profile_id
	where b.referral_valid in (1) 
	group by a.profile_id,
	a.email_id,a.phone,a.referral_code,a.first_name,a.last_name
	having count(b.profile_id) >1; 

select * from Referrals
select * from tenancy_histories
select * from Profiles
/*5. Rent generated from each city and the total of all cities:*/
SELECT 
    P.city AS CITY_HOMETOWN, 
    SUM(TH.rent) AS TOTAL_RENT
FROM 
    PROFILES P 
JOIN 
    TENANCY_HISTORIES TH ON P.profile_id = TH.profile_id
GROUP BY 
    P.city

UNION ALL 

SELECT 
    'Total' AS CITY_HOMETOWN, 
    SUM(TH.rent) AS TOTAL_RENT
FROM 
    TENANCY_HISTORIES TH;


/*6. View w_tenant for tenants who moved in on/after 30th April 2015 and live in houses with vacant beds:*/

CREATE VIEW W_TENANT AS 
SELECT 
    P.profile_id,
    TH.rent,
    TH.move_in_date,
    H.house_type,
    H.beds_vacant,
    A.description,
    A.city
FROM 
    TENANCY_HISTORIES TH
JOIN 
    PROFILES P ON TH.profile_id = P.profile_id 
JOIN 
    HOUSES H ON TH.house_id = H.house_id
JOIN 
    ADDRESSES A ON H.house_id = A.house_id
WHERE 
    TH.move_in_date >= '2015-04-30' 
    AND H.beds_vacant > 0;

SELECT * FROM W_TENANT;

/*7. Extend the valid_till date for a month for tenants who referred more than once:*/

UPDATE REFERRALS
SET valid_till = DATEADD(MONTH, 1, valid_till)
WHERE profile_id IN (
    SELECT profile_id 
    FROM REFERRALS
    GROUP BY profile_id
    HAVING COUNT(ID) > 1
);

SELECT 
    profile_id, 
    valid_till
FROM 
    REFERRALS
WHERE 
    profile_id IN (
        SELECT profile_id 
        FROM REFERRALS
        GROUP BY profile_id
        HAVING COUNT(ID) > 1
    );


/*8) Write a query to get Profile ID, Full Name, Contact Number of the tenants along with a new column 'Customer Segment' wherein if the tenant pays rent greater than 10000, tenant falls  in Grade A segment, if rent is between 7500 to 10000, tenant falls in Grade B else in Grade C. 

 */
SELECT 
    P.profile_id,
    P.first_name + ' ' + P.last_name AS full_name,
    P.phone AS contact_number,
    CASE 
        WHEN TH.rent > 10000 THEN 'Grade A'
        WHEN TH.rent BETWEEN 7500 AND 10000 THEN 'Grade B'
        ELSE 'Grade C'
    END AS Customer_Segment
FROM 
    PROFILES P
JOIN 
    TENANCY_HISTORIES TH ON P.profile_id = TH.profile_id;


/*9) Write a query to get Fullname, Contact, City and House Details of the tenants who have not referred even once. */
select * from Houses
SELECT 
    P.first_name + ' ' + P.last_name AS full_name,
    P.phone AS contact,
    P.city AS city,
    H.house_type,
    H.bhk_details,
    H.bed_count,
    H.furnishing_type,
    H.beds_vacant
FROM 
    PROFILES P
JOIN 
    TENANCY_HISTORIES TH ON P.profile_id = TH.profile_id
JOIN 
    HOUSES H ON TH.house_id = H.house_id
WHERE 
    P.profile_id NOT IN (
        SELECT DISTINCT R.profile_id 
        FROM REFERRALS R
    );


/*10)  Write a query to get the house details of the house having highest occupancy.  */
select * from houses;
SELECT top 1
    H.house_id,
    H.house_type,
    H.bhk_details, 
    H.bed_count,
    H.furnishing_type,
    H.beds_vacant,
    COUNT(TH.profile_id) AS occupancy
FROM 
    HOUSES H
LEFT JOIN 
    TENANCY_HISTORIES TH ON H.house_id = TH.house_id
GROUP BY 
    H.house_id, H.house_type, H.bhk_details, H.bed_count, H.furnishing_type, H.beds_vacant
ORDER BY 
    occupancy DESC
;
select *
from Houses
where (bed_count - beds_vacant) in 
(select max(bed_count-beds_vacant) from Houses);

SELECT TOP 1
    H.house_id,
    H.house_type,
    H.bhk_type AS bhk_details, 
    H.bed_count,
    H.furnishing_type,
    H.beds_vacant,
    COUNT(TH.profile_id) AS occupancy_per_bed
FROM 
    HOUSES H
LEFT JOIN 
    TENANCY_HISTORIES TH ON H.house_id = TH.house_id
GROUP BY 
    H.house_id, H.house_type, H.bhk_type, H.bed_count, H.furnishing_type, H.beds_vacant
ORDER BY 
    occupancy_per_bed / H.bed_count DESC;
