import sqlite3
import pandas as pd
import os

DB_PATH = "PersonalDashboardProject/data/database.sqlite"
EXPORT_DIR = "PersonalDashboardProject/data/csv"

TABLES = [
    "github_repos",
    "github_user_stats",
    "leetcode_user_stats",
    "strava_activities"
]

os.makedirs(EXPORT_DIR, exist_ok=True)

conn = sqlite3.connect(DB_PATH)

for table in TABLES:
    try:
        df = pd.read_sql_query(f"SELECT * FROM {table}", conn)
        export_path = os.path.join(EXPORT_DIR, f"{table}.csv")
        df.to_csv(export_path, index=False)
        print(f"✅ Exported {table} to {export_path}")
    except Exception as e:
        print(f"⚠️ Skipped {table}: {e}")

conn.close()