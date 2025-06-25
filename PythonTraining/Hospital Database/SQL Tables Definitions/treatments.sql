CREATE TABLE treatments (
    treatment_id VARCHAR(10) PRIMARY KEY,
    appointment_id VARCHAR(10),
    treatment_type VARCHAR(100),
    description TEXT,
    cost FLOAT,
    treatment_date DATE,
    FOREIGN KEY (appointment_id) REFERENCES appointments(appointment_id)
);