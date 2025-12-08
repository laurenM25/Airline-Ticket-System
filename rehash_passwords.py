from db import pool
from werkzeug.security import generate_password_hash

def looks_hashed(p: str) -> bool:
    if not isinstance(p, str):
        return False
    return p.startswith(("pbkdf2:", "scrypt:", "argon2:"))

def rehash_table(table: str, key_col: str):
    # read
    conn = pool.get_connection()
    cur = conn.cursor(dictionary=True)
    cur.execute(f"SELECT {key_col}, password FROM {table}")
    rows = cur.fetchall()
    cur.close()
    conn.close()

    # write
    conn = pool.get_connection()
    cur = conn.cursor()
    changed = 0
    for r in rows:
        old = r["password"]
        if old and not looks_hashed(old):
            new = generate_password_hash(old)  # hashes the EXISTING plaintext
            cur.execute(
                f"UPDATE {table} SET password=%s WHERE {key_col}=%s",
                (new, r[key_col]),
            )
            changed += 1
    conn.commit()
    cur.close()
    conn.close()
    print(f"{table}: updated {changed} passwords")

if __name__ == "__main__":
    rehash_table("customer", "email")
    rehash_table("booking_agent", "email")
    rehash_table("airline_staff", "username")
