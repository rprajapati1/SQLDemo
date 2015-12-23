# MS SQL Demo

##Purpose
This project is to demonstrate some data manipulation and analysis using SQL.

##Business Case
Consider a hypothetical case where students in a university are determined whether they are eligible for certain scholarships or not. Depending on their eligibility, they are given government or a company-sponsored scholarship.

It has 2 parts:

- Eligibility
- Enrollment

####Eligibility
It is assumed that the system calculates and stores a student's eligibility for scholarship in a database. 
This includes the period during which a student is eligible for a Federal/State/Company-sponsored scholarship.
It is assumed that at any point in time, a student is eligible for the Company-sponsored scholarship, but not for Federal/State-sponsored scholarship.
A student can also be eligible for 'Partial' scholarship where the Federal/State government pays for part of the scholarship and the company pays the rest.

- If a student is deemed eligible then, his/her Eligibility Status Code will be AP (approved).
- If a student has never been deemed eligible then, his/her Eligibility Status Code will be DN (denied).
- If a student was deemed eligible before but not in the current (latest) eligibility run then, his/her Eligibility Status Code will be TN (terminated).


####Enrollment
Depending on the student's eligibility, the system then pairs the Student with a corresponding Government/Company-based scholarship plan.
A student who is eligible for Federal/State scholarship, will be enrolled only in a Government-based scholarship plan. The Premium percent (to be paid by the individual or Company) of such a scholarship plan will be null or zero.
While a student who is eligible for Company/Partial scholarship, will be enrolled only in a Company-based scholarship plan. The Premium percent (to be paid by the individual or Company) of such a scholarship plan will be calculated based on the person's age and populated using a Stored Procedure.

##Technologies Used
SQL Server 2012

## Installation Notes

#### Install SQL Server 2012 on your machine
You can visit the site https://technet.microsoft.com/en-us/library/bb500395(v=sql.110).aspx for details 

#### Create a local database
You can follow the steps mentioned at https://msdn.microsoft.com/en-us/library/ms186312.aspx

#### Create tables in the database
Use the following files to create the tables required for this demo:

- Student.sql : Stores student-related information such as name, age, race etc.
- Scholarship.sql : Stores information for every scholarship plan such as type, effective dates etc
- Eligibility.sql : Stores eligibility-related information for every student
- Enrollment.sql : Stores information like which student is enrolled in which plan and its corresponding premium to be paid

#### Run the Stored Procedure 
- StoredProc_UpdatePremiumPercent.sql : Calculates and updates the PremiumPercent column in Scholarship based on the student's eligibility, plan and age.

## Analysis
This demo contains some SQL which run on the database and display some analytical results based on the data contained:

#####StudentCount_GovtEligible.sql
Running this SQL will show the count of students per race who are eligible for a Government-sponsored scholarship (Federal or State) in a specified month and year.

#####StudentCount_GovtEnrolled.sql
Running this SQL will show the count of students per race enrolled in a Government-sponsored scholarship plan in a specified month and year.

#####StudentCount_PartlyGovtEnrolled.sql
Running this SQL will show the count of students per race enrolled in a Company-sponsored scholarship plan in a specified month and year.