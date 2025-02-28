from flask import Flask, render_template, request, redirect, url_for
from flask_mysqldb import MySQL
import MySQLdb.cursors

app = Flask(__name__)
app.config.from_pyfile('config.py')
mysql = MySQL(app)


# Главная страница
@app.route('/')
def index():
    cursor = mysql.connection.cursor(MySQLdb.cursors.DictCursor)
    cursor.execute("""
        SELECT b.id_bicycle, b.brand, b.model, b.status, rp.name AS rental_point,
               IFNULL(AVG(TIMESTAMPDIFF(HOUR, r.rental_start, r.rental_end)), 0) AS avg_rent_duration
        FROM bicycles b
        JOIN rental_point rp ON b.rental_point_id_rental_point = rp.id_rental_point
        LEFT JOIN rent r ON b.id_bicycle = r.bicycles_id_bicycle
        GROUP BY b.id_bicycle, b.brand, b.model, b.status, rp.name
    """)
    bikes = cursor.fetchall()

    return render_template('index.html', bikes=bikes)


# История всех аренд
@app.route('/history')
def history():
    cursor = mysql.connection.cursor(MySQLdb.cursors.DictCursor)
    cursor.execute("""
        SELECT rent.id_rent, clients.name AS client_name, bicycles.brand, bicycles.model, 
               rp1.name AS start_point, rp2.name AS end_point, rent.rental_start, rent.rental_end 
        FROM rent
        JOIN clients ON rent.clients_id_client = clients.id_client
        JOIN bicycles ON rent.bicycles_id_bicycle = bicycles.id_bicycle
        JOIN rental_point rp1 ON rent.start_rent_point = rp1.id_rental_point
        LEFT JOIN rental_point rp2 ON rent.end_rental_point = rp2.id_rental_point
        ORDER BY rent.rental_start DESC
    """)

    rentals = cursor.fetchall()
    return render_template('history.html', rentals=rentals)


# История проката конкретного велосипеда
@app.route('/bike/<int:bike_id>')
def bike_history(bike_id):
    cursor = mysql.connection.cursor(MySQLdb.cursors.DictCursor)
    cursor.execute("""
        SELECT rent.id_rent, clients.name AS client_name, bicycles.brand, bicycles.model, 
               rp1.name AS start_point, rp2.name AS end_point, rent.rental_start, rent.rental_end 
        FROM rent
        JOIN clients ON rent.clients_id_client = clients.id_client
        JOIN bicycles ON rent.bicycles_id_bicycle = bicycles.id_bicycle
        JOIN rental_point rp1 ON rent.start_rent_point = rp1.id_rental_point
        LEFT JOIN rental_point rp2 ON rent.end_rental_point = rp2.id_rental_point
        WHERE rent.bicycles_id_bicycle = %s
        ORDER BY rent.rental_start DESC
    """, (bike_id,))
    rentals = cursor.fetchall()
    return render_template('bike_history.html', rentals=rentals)


# ------------------ УПРАВЛЕНИЕ ВЕЛОСИПЕДАМИ ------------------

@app.route('/bikes')
def manage_bikes():
    cursor = mysql.connection.cursor(MySQLdb.cursors.DictCursor)
    cursor.execute("SELECT * FROM bicycles")
    bikes = cursor.fetchall()
    return render_template('manage_bikes.html', bikes=bikes)


@app.route('/bike/add', methods=['POST'])
def add_bike():
    brand = request.form['brand']
    model = request.form['model']
    status = request.form['status']
    rental_point = request.form['rental_point']

    cursor = mysql.connection.cursor()
    cursor.execute("INSERT INTO bicycles (brand, model, status, rental_point_id_rental_point) VALUES (%s, %s, %s, %s)",
                   (brand, model, status, rental_point))
    mysql.connection.commit()
    return redirect(url_for('manage_bikes'))


# ------------------ УПРАВЛЕНИЕ КЛИЕНТАМИ ------------------

@app.route('/clients')
def manage_clients():
    cursor = mysql.connection.cursor(MySQLdb.cursors.DictCursor)
    cursor.execute("SELECT * FROM clients")
    clients = cursor.fetchall()
    return render_template('manage_clients.html', clients=clients)


@app.route('/client/add', methods=['POST'])
def add_client():
    name = request.form['name']
    number = request.form['number']
    registration_date = request.form['registration_date']

    cursor = mysql.connection.cursor()
    cursor.execute("INSERT INTO clients (name, number, registration_date) VALUES (%s, %s, %s)",
                   (name, number, registration_date))
    mysql.connection.commit()
    return redirect(url_for('manage_clients'))


if __name__ == '__main__':
    app.run(debug=True)
