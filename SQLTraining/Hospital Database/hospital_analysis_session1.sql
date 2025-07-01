-- Hospital Database Analysis Session 1
-- Created 2025-07-01 by Piotr Urban

-- Q1: Which doctors had the most appointments? (Top 5)

SELECT
	doctor_id,
	COUNT(*) AS total_appointments
FROM appointments
GROUP BY doctor_id
ORDER BY total_appointments DESC
LIMIT 5;

-- Q2: What are the top 5 most expensive treatments by average cost?

SELECT treatment_type, ROUND(AVG(cost),2) as average_cost
FROM treatments
GROUP BY treatment_type
ORDER BY average_cost DESC
Limit 5;

-- Q3: What is the distribution of payment methods used in the hospital?

SELECT payment_method, COUNT(*) AS payments_count
FROM billing
GROUP BY payment_method
ORDER BY payments_count DESC;

-- Q4: What is the average treatment cost per patient?

SELECT a. patient_id, ROUND(AVG(t.cost),2) as average_cost
FROM treatments t
JOIN appointments a ON t.appointment_id = a.appointment_id 
GROUP BY a.patient_id
ORDER BY average_cost DESC;

-- Q5: How many patients had more than one appointment?
SELECT COUNT(*) AS patients_count
FROM (
    SELECT patient_id
    FROM appointments
    GROUP BY patient_id
    HAVING COUNT(*) > 1
) AS repeated_patients;