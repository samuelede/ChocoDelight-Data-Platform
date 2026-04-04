import os
from dotenv import load_dotenv
from urllib.parse import quote_plus

load_dotenv()

DB_PASSWORD = os.getenv("DB_PASSWORD")

if not DB_PASSWORD:
    raise ValueError("DB_PASSWORD is not set in .env file! Please check your .env file.")

DB_CONFIG = {
    "host": os.getenv("DB_HOST", "localhost"),
    "port": os.getenv("DB_PORT", "5432"),
    "database": os.getenv("DB_NAME", "chocodelight"),
    "user": os.getenv("DB_USER", "postgres"),
    "password": DB_PASSWORD
}

# Properly encode password to handle special characters like @, #, %, etc.
DATABASE_URL = (
    f"postgresql+psycopg2://{DB_CONFIG['user']}:{quote_plus(DB_CONFIG['password'])}"
    f"@{DB_CONFIG['host']}:{DB_CONFIG['port']}/{DB_CONFIG['database']}"
)

print("✅ Database configuration loaded successfully from .env")