-- Hospital Database – DML Practice Exercises
-- Created 2025-07-06 by Piotr Urban

-- Task 1: Add a new patient with a specific name, birth date, and gender.

--SELECT MAX(patient_id) FROM patients

INSERT INTO patients (patient_id, first_name, last_name, gender, date_of_birth, contact_number, address, registration_date, insurance_provider, insurance_number, email)
VALUES ('P051', 'John', 'Kowalski', 'M', '1983-10-04', '6939555183', '715 Red Springs', '2022-08-15', 'Wellnesscorp', 'INS840985', 'john.kowalski@mail.com');

-- Task 2: Insert a new doctor with a unique ID, name, and specialization.

INSERT INTO doctors (doctor_id, first_name, last_name, specialization, phone_number, years_experience, hospital_branch, email)
VALUES('D011', 'Connor', 'Wright', 'Surgeon', 12532010158, 5, 'Eastside Clinic', 'dr.connor.wright@hospital.com');

-- Task 3: Update an existing patient's name due to a correction.

UPDATE patients
SET last_name = 'Lewandowski'
WHERE patient_id = 'P051';

-- Task 4: Apply a 10% discount to treatment costs above a certain amount for a specific treatment type.

UPDATE treatments
SET cost = 0.9*cost
WHERE cost > 3500 AND treatment_type = 'X-Ray';

-- Task 5: Delete an appointment record that was canceled.

DELETE FROM billing
WHERE treatment_id IN (SELECT treatment_id FROM treatments
WHERE appointment_id ='A003');

DELETE FROM treatments
WHERE appointment_id ='A003';

DELETE
FROM appointments
WHERE appointment_id = 'A003';

-- Task 6: Remove a doctor who has not had any appointments.

WITH DoctorsWithoutAppointments AS (
SELECT d.doctor_id
FROM doctors d
LEFT JOIN appointments a ON d.doctor_id = a.doctor_id
WHERE a.doctor_id IS NULL)

DELETE FROM doctors
WHERE doctor_id IN (SELECT doctor_id FROM DoctorsWithoutAppointments);

-- Task 7: Insert a new billing record for a specific patient and treatment.

INSERT INTO billing (bill_id, patient_id, treatment_id, bill_date, amount, payment_method, payment_status)
VALUES ('B201',	'P034',	'T200',	'2023-05-12', 3953.55, 'Cash', 'Pending');

-- Task 8: Change the payment method for a specific billing record.

UPDATE billing
SET payment_method = 'Insurance'
WHERE bill_id = 'B201';