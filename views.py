from mysql.connector.pooling import MySQLConnectionPool
from datetime import datetime
from db import pool

def upcomingFlightsView():
    #cur = datetime.today().strftime('%Y-%m-%d %H:%M:%S') # don't need anymore, sql has NOW(), should work
    query = f"SELECT * FROM upcoming_flights;"

    conn = pool.get_connection()
    cursor = conn.cursor()
    cursor.execute(query)
    data = cursor.fetchall()

    cursor.close()
    conn.close()

    return data
    
    

def inProgressFlightsView():
    query = f"SELECT * FROM in_progress_flights;"

    conn = pool.get_connection()
    cursor = conn.cursor()
    cursor.execute(query)
    data = cursor.fetchall()

    cursor.close()
    conn.close()

    return data

"""
customer
"""
def purchasedFlightsView_customer(customer_email):
    columns = "ticket_id,booking_agent_email,purchase_date,airline_name,flight_num,departure_airport,departure_city,departure_time,arrival_airport,arrival_city,arrival_time,price,status,airplane_id".split(",")
    query = f"SELECT ticket_id, booking_agent_email, purchase_date, airline_name, flight_num,departure_airport, departure_city, departure_time, arrival_airport, arrival_city, arrival_time, price, status, airplane_id FROM purchased_flights WHERE customer_email = '{customer_email}';"

    conn = pool.get_connection()
    cursor = conn.cursor()
    cursor.execute(query)
    data = cursor.fetchall()

    cursor.close()
    conn.close()

    return data, columns

def custSpendingStats(customer_email, start_range = None, end_range = None):
    #columns = ["purchase date", "ticket price"]
    query = f"SELECT purchase_date, ticket_price FROM spending WHERE customer_email = '{customer_email}'"

    if start_range and end_range:
        start_str = start_range.strftime("%Y-%m-%d")
        end_str = end_range.strftime("%Y-%m-%d")
        query = f"SELECT purchase_date, ticket_price FROM spending WHERE customer_email = '{customer_email}' AND purchase_date >= '{start_str}' AND purchase_date <= '{end_str}'"

    conn = pool.get_connection()
    cursor = conn.cursor()
    cursor.execute(query)
    data = cursor.fetchall()

    cursor.close()
    conn.close()

    return data

def return_confirm_flight_to_purchase(airline, flight_num):
    columns = "airline_name,flight_num,departure_airport,departure_city,departure_time,arrival_airport,arrival_city,arrival_time,price,status,airplane_id,available_seats".split(",")
    query = f"SELECT * FROM browse_flights WHERE airline_name = '{airline}' AND flight_num = '{flight_num}';"

    conn = pool.get_connection()
    cursor = conn.cursor()
    cursor.execute(query)
    data = cursor.fetchone()

    cursor.close()
    conn.close()

    return data,columns

"""
agent
"""
def purchasedFlightsView_agent(agent_email):
    columns = "ticket_id,customer_email,purchase_date,airline_name,flight_num,departure_airport,departure_city,departure_time,arrival_airport,arrival_city,arrival_time,price,status,airplane_id".split(",")
    query = f"SELECT ticket_id, customer_email, purchase_date, airline_name, flight_num,departure_airport, departure_city, departure_time, arrival_airport, arrival_city, arrival_time, price, status, airplane_id FROM purchased_flights WHERE booking_agent_email = '{agent_email}';"

    conn = pool.get_connection()
    cursor = conn.cursor()
    cursor.execute(query)
    data = cursor.fetchall()

    cursor.close()
    conn.close()

    return data, columns

def browseFlightsByAirline(airlines):
    if airlines is None:
        return None
    
    formatted_airlines = ",".join(["%s"] * len(airlines))

    conn = pool.get_connection()
    query = f"SELECT * FROM browse_flights WHERE airline_name IN ({formatted_airlines})"
    cursor = conn.cursor()
    cursor.execute(query, airlines) #pass in parameters
    data = cursor.fetchall()

    cursor.close()
    conn.close()

    return data

#analytics for agent
def commission_totals_last_30(agent_email):
    conn = pool.get_connection()
    cursor = conn.cursor()

    cursor.execute("SELECT SUM(commission) AS commissions_total FROM agent_analytics WHERE booking_agent_email = %s AND purchase_date >= DATE_SUB(CURDATE(), INTERVAL 30 DAY)", (agent_email,))
    data = cursor.fetchone()[0]

    cursor.close()
    conn.close()

    return float(data) if data else 0.0

def average_commission_last_30(agent_email):
    conn = pool.get_connection()
    cursor = conn.cursor()

    cursor.execute("SELECT AVG(commission) AS average_commissions FROM agent_analytics WHERE booking_agent_email = %s AND purchase_date >= DATE_SUB(CURDATE(), INTERVAL 30 DAY)", (agent_email,))
    data = cursor.fetchone()[0]

    cursor.close()
    conn.close()

    return float(data) if data else 0.0

def num_tickets_sold_all_time(agent_email):
    conn = pool.get_connection()
    cursor = conn.cursor()

    cursor.execute("SELECT COUNT(ticket_id) AS tickets_sold FROM agent_analytics WHERE booking_agent_email = %s", (agent_email,))
    data = cursor.fetchone()[0]

    cursor.close()
    conn.close()

    return int(data) if data else 0

def topCustomer_byTickets(agent_email):
    #to ensure within past 6 months: purchase_date >= DATE_SUB(CURDATE(), INTERVAL 6 MONTH)
    query = f"SELECT customer_email, COUNT(ticket_id) AS tickets_sold FROM agent_analytics WHERE booking_agent_email = '{agent_email}' AND purchase_date >= DATE_SUB(CURDATE(), INTERVAL 6 MONTH) GROUP BY customer_email ORDER BY tickets_sold desc LIMIT 5;"
    conn = pool.get_connection()
    cursor = conn.cursor()
    cursor.execute(query)
    data = cursor.fetchall()

    cursor.close()
    conn.close()

    return data

def topCustomer_byCommission(agent_email):
    #to ensure within past 6 months: purchase_date >= DATE_SUB(CURDATE(), INTERVAL 6 MONTH)
    query = f"SELECT customer_email, SUM(commission) AS total_commission FROM agent_analytics WHERE booking_agent_email = '{agent_email}' AND purchase_date >= DATE_SUB(CURDATE(), INTERVAL 12 MONTH) GROUP BY customer_email ORDER BY total_commission desc LIMIT 5;"
    conn = pool.get_connection()
    cursor = conn.cursor()
    cursor.execute(query)
    data = cursor.fetchall()

    cursor.close()
    conn.close()

    return data

"""
airline staff
"""
def upcomingFlightsByAirline(airline):
    query = f"SELECT * FROM upcoming_flights WHERE airline_name = '{airline}';"

    conn = pool.get_connection()
    cursor = conn.cursor()
    cursor.execute(query)
    data = cursor.fetchall()

    cursor.close()
    conn.close()

    return data

def passengersPerFlight(airline):
    columns = "airline_name, flight_num, departure_time, arrival_time, customer_email, customer_name".split(", ")
    query = f"SELECT DISTINCT airline_name, flight_num, departure_time, arrival_time, customer_email, customer_name FROM customers_list_for_flight WHERE airline_name='{airline}';"

    conn = pool.get_connection()
    cursor = conn.cursor()
    cursor.execute(query)
    data = cursor.fetchall()

    cursor.close()
    conn.close()

    return data, columns

def flightsTakenByCustomer_tab(airline, customer_email):
    columns = "airline_name, flight_num, departure_time, arrival_time".split(",")
    query = f"SELECT DISTINCT airline_name, flight_num, departure_time, arrival_time  FROM customers_list_for_flight WHERE customer_email = '{customer_email}' AND airline_name='{airline}';"

    conn = pool.get_connection()
    cursor = conn.cursor()
    cursor.execute(query)
    data = cursor.fetchall()

    cursor.close()
    conn.close()

    return data, columns

#staff analytics --> 1) Top booking agents by month and year (by tickets and by commission).
def top_agent_by_tickets(airline):
    conn = pool.get_connection()
    cursor = conn.cursor()
    cursor.execute("SELECT YEAR(purchase_date) as Year, MONTH(purchase_date) as Month, agent_email, COUNT(ticket_id) tickets_sold FROM staff_analytics WHERE airline_name = %s AND agent_email IS NOT NULL GROUP BY Year, Month, agent_email ORDER BY Year, Month, tickets_sold DESC", (airline,))
    data = cursor.fetchall()
    cursor.close()
    conn.close()

    top_per_month = []
    seen_months = set()
    for Year, Month, agent_email, tickets_sold in data:
        key = (Year,Month)
        if key not in seen_months:  # first one in descending order = top
            top_per_month.append((Year, Month, agent_email, tickets_sold))
            seen_months.add(key)

    return top_per_month

def top_agent_by_commission(airline):
    conn = pool.get_connection()
    cursor = conn.cursor()
    cursor.execute("SELECT YEAR(purchase_date) as Year, MONTH(purchase_date) as Month, agent_email, SUM(commission) AS total_commission FROM staff_analytics WHERE airline_name = %s AND agent_email IS NOT NULL GROUP BY Year, Month, agent_email ORDER BY Year, Month, total_commission DESC", (airline,))
    data = cursor.fetchall()
    cursor.close()
    conn.close()

    top_per_month = []
    seen_months = set()
    for Year, Month, agent_email, tot_commission in data:
        key = (Year,Month)
        if key not in seen_months:  # first one in descending order = top
            top_per_month.append((Year, Month, agent_email, tot_commission))
            seen_months.add(key)

    return top_per_month

def top_customer_within_year(airline):
    conn = pool.get_connection()
    cursor = conn.cursor()
    cursor.execute("SELECT customer_email, COUNT(ticket_id) as tickets_bought FROM staff_analytics WHERE airline_name = %s AND purchase_date >= DATE_SUB(CURDATE(), INTERVAL 12 MONTH) GROUP BY customer_email ORDER BY tickets_bought DESC LIMIT 1", (airline,))
    data = cursor.fetchone()
    cursor.close()
    conn.close()

    if data:
        return data[0]  # return customer_email
    else:
        return "No data"

def tickets_sold_per_month(airline):
    conn = pool.get_connection()
    cursor = conn.cursor()
    cursor.execute("SELECT YEAR(purchase_date) as Year, MONTH(purchase_date) as Month, COUNT(ticket_id) AS tickets_sold FROM staff_analytics WHERE airline_name = %s GROUP BY Year, Month ORDER BY Year, Month DESC", (airline,))
    data = cursor.fetchall()
    cursor.close()
    conn.close()
    return data

def all_time_delay(airline):
    conn = pool.get_connection()
    cursor = conn.cursor()
    cursor.execute("SELECT COUNT(*) AS flights_delayed FROM staff_analytics WHERE airline_name = %s AND status='delayed'", (airline,))
    data = cursor.fetchall()
    cursor.close()
    conn.close()
    return data

def all_time_onTime(airline):
    conn = pool.get_connection()
    cursor = conn.cursor()
    cursor.execute("SELECT COUNT(*) AS flights_delayed FROM staff_analytics WHERE airline_name = %s AND status='in-progress'", (airline,))
    data = cursor.fetchall()
    cursor.close()
    conn.close()
    return data

def top_destinations(airline, last_n_months): #DATE_SUB(CURDATE(), INTERVAL 6 MONTH)
    conn = pool.get_connection()
    cursor = conn.cursor()
    cursor.execute("SELECT destination_city, SUM(tickets_sold) AS tickets_sold FROM top_destinations WHERE airline_name = %s AND STR_TO_DATE(CONCAT(Year,'-',Month,'-01'), '%Y-%m-%d') >= DATE_SUB(CURDATE(), INTERVAL %s MONTH) GROUP BY destination_city ORDER BY tickets_sold DESC LIMIT 3", (airline,last_n_months))
    data = cursor.fetchall()
    cursor.close()
    conn.close()
    return data

def return_view(view_name):
    query = f"SELECT * FROM {view_name};"

    conn = pool.get_connection()
    cursor = conn.cursor()
    cursor.execute(query)
    data = cursor.fetchall()

    cursor.close()
    conn.close()

    return data