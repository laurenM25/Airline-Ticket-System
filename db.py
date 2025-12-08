from mysql.connector.pooling import MySQLConnectionPool
from dotenv import load_dotenv
import os

# Load .env file
load_dotenv()

# Access the values
db_password = os.getenv("DB_PASSWORD")
db_user = os.getenv("DB_USER")

pool = MySQLConnectionPool(
    pool_name="mypool",
    pool_size=10,
    host="127.0.0.1",
    port = 3306,
    user=db_user,
    password=db_password,
    database="air_ticket_reservation_db"
)