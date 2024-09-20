import psycopg2


conn = psycopg2.connect(
    dbname="library",
    user="ricardo",
    password="3136",
    host="localhost",
    port="5432"
)

# Criar um cursor para executar comandos SQL
cur = conn.cursor()

# Criar tabela com SQL
try:
    cur.execute('''
        CREATE TABLE IF NOT EXISTS location (
            id SERIAL PRIMARY KEY,
            name VARCHAR(100),
            number INT,
            city VARCHAR(50)
        );
    ''')
    conn.commit()

    # Inserir um cliente usando SQL
    insert_query = 'INSERT INTO location (name, number, city) VALUES (%s, %s, %s) RETURNING *'
    cur.execute(insert_query, ('Capitao', 21, 'Bauru'))
    conn.commit()
    inserted_client = cur.fetchone()
    print('Client inserted:', inserted_client)

    # Consultar clientes usando SQL
    select_query = 'SELECT * FROM location WHERE name = %s'
    cur.execute(select_query, ('Capitao',))
    location = cur.fetchall()
    print('Location found:', location)

except Exception as e:
    print(f"Erro ao executar SQL: {e}")
    conn.rollback()

finally:
    cur.close()
    conn.close()