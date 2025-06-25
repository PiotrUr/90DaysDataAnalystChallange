CREATE TABLE billing (
    bill_id VARCHAR(10) PRIMARY KEY,
    patient_id VARCHAR(10),
    treatment_id VARCHAR(10),
    bill_date DATE,
    amount FLOAT,
    payment_method VARCHAR(50),
    payment_status VARCHAR(50),
    FOREIGN KEY (patient_id) REFERENCES patients(patient_id),
    FOREIGN KEY (treatment_id) REFERENCES treatments(treatment_id)
);