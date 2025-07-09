import requests
import sqlite3
from datetime import datetime

USERNAME = "PUrban"
DB_PATH = "PersonalDashboardProject/data/database.sqlite"

GRAPHQL_ENDPOINT = "https://leetcode.com/graphql"
HEADERS = {"Content-Type": "application/json"}

QUERY = """
query getUserProfile($username: String!) {
  matchedUser(username: $username) {
    profile {
      ranking
      reputation
      contributionPoints
    }
    submitStatsGlobal {
      acSubmissionNum {
        difficulty
        count
      }
    }
  }
}
"""

def fetch_leetcode_stats(username):
    payload = {
        "query": QUERY,
        "variables": {"username": username}
    }
    response = requests.post(GRAPHQL_ENDPOINT, json=payload, headers=HEADERS)
    response.raise_for_status()
    return response.json()

def extract_stats(data):
    profile = data["data"]["matchedUser"]["profile"]
    subs = data["data"]["matchedUser"]["submitStatsGlobal"]["acSubmissionNum"]
    stats = {item["difficulty"]: item["count"] for item in subs}
    return {
        "ranking": profile["ranking"],
        "reputation": profile["reputation"],
        "contributionPoints": profile["contributionPoints"],
        "totalSolved": stats.get("All", 0),
        "easySolved": stats.get("Easy", 0),
        "mediumSolved": stats.get("Medium", 0),
        "hardSolved": stats.get("Hard", 0),
    }

def init_db(conn):
    cursor = conn.cursor()
    cursor.execute('''
        CREATE TABLE IF NOT EXISTS leetcode_user_stats (
            snapshot_date TEXT PRIMARY KEY,
            total_solved INTEGER,
            easy_solved INTEGER,
            medium_solved INTEGER,
            hard_solved INTEGER,
            ranking INTEGER,
            reputation INTEGER,
            contribution_points INTEGER
        )
    ''')
    conn.commit()

def save_to_db(conn, stats):
    cursor = conn.cursor()
    now = datetime.utcnow().isoformat()
    cursor.execute('''
        INSERT OR REPLACE INTO leetcode_user_stats (
            snapshot_date, total_solved, easy_solved, medium_solved, hard_solved,
            ranking, reputation, contribution_points
        ) VALUES (?, ?, ?, ?, ?, ?, ?, ?)
    ''', (
        now,
        stats["totalSolved"],
        stats["easySolved"],
        stats["mediumSolved"],
        stats["hardSolved"],
        stats["ranking"],
        stats["reputation"],
        stats["contributionPoints"]
    ))
    conn.commit()

def main():
    print(f"📡 Fetching LeetCode stats for user: {USERNAME}")
    data = fetch_leetcode_stats(USERNAME)
    stats = extract_stats(data)

    conn = sqlite3.connect(DB_PATH)
    init_db(conn)
    save_to_db(conn, stats)
    conn.close()
    print("✅ LeetCode stats saved to SQLite.")

if __name__ == "__main__":
    main()
