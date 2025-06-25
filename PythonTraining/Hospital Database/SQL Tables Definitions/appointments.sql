CREATE TABLE appointments (
    appointment_id VARCHAR(10) PRIMARY KEY,
    patient_id VARCHAR(10),
    doctor_id VARCHAR(10),
    appointment_date DATE,
    appointment_time TIME,
    reason_for_visit VARCHAR(100),
    status VARCHAR(50),
    FOREIGN KEY (patient_id) REFERENCES patients(patient_id),
    FOREIGN KEY (doctor_id) REFERENCES doctors(doctor_id)
);