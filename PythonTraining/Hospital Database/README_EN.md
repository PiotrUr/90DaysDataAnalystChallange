# Hospital Management Database – Relational Data Project

This project demonstrates the full preparation of a multi-table dataset for use in a relational SQL environment.

## 📁 Project Structure

- `Raw Data/` – original CSV files from Kaggle
- `sql_ready/` – cleaned and normalized CSV files ready for SQL import
- `SQL Tables Definitions/` – `.sql` scripts with `CREATE TABLE` statements for all entities
- `hospital_schema.dbml` – schema definition compatible with dbdiagram.io
- `Hospital Management - DataPreparation.ipynb` – Jupyter Notebook with full data cleaning process in Python

## 🧱 Database Schema

The project includes five core relational tables:
- `patients`
- `doctors`
- `appointments`
- `treatments`
- `billing`

These are linked via primary and foreign keys as defined in the ERD.

## 🛠️ Tools Used

- Python (Pandas, datetime)
- Jupyter Notebook
- dbdiagram.io (ERD design)
- SQL (standard dialect)

## 👤 Author

Created by Piotr Urban as part of the #90DaysOfData challenge.