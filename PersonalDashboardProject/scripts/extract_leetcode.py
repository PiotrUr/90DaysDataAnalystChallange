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
    query = '''
    query userProfile($username: String!) {
      allQuestionsCount {
        difficulty
        count
      }
      matchedUser(username: $username) {
        submitStatsGlobal {
          acSubmissionNum {
            difficulty
            count
          }
        }
        profile {
          ranking
          reputation
        }
      }
    }
    '''

    variables = {"username": username}

    headers = {
        "Content-Type": "application/json",
        "Referer": f"https://leetcode.com/{username}/",
        "User-Agent": "Mozilla/5.0"
    }

    payload = {
        "operationName": "userProfile",
        "query": query,
        "variables": variables
    }

    response = requests.post(GRAPHQL_ENDPOINT, json=payload, headers=headers)
    print("DEBUG Response JSON:", response.text)
    response.raise_for_status()
    return response.json()

def extract_stats(data):
    profile = data["data"]["matchedUser"]["profile"]
    submissions = data["data"]["matchedUser"]["submitStatsGlobal"]["acSubmissionNum"]
    stats = {item["difficulty"]: item["count"] for item in submissions}
    return {
        "ranking": profile.get("ranking"),
        "reputation": profile.get("reputation"),
        "totalSolved": stats.get("All", 0),
        "easySolved": stats.get("Easy", 0),
        "mediumSolved": stats.get("Medium", 0),
        "hardSolved": stats.get("Hard", 0)
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
            reputation INTEGER
        );
    ''')
    conn.commit()

def save_to_db(conn, stats):
    cursor = conn.cursor()
    now = datetime.utcnow().isoformat()
    cursor.execute('''
        INSERT OR REPLACE INTO leetcode_user_stats (
            snapshot_date,
            total_solved,
            easy_solved,
            medium_solved,
            hard_solved,
            ranking,
            reputation
        ) VALUES (?, ?, ?, ?, ?, ?, ?)
    ''', (
        now,
        stats["totalSolved"],
        stats["easySolved"],
        stats["mediumSolved"],
        stats["hardSolved"],
        stats["ranking"],
        stats["reputation"]
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