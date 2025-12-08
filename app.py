from flask import Flask, render_template, request, url_for, redirect, session
from mysql.connector.pooling import MySQLConnectionPool
from views import upcomingFlightsView, inProgressFlightsView, purchasedFlightsView_customer, return_view, return_confirm_flight_to_purchase, custSpendingStats, purchasedFlightsView_agent, browseFlightsByAirline, upcomingFlightsByAirline, passengersPerFlight
from supplemental_funcs import (
    check_special_perm, check_related_airline,
    create_purchase_ticket_transaction,
    airplanes_for_airline, airports_list,
    list_of_agents, list_of_customers
)
import datetime
from db import pool
from werkzeug.security import generate_password_hash, check_password_hash
import mysql.connector 
from supplemental_funcs import compute_monthly_totals
from views import topCustomer_byTickets, topCustomer_byCommission, commission_totals_last_30, average_commission_last_30, num_tickets_sold_all_time



#Initialize the app from Flask
app = Flask(__name__)
app.secret_key = "yeah a secret key"


#Define a route to hello function
@app.route('/')
def hello():
    if 'username' in session:
        return redirect(url_for('home'))
    return render_template('index.html')

@app.route('/home')
def home():
    if 'username' not in session:
        return render_template('index.html')
    
    return render_template('home.html', usertype=session.get("user_type"),specialperm =session.get("special_perm"))

@app.route('/login', methods = ['GET', 'POST'])
def login():
    return render_template('login.html')

@app.route('/loginAuth', methods=['GET', 'POST'])
def loginAuth():
    username = request.form['username']
    password = request.form['password']
    user_type = request.form['user_type']

    my_dict = {
        "agent": ("booking_agent", "email"),
        "customer": ("customer", "email"),
        "airline_staff": ("airline_staff", "username"),
    }
    table, username_col = my_dict[user_type]

    conn = pool.get_connection()
    cursor = conn.cursor(dictionary=True)

    # ONLY filter by username/email
    query = f"SELECT * FROM {table} WHERE {username_col} = %s"
    cursor.execute(query, (username,))
    row = cursor.fetchone()

    cursor.close()
    conn.close()

    # row["password"] contains the HASH now
    if row and check_password_hash(row["password"], password):
        session['username'] = username
        session['user_type'] = user_type
        session['special_perm'] = check_special_perm(username, user_type)
        session['associated_airline'] = check_related_airline(username, user_type)
        return redirect(url_for('home'))

    return render_template('login.html', error="Error: invalid username or password")

    
@app.route('/logout')
def logout():
    # fully release the session (clears username, user_type, perms, airline, etc.)
    session.clear()
    return redirect(url_for('home'))  # or redirect('/')


#Define route for register
@app.route('/register-directory')
def registerIndex():
    return render_template('register-index.html')

# Show each registration form
@app.route('/register-customer')
def registerCustomerPage():
    return render_template('register-customer.html')

@app.route('/register-agent')
def registerAgentPage():
    return render_template('register-agent.html')

@app.route('/register-staff')
def registerStaffPage():
    return render_template('register-staff.html')


# Handle form submissions (HASH + INSERT)
@app.route('/registerCustomerAuth', methods=['POST'])
def registerCustomerAuth():
    email = request.form['email'].strip()
    name = request.form['name'].strip()
    password = request.form['password']
    pw_hash = generate_password_hash(password)

    conn = pool.get_connection()
    cur = conn.cursor()
    try:
        cur.execute(
            "INSERT INTO customer (email, name, password) VALUES (%s, %s, %s)",
            (email, name, pw_hash)
        )
        conn.commit()
        return redirect(url_for('login'))
    except mysql.connector.IntegrityError:
        conn.rollback()
        return render_template('register-customer.html', error="Email already exists.")
    finally:
        cur.close(); conn.close()


@app.route('/registerAgentAuth', methods=['POST'])
def registerAgentAuth():
    email = request.form['email'].strip()
    password = request.form['password']
    pw_hash = generate_password_hash(password)

    conn = pool.get_connection()
    cur = conn.cursor()
    try:
        cur.execute(
            "INSERT INTO booking_agent (email, password) VALUES (%s, %s)",
            (email, pw_hash)
        )
        conn.commit()
        return redirect(url_for('login'))
    except mysql.connector.IntegrityError:
        conn.rollback()
        return render_template('register-agent.html', error="Email already exists.")
    finally:
        cur.close(); conn.close()


@app.route('/registerStaffAuth', methods=['POST'])
def registerStaffAuth():
    username = request.form['username'].strip()
    password = request.form['password']
    airline_name = request.form['airline_name'].strip()
    permission_type = request.form['permission_type'].strip()  # "admin" or "operator"
    pw_hash = generate_password_hash(password)

    conn = pool.get_connection()
    cur = conn.cursor()
    try:
        cur.execute(
            "INSERT INTO airline_staff (username, password, airline_name) VALUES (%s, %s, %s)",
            (username, pw_hash, airline_name)
        )
        cur.execute(
            "INSERT INTO permission (permission_type, airline_staff_username) VALUES (%s, %s)",
            (permission_type, username)
        )
        conn.commit()
        return redirect(url_for('login'))
    except mysql.connector.IntegrityError:
        conn.rollback()
        return render_template(
            'register-staff.html',
            error="Username already exists, airline_name invalid, or permission invalid."
        )
    finally:
        cur.close(); conn.close()

"""
General pages, anyone can access -->
"""
@app.route('/upcomingFlights')
def upcomingFlights():
    return render_template('upcomingFlights.html',table=upcomingFlightsView())

@app.route('/flightStatus')
def inProgressFlights():
    return render_template('in-progress-flight.html',table=inProgressFlightsView())

"""
Pages only customer can access -->
"""
@app.route('/purchasedFlights')
def purchasedFlightsCust():
    if 'username' not in session:
        return redirect(url_for('home'))
    elif session.get("user_type") != 'customer':
        return render_template('home.html', usertype=session.get("user_type"),specialperm =session.get("special_perm"))
    
    table, columns=purchasedFlightsView_customer(session.get("username"))
    return render_template('purchasedFlights-customer.html',table=table,columns=columns)
    
        

@app.route('/browseFlights')
def browseToPurchase():
    if 'username' not in session:
        return redirect(url_for('home'))
    elif session.get("user_type") != 'customer':
        if session.get("user_type") == 'agent':
            return redirect(url_for('browseFlightsAgent'))
        return render_template('home.html', usertype=session.get("user_type"),specialperm =session.get("special_perm"))
    
    table = return_view('browse_flights')
    return render_template('browse-customer.html',table=table)

@app.route('/checkoutPage')
def customerCheckout():
    if 'username' not in session:
        return redirect(url_for('home'))
    elif session.get("user_type") != 'customer':
        return render_template('home.html', usertype=session.get("user_type"),specialperm =session.get("special_perm"))
    
    airline = request.args.get('airline')
    flight_num = request.args.get('flightnum')

    flight_info_row, columns = return_confirm_flight_to_purchase(airline,flight_num)

    return render_template('checkout.html',flight_row = flight_info_row, columns=columns)

@app.route('/completePurchase', methods=['POST'])
def completePurchase():
    if 'username' not in session:
        return redirect(url_for('home'))
    elif session.get("user_type") != 'customer':
        return render_template('home.html', usertype=session.get("user_type"),specialperm =session.get("special_perm"))
    
    airline = request.form.get('airline')
    flight_num = request.form.get('flight_num')
    cust_username = session.get("username")
    num_tickets = int(request.form.get("quantity"))

    #try to create tickets and purchases, add to database
    #airline, flight_num, customer_email,num_tickets
    create_purchase_ticket_transaction(airline,flight_num,cust_username,num_tickets)

    return redirect(url_for('purchaseConfirmation'))

@app.route('/purchase-confirmation')
def purchaseConfirmation():
    return render_template("confirmation-page.html")

@app.route('/spendingStats')
def customerSpending():
    if 'username' not in session:
        return redirect(url_for('home'))
    elif session.get("user_type") != 'customer':
        return render_template('home.html', usertype=session.get("user_type"),specialperm =session.get("special_perm"))

    username = session["username"]
    #default date range
    start_date = datetime.datetime.now() - datetime.timedelta(days=365)
    end_date = datetime.datetime.now()

    #table entries
    purchase_rows = custSpendingStats(username,start_range=start_date,end_range=end_date)
    
    #monthly totals
    monthly_totals = compute_monthly_totals(purchase_rows, last_n_months=6)

    return render_template('spending-stats.html',table=purchase_rows, monthly=monthly_totals, start_date=start_date, end_date=end_date)

    @app.route('/spendingStats/data') #for updates to time range
    def spendingStatsData():
        if 'username' not in session:
            return redirect(url_for('home'))
        elif session.get("user_type") != 'customer':
            return render_template('home.html', usertype=session.get("user_type"),specialperm =session.get("special_perm"))

    username = session["username"]

    # read query params
    start_date_str = request.args.get("start")
    end_date_str = request.args.get("end")

    #get date range from input
    start_date = datetime.datetime.strptime(start_date_str, "%Y-%m-%d")
    end_date = datetime.datetime.strptime(end_date_str, "%Y-%m-%d")

    #get number of months to do for graph
    n_months = (end_date.year - start_date.year) * 12 + (end_date.month - start_date.month) + 1

    # get new subtable that falls within time range
    filtered_table = custSpendingStats(username, start_range=start_date,end_range=end_date)

    # recompute monthly totals for the filtered period
    monthly_totals = compute_monthly_totals(filtered_table, last_n_months=n_months)

    return {
    "rows": filtered_table,
    "monthly_labels": list(monthly_totals.keys()),
    "monthly_values": list(monthly_totals.values())
    }

"""
agent POV
"""
@app.route('/purchasedFlightsA')
def purchasedFlightsAgent():
    if 'username' not in session:
        return redirect(url_for('home'))
    elif session.get("user_type") != 'agent':
        return render_template('home.html', usertype=session.get("user_type"),specialperm =session.get("special_perm"))
    
    table, columns= purchasedFlightsView_agent(session.get("username"))

    return render_template('purchasedFlights-agent.html',columns=columns,table=table)

@app.route('/browseFlightsA')
def browseFlightsAgent():
    if 'username' not in session:
        return redirect(url_for('home'))
    elif session.get("user_type") != 'agent':
        return render_template('home.html', usertype=session.get("user_type"),specialperm =session.get("special_perm"))
    
    return render_template('browse-agent.html',table=browseFlightsByAirline(session.get('associated_airline')))

@app.route('/analyticsA')
def analyticsA():
    if 'username' not in session:
        return redirect(url_for('home'))
    elif session.get("user_type") != 'agent':   
        return render_template('home.html', usertype=session.get("user_type"),specialperm =session.get("special_perm"))

    agent_email = session.get('username')
    commissions_total = commission_totals_last_30(agent_email)
    avg_commission = average_commission_last_30(agent_email)
    num_tickets_sold = num_tickets_sold_all_time(agent_email)

    top5_by_tickets_data = topCustomer_byTickets(agent_email) #last 6 months
    top5_by_commission_data = topCustomer_byCommission(agent_email) #last 12 months

    ticket_labels = [row[0] for row in top5_by_tickets_data] # customer_email
    ticket_values = [row[1] for row in top5_by_tickets_data] # ticket count

    commission_labels = [row[0] for row in top5_by_commission_data] # customer_email
    commission_values = [row[1] for row in top5_by_commission_data] # total commission
    return render_template('analytics-agent.html',commissions_total=commissions_total, avg_commission=avg_commission, num_tickets_sold=num_tickets_sold, ticket_labels=ticket_labels,ticket_values=ticket_values,commission_labels=commission_labels,commission_values=commission_values)


@app.route('/checkoutAgent')
def checkoutAgent():
    if 'username' not in session:
        return redirect(url_for('home'))
    elif session.get("user_type") != 'agent':
        return render_template('home.html', usertype=session.get("user_type"),specialperm =session.get("special_perm"))

    airline = request.args.get('airline')
    flight_num = request.args.get('flightnum')
    agent_email = session.get("username")

    flight_info_row, columns = return_confirm_flight_to_purchase(airline,flight_num)

    return render_template('checkout.html',flight_row = flight_info_row, columns=columns, custlist=list_of_customers())


@app.route('/completePurchaseAgent', methods=['POST'])
def completePurchaseAgent():
    if 'username' not in session:
        return redirect(url_for('home'))
    elif session.get("user_type") != 'agent':
        return render_template('home.html', usertype=session.get("user_type"),specialperm =session.get("special_perm"))

    print("I trying to purchase.")
    airline = request.form.get('airline')
    flight_num = request.form.get('flight_num')
    cust_username = request.form.get('cust_username')
    agent_email = session.get("username")
    num_tickets = int(request.form.get("quantity"))

    #try to create tickets and purchases, add to database
    #airline, flight_num, customer_email,num_tickets

    print("I tried to purchase.")

    create_purchase_ticket_transaction(airline,flight_num,cust_username,num_tickets,agent_email=agent_email)

    return redirect(url_for('purchaseConfirmation'))


"""
Airline staff -->
"""
@app.route('/upcomingFlightsStaff')
def upcomingFlightsStaff():
    if 'username' not in session:
        return redirect(url_for('home'))
    elif session.get("user_type") != 'airline_staff':
        return render_template('home.html', usertype=session.get("user_type"),specialperm =session.get("special_perm"))
    
    return render_template('upcomingFlights.html',table=upcomingFlightsByAirline(session.get('associated_airline')[0]))

@app.route('/passengerList') #filter by 1) flight or 2) customer
def passengerList():
    if 'username' not in session:
        return redirect(url_for('home'))
    elif session.get("user_type") != 'airline_staff':
        return render_template('home.html', usertype=session.get("user_type"),specialperm =session.get("special_perm"))
    
    table, columns = passengersPerFlight(session.get('associated_airline')[0])
    return render_template('passengerList.html',table=table,columns=columns)

@app.route('/analyticsStaff')
def analyticsStaff():
    if 'username' not in session:
        return redirect(url_for('home'))
    elif session.get("user_type") != 'airline_staff':
        return render_template('home.html', usertype=session.get("user_type"),specialperm =session.get("special_perm"))
    
    return render_template('analytics-staff.html')

"""
special permissions -->
"""
# CONSIDER routing to page asking if wants to add another entry.
@app.route('/addAirport') #potentially adds new city
def addAirport():
    if 'username' not in session:
        return redirect(url_for('home'))
    elif session.get("user_type") != 'airline_staff':
        return redirect(url_for('home'))
    elif 'admin' not in session.get("special_perm"):
        return redirect(url_for('home'))

    return render_template('admin-add.html',add_type="airport")

@app.route('/addAirplane')
def addAirplane():
    if 'username' not in session:
        return redirect(url_for('home'))
    elif session.get("user_type") != 'airline_staff':
        return redirect(url_for('home'))
    elif 'admin' not in session.get("special_perm"):
        return redirect(url_for('home'))
    
    return render_template('admin-add.html', add_type="airplane", airline=session.get('associated_airline')[0])


@app.route('/createFlight')
def createFlight():
    if 'username' not in session:
        return redirect(url_for('home'))
    elif session.get("user_type") != 'airline_staff':
        return redirect(url_for('home'))
    elif 'admin' not in session.get("special_perm"):
        return redirect(url_for('home'))
    
    airline_name = session.get('associated_airline')[0]
    list_of_planes = airplanes_for_airline(airline_name)
    list_of_airports = airports_list()
    return render_template('admin-add.html',add_type="flight", airline=airline_name, planeIDs=list_of_planes, airports=list_of_airports)

@app.route('/assignAgent')
def assignAgent():
    if 'username' not in session:
        return redirect(url_for('home'))
    elif session.get("user_type") != 'airline_staff':
        return redirect(url_for('home'))
    elif 'admin' not in session.get("special_perm"):
        return redirect(url_for('home'))
    
    airline_name = session.get('associated_airline')[0]
    agents = list_of_agents()
    return render_template('admin-add.html', add_type="assignAgent", airline=airline_name, agents=agents)


# *update status --> operator permission
@app.route('/updateStatus')
def updateStatus():
    if 'username' not in session:
        return redirect(url_for('home'))
    elif session.get("user_type") != 'airline_staff':
        return redirect(url_for('home'))
    elif 'operator' not in session.get("special_perm"):
        return redirect(url_for('home'))

    airline_name = session.get('associated_airline')[0]

    conn = pool.get_connection()
    cur = conn.cursor()
    try:
        cur.execute("""
            SELECT flight_num, departure_time, arrival_time,
                   departure_airport, arrival_airport, status
            FROM flight
            WHERE airline_name = %s
            ORDER BY departure_time DESC
        """, (airline_name,))
        flights = cur.fetchall()
    finally:
        cur.close()
        conn.close()

    return render_template('modify-status.html', airline=airline_name, flights=flights)

@app.route('/confirmStatusUpdate', methods=['POST'])
def confirmStatusUpdate():
    if 'username' not in session:
        return redirect(url_for('home'))
    elif session.get("user_type") != 'airline_staff':
        return redirect(url_for('home'))
    elif 'operator' not in session.get("special_perm"):
        return redirect(url_for('home'))

    airline_name = session.get('associated_airline')[0]
    flight_num = (request.form.get('flight-num') or "").strip()
    new_status = (request.form.get('new-status') or "").strip()

    allowed = {"upcoming", "in-progress", "delayed"}
    if (not flight_num) or (new_status not in allowed):
        # re-render with error + flight list
        return _render_modify_status(airline_name, error="Invalid flight or invalid status.")

    conn = pool.get_connection()
    cur = conn.cursor()
    try:
        cur.execute("""
            UPDATE flight
            SET status = %s
            WHERE flight_num = %s AND airline_name = %s
        """, (new_status, flight_num, airline_name))

        if cur.rowcount == 0:
            conn.rollback()
            return _render_modify_status(airline_name, error="Flight not found for your airline.")
        else:
            conn.commit()
            return _render_modify_status(airline_name, success=f"✅ Updated {flight_num} to '{new_status}'.")
    except mysql.connector.Error:
        conn.rollback()
        return _render_modify_status(airline_name, error="Database error while updating status.")
    finally:
        cur.close()
        conn.close()


def _render_modify_status(airline_name, success=None, error=None):
    conn = pool.get_connection()
    cur = conn.cursor()
    try:
        cur.execute("""
            SELECT flight_num, departure_time, arrival_time,
                   departure_airport, arrival_airport, status
            FROM flight
            WHERE airline_name = %s
            ORDER BY departure_time DESC
        """, (airline_name,))
        flights = cur.fetchall()
    finally:
        cur.close()
        conn.close()

    return render_template('modify-status.html', airline=airline_name, flights=flights,
                           success=success, error=error)

@app.route('/confirmAddition', methods=['POST'])
def confirmAddition():
    if 'username' not in session:
        return redirect(url_for('home'))
    if session.get("user_type") != 'airline_staff':
        return redirect(url_for('home'))
    if 'admin' not in session.get("special_perm"):
        return redirect(url_for('home'))

    add_type = request.form.get('add-type')

    # ---------- ADD AIRPORT ----------
    if add_type == "airport":
        airport_name = (request.form.get('airport-name') or "").strip().upper()
        city_name = (request.form.get('city-name') or "").strip()

        if not airport_name or not city_name:
            return render_template('admin-add.html', add_type="airport",
                                   error="Airport name and city name are required.")

        conn = pool.get_connection()
        cur = conn.cursor()
        try:
            cur.execute("SELECT 1 FROM city WHERE name = %s", (city_name,))
            if cur.fetchone() is None:
                cur.execute("INSERT INTO city (name) VALUES (%s)", (city_name,))

            cur.execute("INSERT INTO airport (name, city) VALUES (%s, %s)", (airport_name, city_name))
            conn.commit()

            return render_template('admin-add.html', add_type="airport",
                                   success=f"Airport {airport_name} added in {city_name}.")
        except mysql.connector.IntegrityError:
            conn.rollback()
            return render_template('admin-add.html', add_type="airport",
                                   error=f"Could not add airport. '{airport_name}' may already exist.")
        finally:
            cur.close()
            conn.close()

    # ---------- ADD AIRPLANE ----------
    elif add_type == "airplane":
        airline_name = session.get('associated_airline')[0]

        raw_plane_id = (request.form.get('plane-id') or "").strip()
        raw_capacity = (request.form.get('plane-capacity') or "").strip()

        try:
            plane_id = int(raw_plane_id)
            seat_capacity = int(raw_capacity)
        except ValueError:
            return render_template('admin-add.html', add_type="airplane", airline=airline_name,
                                   error="Plane ID and capacity must be integers.")

        if plane_id <= 0 or seat_capacity <= 0:
            return render_template('admin-add.html', add_type="airplane", airline=airline_name,
                                   error="Plane ID and capacity must be positive.")

        conn = pool.get_connection()
        cur = conn.cursor()
        try:
            cur.execute("SELECT 1 FROM airplane WHERE airline_name=%s AND id=%s", (airline_name, plane_id))
            if cur.fetchone() is not None:
                return render_template('admin-add.html', add_type="airplane", airline=airline_name,
                                       error=f"Plane ID {plane_id} already exists for {airline_name}.")

            cur.execute(
                "INSERT INTO airplane (airline_name, id, seat_capacity) VALUES (%s, %s, %s)",
                (airline_name, plane_id, seat_capacity)
            )
            conn.commit()

            return render_template('admin-add.html', add_type="airplane", airline=airline_name,
                                   success=f"Airplane {plane_id} added for {airline_name} (capacity {seat_capacity}).")
        except mysql.connector.IntegrityError:
            conn.rollback()
            return render_template('admin-add.html', add_type="airplane", airline=airline_name,
                                   error="Could not add airplane (duplicate ID or invalid airline).")
        finally:
            cur.close()
            conn.close()

        # ADD FLIGHT
    elif add_type == "flight":
        # admin-only already enforced above, same as airport/airplane
        airline_name = session.get('associated_airline')[0]

        flight_num = request.form['flight-num'].strip()
        dep_time  = request.form['departure-time'].strip()
        arr_time  = request.form['arrival-time'].strip()
        price     = request.form['ticket-price'].strip()
        plane_id  = request.form['plane-id'].strip()
        dep_airpt = request.form['departure-airport'].strip().upper()
        arr_airpt = request.form['arrival-airport'].strip().upper()

        # minimal validation
        if dep_airpt == arr_airpt:
            return render_template('admin-add.html', add_type="flight", airline=airline_name,
                                   planeIDs=airplanes_for_airline(airline_name),
                                   airports=airports_list(),
                                   error="Departure and arrival airports cannot be the same.")

        conn = pool.get_connection()
        cur = conn.cursor()
        try:
            cur.execute("""
                INSERT INTO flight
                    (flight_num, airline_name, departure_time, arrival_time, price, status,
                     airplane_id, departure_airport, arrival_airport)
                VALUES
                    (%s, %s, %s, %s, %s, 'upcoming', %s, %s, %s)
            """, (flight_num, airline_name, dep_time, arr_time, float(price),
                  int(plane_id), dep_airpt, arr_airpt))
            conn.commit()

            return render_template('admin-add.html', add_type="flight", airline=airline_name,
                                   planeIDs=airplanes_for_airline(airline_name),
                                   airports=airports_list(),
                                   success=f"Flight {flight_num} created.")
        except mysql.connector.Error:
            conn.rollback()
            return render_template('admin-add.html', add_type="flight", airline=airline_name,
                                   planeIDs=airplanes_for_airline(airline_name),
                                   airports=airports_list(),
                                   error="Could not create flight. Check flight/airplane/airport values.")
        finally:
            cur.close()
            conn.close()

  
    # ---------- ASSIGN AGENT TO AIRLINE ----------
    elif add_type == "assignAgent":
        airline_name = session.get('associated_airline')[0]  # trust session, not the hidden field
        agent_email = (request.form.get('agent') or "").strip()

        if not agent_email:
            return render_template(
                'admin-add.html',
                add_type="assignAgent",
                airline=airline_name,
                agents=list_of_agents(),
                error="Agent email is required."
            )

        conn = pool.get_connection()
        cur = conn.cursor()
        try:
            # Ensure agent exists (friendlier than only relying on FK error)
            cur.execute("SELECT 1 FROM booking_agent WHERE email=%s", (agent_email,))
            if cur.fetchone() is None:
                return render_template(
                    'admin-add.html',
                    add_type="assignAgent",
                    airline=airline_name,
                    agents=list_of_agents(),
                    error=f"Agent '{agent_email}' does not exist."
                )

            # Insert relationship
            cur.execute(
                "INSERT INTO authorized_by (agent_email, airline_name) VALUES (%s, %s)",
                (agent_email, airline_name)
            )
            conn.commit()

            return render_template(
                'admin-add.html',
                add_type="assignAgent",
                airline=airline_name,
                agents=list_of_agents(),
                success=f"Assigned {agent_email} to {airline_name}."
            )

        except mysql.connector.IntegrityError:
            conn.rollback()
            return render_template(
                'admin-add.html',
                add_type="assignAgent",
                airline=airline_name,
                agents=list_of_agents(),
                error=f"That agent is already authorized for {airline_name} (or invalid data)."
            )
        finally:
            cur.close()
            conn.close()


    # ---------- FALLBACK ----------
    else:
        return render_template('admin-add.html', add_type=add_type, error="Unsupported add-type.")



# for the city-alias twist
@app.context_processor
def inject_city_aliases():
    conn = pool.get_connection()
    cur = conn.cursor()
    cur.execute("SELECT alias_name, city_name FROM city_alias")
    rows = cur.fetchall()
    cur.close()
    conn.close()
    return {"city_aliases": rows}


if __name__ == "__main__":
    app.run('127.0.0.1', 5000, debug = True)


