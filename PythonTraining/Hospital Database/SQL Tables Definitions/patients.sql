CREATE TABLE patients (
    patient_id VARCHAR(10) PRIMARY KEY,
    first_name VARCHAR(50),
    last_name VARCHAR(50),
    gender CHAR(1),
    date_of_birth DATE,
    contact_number VARCHAR(15),
    address VARCHAR(255),
    registration_date DATE,
    insurance_provider VARCHAR(100),
    insurance_number VARCHAR(50),
    email VARCHAR(100)
);