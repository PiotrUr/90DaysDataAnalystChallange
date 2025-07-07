import requests
import sqlite3
from datetime import datetime
from bs4 import BeautifulSoup

USERNAME = "PiotrUr"
DB_PATH = "data/database.sqlite"

# ========== FETCH REPOS ==========
def fetch_repos(user):
    url = f"https://api.github.com/users/{user}/repos"
    response = requests.get(url)
    response.raise_for_status()
    return response.json()

# ========== FETCH USER PROFILE ==========
def fetch_user_profile(user):
    url = f"https://api.github.com/users/{user}"
    response = requests.get(url)
    response.raise_for_status()
    return response.json()

# ========== SCRAPE CONTRIBUTIONS ==========
def scrape_contributions(user):
    url = f"https://github.com/users/{user}/contributions"
    response = requests.get(url)
    soup = BeautifulSoup(response.text, "html.parser")
    h2 = soup.find("h2")
    if h2:
        text = h2.get_text(strip=True)
        num = ''.join(filter(str.isdigit, text))
        return int(num) if num else None
    return None

# ========== DB INIT ==========
def init_db(conn):
    cursor = conn.cursor()
    cursor.execute('''
        CREATE TABLE IF NOT EXISTS github_repos (
            id INTEGER PRIMARY KEY,
            name TEXT,
            html_url TEXT,
            language TEXT,
            stargazers_count INTEGER,
            forks_count INTEGER,
            created_at TEXT,
            updated_at TEXT,
            snapshot_date TEXT
        )
    ''')
    cursor.execute('''
        CREATE TABLE IF NOT EXISTS github_user_stats (
            snapshot_date TEXT PRIMARY KEY,
            public_repos INTEGER,
            followers INTEGER,
            following INTEGER,
            created_at TEXT,
            contributions_last_year INTEGER
        )
    ''')
    conn.commit()

# ========== SAVE TO DB ==========
def save_repos(conn, repos):
    cursor = conn.cursor()
    now = datetime.utcnow().isoformat()
    for repo in repos:
        cursor.execute('''
            INSERT OR REPLACE INTO github_repos (
                id, name, html_url, language, stargazers_count, forks_count,
                created_at, updated_at, snapshot_date
            ) VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?)
        ''', (
            repo["id"],
            repo["name"],
            repo["html_url"],
            repo["language"],
            repo["stargazers_count"],
            repo["forks_count"],
            repo["created_at"],
            repo["updated_at"],
            now
        ))
    conn.commit()

def save_user_stats(conn, user_data, contributions):
    cursor = conn.cursor()
    now = datetime.utcnow().isoformat()
    cursor.execute('''
        INSERT OR REPLACE INTO github_user_stats (
            snapshot_date, public_repos, followers, following, created_at, contributions_last_year
        ) VALUES (?, ?, ?, ?, ?, ?)
    ''', (
        now,
        user_data["public_repos"],
        user_data["followers"],
        user_data["following"],
        user_data["created_at"],
        contributions
    ))
    conn.commit()

# ========== MAIN ==========
def main():
    print("Fetching data for GitHub user:", USERNAME)
    repos = fetch_repos(USERNAME)
    user_data = fetch_user_profile(USERNAME)
    contributions = scrape_contributions(USERNAME)

    conn = sqlite3.connect(DB_PATH)
    init_db(conn)
    save_repos(conn, repos)
    save_user_stats(conn, user_data, contributions)
    conn.close()

    print("Data saved successfully.")

if __name__ == "__main__":
    main()