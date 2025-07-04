-- Hospital Database Analysis Session 4
-- Created 2025-07-04 by Piotr Urban

-- Q21: Show the monthly number of appointments over time.

SELECT 
	CAST(strftime('%Y', appointment_date) AS INTEGER) AS year,
	CAST(strftime('%m', appointment_date) AS INTEGER) AS month,
	strftime('%Y-%m', appointment_date) AS year_month,
	COUNT(*) as appointments_count
FROM appointments
GROUP BY year, month
ORDER BY year, month;

-- Q22: What is the average treatment cost per month? Display trend over time.

SELECT 
	CAST(strftime('%Y', treatment_date) AS INTEGER) AS year,
	CAST(strftime('%m', treatment_date) AS INTEGER) AS month,
	ROUND(AVG(cost), 2) as average_treatment_cost
FROM treatments
GROUP BY year, month
ORDER BY year, month;

-- Q23: List patients who spent the most on treatments (Top 10 by total cost).

SELECT 
	a.patient_id,
	SUM(t.cost) as treatments_cost
FROM treatments t
JOIN appointments a ON t.appointment_id = a.appointment_id
GROUP BY a.patient_id
ORDER BY treatments_cost DESC
LIMIT 10;

-- Q24: Which doctors have the widest variety of treatment types?

SELECT 
	a.doctor_id,
	COUNT(DISTINCT t.treatment_type) as treatment_types
FROM treatments t
JOIN appointments a ON t.appointment_id = a.appointment_id
GROUP BY a.doctor_id
ORDER BY treatment_types DESC;

-- Q25: What is the average number of days between a patient's appointments?

WITH PatientsWithLeadAppointments AS (
SELECT 
	patient_id, 
	appointment_date,
	LEAD(appointment_date) OVER (
		PARTITION BY patient_id ORDER BY appointment_date
	) AS next_visit_date
FROM appointments
)
SELECT
	ROUND(AVG(julianday(next_visit_date) - julianday(appointment_date)), 1) AS average_days_between_visits
FROM PatientsWithLeadAppointments
WHERE next_visit_date IS NOT NULL;

-- Q26: Which treatment types are most commonly used by each doctor?

WITH RankedTreatments AS (
	SELECT
		a.doctor_id,
		t.treatment_type,
		ROW_NUMBER() OVER (
			PARTITION BY a.doctor_id
			ORDER BY COUNT(*) DESC) AS rn
	FROM treatments t
	JOIN appointments a ON t.appointment_id = a.appointment_id
	GROUP BY a.doctor_id, t.treatment_type
)
SELECT doctor_id, treatment_type as most_used_treatment
FROM RankedTreatments
WHERE rn = 1;

-- Q27: What is the total billing per patient, broken down by payment method?

SELECT 
	a.patient_id, 
	b.payment_method, 
	SUM(b.amount) as total_amount
FROM billing b
JOIN treatments t ON b.treatment_id = t.treatment_id
JOIN appointments a ON t.appointment_id = a.appointment_id
GROUP BY a.patient_id, b.payment_method
ORDER BY a.patient_id ASC, total_amount DESC;

-- Q28: List the top 3 busiest days in terms of number of appointments.

SELECT appointment_date, COUNT(*) as appointments_count
FROM appointments
GROUP BY appointment_date
ORDER BY appointments_count DESC
LIMIT 3;