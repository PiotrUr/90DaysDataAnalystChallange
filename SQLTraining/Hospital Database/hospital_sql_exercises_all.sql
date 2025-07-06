-- Hospital Database – SQL Practice Questions (Analysis + DML)
-- Author: Piotr Urban
-- Database: Hospital Management Dataset
-- Database path: 90DaysDataAnalystChallange\SQLTraining\Hospital Database\data\Hospital Database.db
-- Repository: https://github.com/PiotrUr/90DaysDataAnalystChallange

-- This file contains SQL practice questions grouped by session.
-- Each section corresponds to a specific .sql file with full solutions.

/*
======================================================
  SESSION 1 – BASIC ANALYSIS (hospital_analysis_session1.sql)
======================================================
*/

-- Q1: Which doctors had the most appointments? (Top 5)
-- Q2: What are the top 5 most expensive treatments by average cost?
-- Q3: What is the distribution of payment methods used in the hospital?
-- Q4: What is the average treatment cost per patient?
-- Q5: How many patients had more than one appointment?

/*
======================================================
  SESSION 2 – INTERMEDIATE QUERIES (hospital_analysis_session2.sql)
======================================================
*/

-- Q6: Which patients had treatments with a cost above the overall average?
-- Q7: What is the total billing amount per doctor, based on their appointments and linked treatments?
-- Q8: What is the average number of appointments per patient?
-- Q9: Which treatment type generated the highest total revenue?
-- Q10: List doctors who treated more than one unique patient.
-- Q11: What is the most common payment method per treatment type?
-- Q12: For each patient, list the date of their first and last appointment.
-- Q13: Which patients had appointments with more than one doctor?

/*
======================================================
  SESSION 3 – ADVANCED ANALYSIS (hospital_analysis_session3.sql)
======================================================
*/

-- Q14: List patients who had appointments in consecutive months.
-- Q15: Which doctors generated the highest average billing amount per appointment?
-- Q16: Find the month with the highest total billing in the database.
-- Q17: Show the percentage share of each treatment type in total revenue.
-- Q18: For each doctor, show the number of unique patients and their average treatment cost.
-- Q19: Which patients had their first appointment with one doctor and their last appointment with another?
-- Q20: Create a ranking of treatment types by number of occurrences, using RANK().

/*
======================================================
  SESSION 4 – TIME & BEHAVIORAL ANALYSIS (hospital_analysis_session4.sql)
======================================================
*/

-- Q21: Show the monthly number of appointments over time.
-- Q22: What is the average treatment cost per month? Display trend over time.
-- Q23: List patients who spent the most on treatments (Top 10 by total cost).
-- Q24: Which doctors have the widest variety of treatment types?
-- Q25: What is the average number of days between a patient's appointments?
-- Q26: Which treatment types are most commonly used by each doctor?
-- Q27: What is the total billing per patient, broken down by payment method?
-- Q28: List the top 3 busiest days in terms of number of appointments.

/*
======================================================
  DML PRACTICE – DATA MODIFICATION TASKS (hospital_dml_practice.sql)
======================================================
*/

-- Task 1: Add a new patient with a specific name, birth date, and gender.
-- Task 2: Insert a new doctor with a unique ID, name, and specialization.
-- Task 3: Update an existing patient's name due to a correction.
-- Task 4: Apply a 10% discount to treatment costs above a certain amount for a specific treatment type.
-- Task 5: Delete an appointment record that was canceled.
-- Task 6: Remove a doctor who has not had any appointments.
-- Task 7: Insert a new billing record for a specific patient and treatment.
-- Task 8: Change the payment method for a specific billing record.