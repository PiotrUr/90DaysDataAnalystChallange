-- Hospital Database Analysis Session 3
-- Created 2025-07-03 by Piotr Urban

-- Q14: List patients who had appointments in consecutive months.

WITH UniquePatientMonths AS (
	SELECT DISTINCT 
		patient_id, 
		CAST(strftime('%Y', appointment_date) AS INTEGER) AS year,
		CAST(strftime('%m', appointment_date) AS INTEGER) AS month,
		(CAST(strftime('%Y', appointment_date) AS INTEGER) * 12 + 
		CAST(strftime('%m', appointment_date) AS INTEGER)) AS year_month_index
	FROM appointments
),
PatientsWithLead AS (
	SELECT 
		patient_id, 
		year,
		month,
		year_month_index,
		LEAD(year_month_index) OVER (
			PARTITION BY patient_id ORDER BY year_month_index
		) AS next_year_month_index
	FROM UniquePatientMonths
)
SELECT DISTINCT
  patient_id
FROM PatientsWithLead
WHERE next_year_month_index = year_month_index + 1;

-- Q15: Which doctors generated the highest average billing amount per appointment?

WITH DoctorsAppointments AS (
SELECT doctor_id, COUNT(*) AS appointments_count
FROM appointments
GROUP BY doctor_id
),
DoctorsAmountSum AS (
SELECT a.doctor_id, SUM(b.amount) as amount_sum
FROM billing b
LEFT JOIN treatments t ON b.treatment_id = t.treatment_id
LEFT JOIN appointments a ON t.appointment_id = a.appointment_id
GROUP BY a.doctor_id
)
SELECT da.doctor_id, ROUND(amount_sum/appointments_count, 2) AS average_billing_amount
FROM DoctorsAppointments da
JOIN DoctorsAmountSum das ON da.doctor_id = das.doctor_id
ORDER BY average_billing_amount DESC;

-- Q16: Find the month with the highest total billing in the database.

SELECT
	strftime('%m-%Y', bill_date) AS month_year,
	SUM(amount) as total_amount
FROM billing
GROUP BY month_year
ORDER BY total_amount DESC
LIMIT 1;

-- Q17: Show the percentage share of each treatment type in total revenue.

SELECT
	t.treatment_type,
	ROUND(SUM(b.amount)/(SELECT SUM(amount) FROM billing)*100, 2) AS "%_total_amount"
FROM billing b
JOIN treatments t ON b.treatment_id = t.treatment_id
GROUP BY t.treatment_type

-- Q18: For each doctor, show the number of unique patients and their average treatment cost.

SELECT a.doctor_id, COUNT(DISTINCT patient_id) AS patients_count, ROUND(AVG(t.cost), 2) as average_treatment_cost
FROM treatments t
JOIN appointments a ON t.appointment_id = a.appointment_id
GROUP BY a.doctor_id;

-- Q19: Which patients had their first appointment with one doctor and their last appointment with another?

WITH FirstLastAppointments AS (
SELECT patient_id, 
	MIN(appointment_date) AS first_appointment_date,
	MAX(appointment_date) AS last_appointment_date
FROM appointments
GROUP BY patient_id
)
SELECT a1.patient_id
FROM FirstLastAppointments a1
LEFT JOIN appointments a2 ON a1.patient_id = a2.patient_id AND a1.first_appointment_date = a2.appointment_date
LEFT JOIN appointments a3 ON a1.patient_id = a3.patient_id AND a1.last_appointment_date = a3.appointment_date
WHERE a2.doctor_id <> a3.doctor_id
ORDER BY a1.patient_id;

-- Q20: Create a ranking of treatment types by number of occurrences, using RANK().

WITH CountedTreatments AS (
SELECT 
	treatment_type, 
	COUNT(*) AS treatments_count
FROM treatments
GROUP BY treatment_type
)
SELECT
	treatment_type,
	treatments_count,
	RANK () OVER ( ORDER BY treatments_count DESC) AS treatment_rank
FROM CountedTreatments;