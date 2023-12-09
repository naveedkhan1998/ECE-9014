import psycopg2

db_params = {
    "host": "127.0.0.1",
    "port": 5499,
    "user": "postgres",
    "password": "postgres",
    "database": "ECE9014",
}


def get_conn():
    try:
        connection = psycopg2.connect(**db_params)
        print("Connected to the database")
        cursor = connection.cursor()

        #query = "SELECT * FROM sales.orders;"
        #cursor.execute(query)

        #results = cursor.fetchall()
        #for row in results:
            # print(row)
         

    except psycopg2.Error as e:
        print("Unable to connect to the database")
        print(e)

    finally:
        # if connection:
        # connection.close()
        return connection,cursor