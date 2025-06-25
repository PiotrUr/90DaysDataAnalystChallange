# Projekt Bazy Danych – Zarządzanie Szpitalem

Projekt przedstawia pełne przygotowanie danych tabelarycznych do załadowania do relacyjnej bazy danych SQL.

## 📁 Struktura projektu

- `Raw Data/` – oryginalne pliki CSV z Kaggle
- `sql_ready/` – oczyszczone i znormalizowane pliki CSV gotowe do importu do SQL
- `SQL Tables Definitions/` – skrypty `.sql` z definicjami tabel (CREATE TABLE)
- `hospital_schema.dbml` – definicja schematu do wykorzystania np. w dbdiagram.io
- `Hospital Management - DataPreparation.ipynb` – kod w Pythonie (Jupyter Notebook) realizujący czyszczenie danych

## 🧱 Struktura bazy danych

Projekt zawiera pięć głównych tabel:
- `patients`
- `doctors`
- `appointments`
- `treatments`
- `billing`

Tabela `appointments` łączy pacjentów i lekarzy, a `billing` rozlicza przypisane leczenie.

## 🛠️ Użyte narzędzia

- Python (Pandas, datetime)
- Jupyter Notebook
- dbdiagram.io (projekt schematu)
- SQL (standardowy dialekt)

## 👤 Autor

Projekt stworzony przez Piotra Urbana w ramach wyzwania #90DaysOfData.