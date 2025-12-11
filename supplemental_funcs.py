import mysql.connector
from mysql.connector.pooling import MySQLConnectionPool
import random
from db import pool
import datetime
from collections import defaultdict #allows any key to be accessed, no key error

def check_special_perm(username, user_type):
    if user_type != "airline_staff":
        return None
    
    #otherwise, collect staff permissions in list
    conn = pool.get_connection()
    query = f"SELECT permission_type FROM permission WHERE airline_staff_username = %s;"

    cursor = conn.cursor()
    cursor.execute(query,(username,))
    data = cursor.fetchall()

    cursor.close()
    conn.close()

    #fix data format so it's in a nice list for easy access to permission type
    for i in range(len(data)):
        data[i] = data[i][0]
    
    return data

def check_related_airline(username, user_type):
    print("username",username)
    print("user type",user_type)
    conn = pool.get_connection()
    if user_type == "airline_staff":
        query = "SELECT airline_name FROM airline_staff WHERE username = %s"
        cursor = conn.cursor()
        cursor.execute(query,(username,))
        data = cursor.fetchone()
        cursor.close()
        conn.close()

        if data:
            return [data[0]]  # return list
        else:
            return None
    elif user_type == "agent":
        query = "SELECT airline_name FROM authorized_by WHERE agent_email = %s"
        cursor = conn.cursor()
        cursor.execute(query,(username,))
        rows = cursor.fetchall()
        cursor.close()
        conn.close()

        if rows: #could be that the agent hasn't been assigned yet
            return [row[0] for row in rows]
        else:
            return None
        
    else:
        return None

def check_ticket_ids(cursor):
    query = "SELECT ticket_ID FROM ticket;"

    cursor.execute(query)
    data = cursor.fetchall()

    print(data)
    print(type(data))
    return data

# get list of airplanes for a given airline
def airplanes_for_airline(airline):
    conn = pool.get_connection()
    cursor = conn.cursor()

    query = f"SELECT id FROM airplane WHERE airline_name = %s;"

    cursor.execute(query,(airline,))
    data = cursor.fetchall()

    cursor.close()
    conn.close()

    #fix data format so it's in a nice list
    for i in range(len(data)):
        data[i] = data[i][0]
    
    return data

# get list of airports
def airports_list():
    conn = pool.get_connection()
    cursor = conn.cursor()

    query = f"SELECT name FROM airport;"

    cursor.execute(query)
    data = cursor.fetchall()

    cursor.close()
    conn.close()

    #fix data format so it's in a nice list
    for i in range(len(data)):
        data[i] = data[i][0]
    
    return data

#list of all agents (no filter)
def list_of_agents():
    conn = pool.get_connection()
    cursor = conn.cursor()

    query = f"SELECT email FROM booking_agent;"

    cursor.execute(query)
    data = cursor.fetchall()

    cursor.close()
    conn.close()

    #fix data format so it's in a nice list
    for i in range(len(data)):
        data[i] = data[i][0]
    
    return data

#list of customers of agent (can be any customer)
def list_of_customers(airline_name=None):
    conn = pool.get_connection()
    cursor = conn.cursor()

    if airline_name == None:
        cursor.execute("SELECT email FROM customer;")
    else:
        cursor.execute("SELECT DISTINCT customer_email FROM customer_analytics WHERE airline_name = %s;",(airline_name,))
    data = cursor.fetchall()

    cursor.close()
    conn.close()

    #fix data format so it's in a nice list
    for i in range(len(data)):
        data[i] = data[i][0]
    
    return data

## for customer analytics
def compute_monthly_totals(data_rows, last_n_months=6):
    totals = defaultdict(float)

    # append purchase amount to each matching (year,month) key. date is a datetime date object
    for dateObj, price in data_rows:
        key = f"{dateObj.year}-{dateObj.month:02d}" #get year and month info
        totals[key] += float(price)

    # Only last N months
    now = datetime.datetime.now() #time reference is now
    last_month_keys = []
    for i in range(last_n_months):
        m = (now.month - i - 1) % 12 + 1 #get relevant month
        y = now.year - ((now.month - i - 1) // 12) #get relevant year (circles back around if going from jan 2025 to dec 2024)
        last_month_keys.append(f"{y}-{m:02d}") #relevant year-month pairings!

    # preserve order (oldest -> newest)
    last_month_keys.reverse()

    return {key: totals.get(key, 0) for key in last_month_keys} #return data with relevant year-month pairings

def AgentIsAuthorizedByAirline(agent_email, airline):
    conn = pool.get_connection()
    cursor = conn.cursor()

    cursor.execute("SELECT * FROM authorized_by WHERE agent_email = %s AND airline_name = %s",(agent_email,airline))
    data=cursor.fetchone()

    cursor.close()
    conn.close() 

    if data:
        return True
    else:
        return False

#UPDATE TO ALLOW FOR MULTIPLE TICKETS IN ONE TRANSACTION
def create_purchase_ticket_transaction(airline, flight_num, customer_email, num_tickets, agent_email=None):
    conn = pool.get_connection()
    cursor = conn.cursor()

    try:
        conn.start_transaction()

        for i in range(num_tickets):
            ticket_id = random.randint(0, 9999)
            existing_ids = {row[0] for row in check_ticket_ids(cursor)}
            while ticket_id in existing_ids:
                ticket_id = random.randint(0,9999)

            cursor.execute(
                "INSERT INTO ticket (ticket_id, flight_num, airline_name) VALUES (%s, %s, %s)",
                (ticket_id, flight_num, airline)
            )

            if agent_email:
                cursor.execute(
                    "INSERT INTO purchases (ticket_id, customer_email, booking_agent_email, purchase_date) "
                    "VALUES (%s, %s, %s, NOW())",
                    (ticket_id, customer_email, agent_email)
                )
            else:
                cursor.execute(
                    "INSERT INTO purchases (ticket_id, customer_email, purchase_date) "
                    "VALUES (%s, %s, NOW())",
                    (ticket_id, customer_email)
                )

        conn.commit()

    except Exception as e:
        conn.rollback()
        raise e

    finally:
        cursor.close()
        conn.close()


    
"""
functions related to system admin -- added December 11th, 2025.
"""
def get_pending_requests():
    conn = pool.get_connection()
    cursor = conn.cursor()

    cursor.execute('SELECT request_id, username, first_name, last_name, date_of_birth, airline_name, permission_type FROM register_requests')
    rows = cursor.fetchall()
    columns = "request_id, username, first_name, last_name, date_of_birth, airline_name, permission_type".split(", ")

    cursor.close()
    conn.close()

    return rows, columns

def approve_request(request_id):
    conn = pool.get_connection()
    cursor = conn.cursor()

    cursor.execute('SELECT username, password, first_name, last_name, date_of_birth, airline_name, permission_type FROM register_requests WHERE request_id = %s',(request_id,))
    row = cursor.fetchone()

    #if no matching request_id, stop
    if not row:
        cursor.close()
        conn.close() 
        return
    
    #if data, begin transaction where we add the data into the airline_staff table and remove the request from the register_requests table
    username, password, first_name, last_name, date_of_birth, airline_name, permission_type = row

    try:
        query = "INSERT INTO airline_staff VALUES(%s,%s,%s,%s,%s,%s)"
        cursor.execute(query,(username, password, first_name, last_name, date_of_birth, airline_name))
        cursor.execute("INSERT INTO permission VALUES(%s,%s)",(permission_type,username))

        query = "DELETE FROM register_requests WHERE request_id = %s"
        cursor.execute(query,(request_id,))

        conn.commit() 
    except Exception as e:
        conn.rollback()
        raise e

    finally:
        cursor.close()
        conn.close() 


def reject_request(request_id):
    conn = pool.get_connection()
    cursor = conn.cursor()

    cursor.execute('SELECT * FROM register_requests WHERE request_id = %s',(request_id,))
    row = cursor.fetchone()

    #if no matching request_id, stop
    if not row:
        cursor.close()
        conn.close() 
        return
    
    #if data, simply remove the row
    query = "DELETE FROM register_requests WHERE request_id = %s"
    cursor.execute(query,(request_id,))
    

    cursor.close()
    conn.close()