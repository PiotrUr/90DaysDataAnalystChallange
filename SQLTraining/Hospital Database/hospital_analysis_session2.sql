-- Hospital Database Analysis Session 2
-- Created 2025-07-02 by Piotr Urban

-- Q6: Which patients had treatments with a cost above the overall average?

SELECT DISTINCT a.patient_id
FROM treatments t
JOIN appointments a ON t.appointment_id = a.appointment_id
WHERE t.cost > (SELECT ROUND(AVG(cost), 2) FROM treatments)
ORDER BY patient_id;
	
-- Q7: What is the total billing amount per doctor, based on their appointments and linked treatments?

SELECT a.doctor_id, SUM(cost) AS total_treatments_cost
FROM treatments t
JOIN appointments a ON t.appointment_id = a.appointment_id
GROUP BY a.doctor_id;

-- Q8: What is the average number of appointments per patient?

SELECT ROUND(COUNT(*)/(SELECT COUNT (DISTINCT patient_id) FROM appointments), 2) as average_appointments_per_patient
FROM appointments;

-- Q9: Which treatment type generated the highest total revenue?

SELECT treatment_type, SUM(cost) AS total_cost
FROM treatments
GROUP BY treatment_type
ORDER BY total_cost DESC
LIMIT 1;

-- Q10: List doctors who treated more than one unique patient.

WITH UniqueAppointments AS (
	SELECT DISTINCT doctor_id, patient_id
	FROM appointments
)
SELECT doctor_id
FROM UniqueAppointments a
GROUP BY a.doctor_id
HAVING COUNT(*)>1;

-- Q11: What is the most common payment method per treatment type?

WITH PaymentCounts AS (
    SELECT 
        t.treatment_type, 
        b.payment_method,
        COUNT(*) AS method_count,
        ROW_NUMBER() OVER (
            PARTITION BY t.treatment_type 
            ORDER BY COUNT(*) DESC
        ) AS rn
    FROM billing b
    LEFT JOIN treatments t ON b.treatment_id = t.treatment_id
    GROUP BY t.treatment_type, b.payment_method
)
SELECT 
    treatment_type,
    payment_method AS most_common_payment_method,
    method_count
FROM PaymentCounts
WHERE rn = 1
ORDER BY treatment_type;

-- Q12: For each patient, list the date of their first and last appointment.

SELECT 
	patient_id, 
	MIN(appointment_date) AS first_appointment_date, 
	MAX(appointment_date) AS last_appointment_date
FROM appointments
GROUP BY patient_id;

-- Q13: Which patients had appointments with more than one doctor?

WITH UniqueAppointments AS (
	SELECT DISTINCT doctor_id, patient_id
	FROM appointments
)
SELECT patient_id
FROM UniqueAppointments
GROUP BY patient_id
HAVING COUNT(*)>1;