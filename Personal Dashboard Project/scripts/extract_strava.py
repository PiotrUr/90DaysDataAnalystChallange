import os
import requests
import sqlite3
from datetime import datetime

# === Load credentials from environment variables ===
CLIENT_ID = os.environ.get("STRAVA_CLIENT_ID")
CLIENT_SECRET = os.environ.get("STRAVA_CLIENT_SECRET")
REFRESH_TOKEN = os.environ.get("STRAVA_REFRESH_TOKEN")

DB_PATH = "data/database.sqlite"

def refresh_access_token():
    response = requests.post("https://www.strava.com/api/v3/oauth/token", data={
        "client_id": CLIENT_ID,
        "client_secret": CLIENT_SECRET,
        "grant_type": "refresh_token",
        "refresh_token": REFRESH_TOKEN
    })
    response.raise_for_status()
    return response.json()["access_token"]

def fetch_activities(access_token, per_page=50):
    url = "https://www.strava.com/api/v3/athlete/activities"
    headers = {"Authorization": f"Bearer {access_token}"}
    params = {"per_page": per_page, "page": 1}
    response = requests.get(url, headers=headers, params=params)
    response.raise_for_status()
    return response.json()

def init_db(conn):
    cursor = conn.cursor()
    cursor.execute('''
        CREATE TABLE IF NOT EXISTS strava_activities (
            id INTEGER PRIMARY KEY,
            name TEXT,
            type TEXT,
            distance REAL,
            moving_time INTEGER,
            elapsed_time INTEGER,
            start_date TEXT,
            average_speed REAL,
            max_speed REAL,
            snapshot_date TEXT
        )
    ''')
    conn.commit()

def save_activities(conn, activities):
    cursor = conn.cursor()
    now = datetime.utcnow().isoformat()
    for activity in activities:
        cursor.execute('''
            INSERT OR REPLACE INTO strava_activities (
                id, name, type, distance, moving_time, elapsed_time,
                start_date, average_speed, max_speed, snapshot_date
            ) VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?)
        ''', (
            activity["id"],
            activity["name"],
            activity["type"],
            activity["distance"],
            activity["moving_time"],
            activity["elapsed_time"],
            activity["start_date"],
            activity.get("average_speed", None),
            activity.get("max_speed", None),
            now
        ))
    conn.commit()

def main():
    if not all([CLIENT_ID, CLIENT_SECRET, REFRESH_TOKEN]):
        raise EnvironmentError("Missing required environment variables.")

    print("🔄 Refreshing Strava access token...")
    access_token = refresh_access_token()
    print("✅ Access token retrieved.")

    print("📥 Fetching recent Strava activities...")
    activities = fetch_activities(access_token)

    print(f"📊 Found {len(activities)} activities. Saving to database...")
    conn = sqlite3.connect(DB_PATH)
    init_db(conn)
    save_activities(conn, activities)
    conn.close()

    print("✅ Strava activities saved to SQLite.")

if __name__ == "__main__":
    main()