# Tutorial PostgreSQL

## 1. Instalar PostgreSQL

Abra o terminal e execute os seguintes comandos:

```bash
# Atualize os repositórios de pacotes
sudo apt update

# Instale o PostgreSQL
sudo apt install postgresql postgresql-contrib
```

Para mais detalhes sobre a instalação, consulte a [Documentação Oficial do PostgreSQL - Instalação](https://www.postgresql.org/docs/current/installation.html).

## 2. Verificar se o PostgreSQL está rodando

Após a instalação, verifique o status do serviço:

```bash
sudo systemctl status postgresql
```

Para iniciar ou parar o serviço, use:

```bash
# Iniciar o serviço
sudo systemctl start postgresql

# Parar o serviço
sudo systemctl stop postgresql
```

Para mais informações, consulte a seção sobre [Iniciar e Parar o PostgreSQL](https://www.postgresql.org/docs/current/server-start.html).

## 3. Acessar o PostgreSQL usando `psql`

Por padrão, o PostgreSQL cria um usuário `postgres`. Para acessá-lo, use o seguinte comando:

```bash
# Acesse o PostgreSQL como usuário postgres
sudo -u postgres psql
```

Para detalhes sobre como usar o `psql`, veja a [Documentação Oficial do PostgreSQL - psql](https://www.postgresql.org/docs/current/app-psql.html).

## 4. Criar um novo usuário (role)

Para criar um novo usuário com uma senha:

```sql
CREATE USER meu_usuario WITH PASSWORD 'minha_senha';
```

Para mais detalhes sobre gerenciamento de usuários, consulte a [Documentação Oficial do PostgreSQL - Roles e Usuários](https://www.postgresql.org/docs/current/user-manag.html).

### Importante sobre Superusuário:
Se você criar um superusuário, ele terá permissões para realizar todas as ações em qualquer banco de dados, sem necessidade de permissões específicas. Para conceder privilégios de superusuário:

```sql
ALTER USER meu_usuario WITH SUPERUSER;
```

## 5. Criar um novo banco de dados

Para criar um banco de dados:

```sql
CREATE DATABASE meu_banco;
```

Para mais informações, veja a [Documentação Oficial do PostgreSQL - Comando CREATE DATABASE](https://www.postgresql.org/docs/current/sql-createdatabase.html).

### Conectar-se ao banco de dados dentro do `psql`

Para conectar-se a outro banco de dados a partir de dentro do `psql`:

```sql
\c meu_banco
```

Para mais detalhes sobre como conectar-se a bancos de dados, consulte a [Documentação do psql](https://www.postgresql.org/docs/current/app-psql.html#APP-PSQL-META-COMMANDS).

---

## 6. Conectar-se ao PostgreSQL remotamente

Para conectar-se localmente ao PostgreSQL ou em uma máquina remota, você pode usar o seguinte comando no terminal:

```bash
psql -U meu_usuario -h localhost -d meu_banco
```

Veja mais sobre strings de conexão na [Documentação do PostgreSQL - Conexões](https://www.postgresql.org/docs/current/libpq-connect.html).

### 6.1 Modelo de string de conexão

Aqui está um exemplo de string de conexão completa:

```bash
psql postgresql://meu_usuario:minha_senha@192.168.1.100:5432/meu_banco
```

---

## 7. Criar uma tabela

Crie uma tabela simples para os clientes:

```sql
CREATE TABLE clientes (
    id SERIAL PRIMARY KEY,
    nome VARCHAR(100),
    idade INT,
    cidade VARCHAR(50)
);
```

Para mais informações sobre a criação de tabelas, veja a [Documentação Oficial do PostgreSQL - Comando CREATE TABLE](https://www.postgresql.org/docs/current/sql-createtable.html).

---

## 8. Inserir dados

Para inserir vários clientes na tabela:

```sql
INSERT INTO clients (name, age, city) VALUES ('João', 30, 'São Paulo');
INSERT INTO clients (name, age, city) VALUES ('Maria', 25, 'Rio de Janeiro');
```

Veja mais detalhes na [Documentação do PostgreSQL - Comando INSERT](https://www.postgresql.org/docs/current/sql-insert.html).

---

## 9. Criar uma tabela de pedidos com `FOREIGN KEY`

Agora, crie uma tabela de pedidos relacionada aos clientes:

```sql
CREATE TABLE orders (
    id SERIAL PRIMARY KEY,
    customer_id INT REFERENCES clients(id),
    amount DECIMAL(10, 2),
    order_date DATE
);
```

Para mais informações sobre chaves estrangeiras, veja a [Documentação Oficial do PostgreSQL - Chaves Estrangeiras](https://www.postgresql.org/docs/current/ddl-constraints.html#DDL-CONSTRAINTS-FK).

---

## 10. Inserir dados com relação (chave estrangeira)

Adicione alguns pedidos para os clientes:

```sql
INSERT INTO orders (customer_id, amount, order_date) VALUES (1, 150.00, '2024-09-01');
```

---

## 11. Fazer `INNER JOIN`

Para fazer uma consulta utilizando `INNER JOIN` entre as tabelas relacionadas:

```sql
SELECT clients.name, orders.amount, orders.order_date
FROM clients
INNER JOIN orders ON clients.id = orders.customer_id;
```

Veja mais sobre consultas com `JOIN` na [Documentação Oficial do PostgreSQL - JOIN](https://www.postgresql.org/docs/current/queries-table-expressions.html#QUERIES-JOIN).

---

## 11.1 Fazer relação N:N `Junction table`

```sql
CREATE TABLE clients_products (
  client_id INT REFERENCES clients(id) ON DELETE CASCADE,
  product_id INT REFERENCES products(id) ON DELETE CASCADE,
  PRIMARY KEY (client_id, product_id)
);

```
```sql
INSERT INTO clients_products (client_id, product_id) VALUES
(1, 1), -- Ana purchases Laptop
(1, 3), -- Ana purchases Wireless Mouse
(2, 2), -- Pedro purchases Smartphone
(3, 4), -- Laura purchases Monitor
(4, 5), -- Lucas purchases Keyboard
(4, 6), -- Lucas purchases External Hard Drive
(5, 7), -- Isabela purchases USB-C Hub
(6, 8), -- Renato purchases Webcam
(7, 9), -- Juliana purchases Gaming Chair
(8, 10); -- Roberto purchases Bluetooth Speaker
```

Query the relationships between clients and products as follows:

```sql
SELECT c.name AS client_name, p.product_name
FROM clients c
JOIN clients_products cp ON c.id = cp.client_id
JOIN products p ON cp.product_id = p.id;
```

The output

```sql
client_name |    product_name     
-------------+---------------------
 Ana         | Laptop
 Ana         | Wireless Mouse
 Pedro       | Smartphone
 Laura       | Monitor
 Lucas       | Keyboard
 Lucas       | External Hard Drive
 Isabela     | USB-C Hub
 Renato      | Webcam
 Juliana     | Gaming Chair
 Roberto     | Bluetooth Speaker


```
### DELETE CASCADE

The ON DELETE CASCADE clause in the CREATE TABLE statement specifies what should happen to the rows in the clients_products table if a referenced row in the clients or products table is deleted.

What ON DELETE CASCADE Means:
ON DELETE CASCADE: When a row in the referenced table (clients or products) is deleted, all rows in the clients_products table that reference that row will also be automatically deleted.


---

## 12. Fazer SELECT com agregadores

Para calcular a soma dos valores de pedidos por cliente:

```sql
SELECT clients.name, SUM(orders.amount) AS total_gasto
FROM clients
INNER JOIN orders ON clients.id = orders.customer_id
GROUP BY clients.name;
```

Veja mais sobre agregadores na [Documentação Oficial do PostgreSQL - Funções de Agregação](https://www.postgresql.org/docs/current/functions-aggregate.html).

---

## 13. Fazer SELECT com `LIMIT` e `ORDER BY`

Para ordenar e limitar os resultados:

```sql
SELECT * FROM clientes ORDER BY idade DESC LIMIT 3;
```

Veja mais sobre os comandos `LIMIT` e `ORDER BY` na [Documentação Oficial do PostgreSQL](https://www.postgresql.org/docs/current/queries-limit.html).

---

## 14. Exemplos de `WHERE`

Alguns exemplos de filtros utilizando `WHERE`:

- Selecionar clientes de uma cidade específica:

```sql
SELECT * FROM clientes WHERE cidade = 'São Paulo';
```

Veja mais sobre o comando `WHERE` na [Documentação Oficial do PostgreSQL](https://www.postgresql.org/docs/current/queries-where.html).

---

## 15. Comandos para modificar tabelas (`ALTER TABLE`)

### 15.1 Adicionar uma nova coluna

Para adicionar uma nova coluna à tabela:

```sql
ALTER TABLE clientes ADD COLUMN email VARCHAR(100);
```

### 15.2 Alterar o tipo de uma coluna existente

Para alterar o tipo de dado de uma coluna:

```sql
ALTER TABLE clientes ALTER COLUMN idade TYPE VARCHAR(3);
```

### 15.3 Renomear uma coluna

Para renomear uma coluna existente:

```sql
ALTER TABLE clientes RENAME COLUMN cidade TO endereco;
```

### 15.4 Excluir (dropar) uma coluna

Para remover uma coluna da tabela:

```sql
ALTER TABLE clientes DROP COLUMN email;
```

Veja mais sobre `ALTER TABLE` na [Documentação Oficial do PostgreSQL](https://www.postgresql.org/docs/current/sql-altertable.html).

---

## 16. Como excluir uma tabela (`DROP TABLE`)

Se você deseja excluir uma tabela inteira:

```sql
DROP TABLE pedidos;
```

Veja mais sobre o comando `DROP TABLE` na [Documentação Oficial do PostgreSQL](https://www.postgresql.org/docs/current/sql-droptable.html).

---

## 17. Listar todas as tabelas

Para listar todas as tabelas de um banco de dados, use o comando:

```sql
\dt
```

Consulte mais detalhes sobre este comando na [Documentação do psql](https://www.postgresql.org/docs/current/app-psql.html#APP-PSQL-META-COMMANDS).

---

## 18. Exibir o esquema de uma tabela (describe)

Para descrever o esquema de uma tabela:

```sql
\d nome_da_tabela
```

Veja mais sobre este comando na [Documentação do psql](https://www.postgresql.org/docs/current/app-psql.html).

---

## 19. Fazer backup com `pg_dump`

Agora que você já inseriu dados no banco, pode fazer o backup utilizando `pg_dump`.

```bash
pg_dump -U meu_usuario -h localhost -d meu_banco -F c -f meu_banco_backup.dump
```

Veja mais detalhes sobre o `pg_dump` na [Documentação Oficial do PostgreSQL - pg_dump](https://www.postgresql.org/docs/current/app-pgdump.html).

---

## 20. Restaurar um backup com `pg_restore`

Para restaurar um banco de dados a partir de um arquivo dump:

```bash
pg_restore -U meu_usuario -h localhost -d meu_banco_restaurado -1 meu_banco_backup.dump
```

Veja mais sobre `pg_restore` na [Documentação Oficial do PostgreSQL - pg_restore](https://www.postgresql.org/docs/current/app-pgrestore.html).

---

## 21. Executar comandos SQL a partir de um arquivo

### 21.1 Importar um arquivo SQL de fora do `psql`
### Ele vai rodar o script sql e trazer o output
### Importante rodar esse comando na pasta onde eu estou ou colocar o caminho completo.


```bash
psql -U meu_usuario -h localhost -d meu_banco -f script.sql
```

### Com o caminho do arquivo sql a ser rodado

```bash
psql -U ricardo -h localhost -d library -f ./data_engineering/clients.sql 
```

### 21.2 Importar um arquivo SQL estando dentro do `psql`
### Ele vai rodar o comando sql e trazer o output igual acima, mas dentro do sql

```sql
\i caminho/para/o/arquivo/script.sql
```

Veja mais sobre execução de scripts SQL no [psql](https://www.postgresql.org/docs/current/app-psql.html#APP-PSQL-META-COMMANDS).



Aqui está a conclusão revisada com **exemplos tanto de SQL direto quanto de uso de ORM** em **JavaScript (Node.js)** e **Python**, para que você veja as duas abordagens: uma com controle completo através de SQL manual, e outra usando abstração com ORMs.

---

## Conclusão para PostgreSQL (`psql`)

Neste tutorial, exploramos como usar **PostgreSQL** diretamente através do terminal com o **`psql`**, permitindo que você escreva e execute consultas SQL diretamente. No entanto, em **aplicações reais**, muitas vezes a interação com o banco de dados é feita através de **drivers nativos** para linguagens de programação, como JavaScript e Python. Além disso, muitos desenvolvedores optam por usar **ORMs (Object-Relational Mapping)**, que abstraem o SQL e facilitam a manipulação dos dados como objetos.

Aqui, vamos mostrar ambas as abordagens: como usar **SQL direto** e como usar **ORMs** em **JavaScript** (com Sequelize) e **Python** (com SQLAlchemy).

---

### Exemplo em JavaScript (Node.js)

#### A) Usando SQL Direto com `pg`

No **Node.js**, você pode utilizar o **pg**, que é o driver nativo do PostgreSQL, para executar consultas SQL diretamente.

##### Instalar o `pg`:

```bash
npm install pg
```

##### Exemplo de código em JavaScript com SQL direto:

```javascript
const { Client } = require('pg');

// Conectar ao PostgreSQL
const client = new Client({
  user: 'meu_usuario',
  host: 'localhost',
  database: 'meu_banco',
  password: 'minha_senha',
  port: 5432,
});

async function run() {
  try {
    // Conectar ao banco de dados
    await client.connect();

    // Criar tabela diretamente com SQL
    await client.query(`
      CREATE TABLE IF NOT EXISTS clientes (
        id SERIAL PRIMARY KEY,
        nome VARCHAR(100),
        idade INT,
        cidade VARCHAR(50)
      );
    `);

    // Inserir dados diretamente com SQL
    const insertQuery = 'INSERT INTO clientes (nome, idade, cidade) VALUES ($1, $2, $3) RETURNING *';
    const insertValues = ['João', 30, 'São Paulo'];
    const resInsert = await client.query(insertQuery, insertValues);
    console.log('Cliente inserido:', resInsert.rows[0]);

    // Selecionar dados diretamente com SQL
    const selectQuery = 'SELECT * FROM clientes WHERE nome = $1';
    const resSelect = await client.query(selectQuery, ['João']);
    console.log('Clientes encontrados:', resSelect.rows);

  } catch (err) {
    console.error('Erro ao executar consultas:', err.stack);
  } finally {
    // Fechar a conexão
    await client.end();
  }
}

run();
```

### B) Usando ORM com Sequelize

**Sequelize** é um ORM popular no **Node.js** para interagir com bancos de dados como o PostgreSQL. Ele facilita o mapeamento de tabelas em classes e abstrai o SQL.

##### Instalar Sequelize:

```bash
npm install sequelize pg pg-hstore
```

##### Exemplo de código em JavaScript com Sequelize (ORM):

```javascript
const { Sequelize, DataTypes } = require('sequelize');

// Configurar a conexão com PostgreSQL
const sequelize = new Sequelize('meu_banco', 'meu_usuario', 'minha_senha', {
  host: 'localhost',
  dialect: 'postgres',
});

// Definir o modelo Cliente
const Cliente = sequelize.define('Cliente', {
  nome: {
    type: DataTypes.STRING,
    allowNull: false,
  },
  idade: {
    type: DataTypes.INTEGER,
    allowNull: false,
  },
  cidade: {
    type: DataTypes.STRING,
    allowNull: false,
  },
});

async function run() {
  try {
    // Sincronizar o modelo com o banco de dados (criar tabela)
    await sequelize.sync({ force: true });

    // Inserir um cliente usando Sequelize
    const joao = await Cliente.create({ nome: 'João', idade: 30, cidade: 'São Paulo' });
    console.log('Cliente inserido:', joao.toJSON());

    // Consultar clientes com Sequelize
    const clientes = await Cliente.findAll();
    console.log('Clientes encontrados:', clientes.map(cliente => cliente.toJSON()));

  } catch (err) {
    console.error('Erro:', err);
  } finally {
    // Fechar a conexão
    await sequelize.close();
  }
}

run();
```

---

### Exemplo em Python

#### A) Usando SQL Direto com `psycopg2`

No **Python**, você pode usar o driver **psycopg2** para executar consultas SQL diretamente no PostgreSQL.

##### Instalar o `psycopg2`:

```bash
pip install psycopg2
```

##### Exemplo de código em Python com SQL direto:

```python
import psycopg2

# Conectar ao banco de dados PostgreSQL
conn = psycopg2.connect(
    dbname="meu_banco",
    user="meu_usuario",
    password="minha_senha",
    host="localhost",
    port="5432"
)

# Criar um cursor para executar comandos SQL
cur = conn.cursor()

try:
    # Criar tabela com SQL
    cur.execute('''
        CREATE TABLE IF NOT EXISTS clientes (
            id SERIAL PRIMARY KEY,
            nome VARCHAR(100),
            idade INT,
            cidade VARCHAR(50)
        );
    ''')
    conn.commit()

    # Inserir um cliente usando SQL
    insert_query = 'INSERT INTO clientes (nome, idade, cidade) VALUES (%s, %s, %s) RETURNING *'
    cur.execute(insert_query, ('João', 30, 'São Paulo'))
    conn.commit()
    inserted_cliente = cur.fetchone()
    print('Cliente inserido:', inserted_cliente)

    # Consultar clientes usando SQL
    select_query = 'SELECT * FROM clientes WHERE nome = %s'
    cur.execute(select_query, ('João',))
    clientes = cur.fetchall()
    print('Clientes encontrados:', clientes)

except Exception as e:
    print(f"Erro ao executar SQL: {e}")
    conn.rollback()

finally:
    cur.close()
    conn.close()
```

---

### B) Usando ORM com SQLAlchemy

**SQLAlchemy** é um ORM popular para **Python**. Ele mapeia classes para tabelas e permite que você manipule dados como objetos Python.

##### Instalar SQLAlchemy:

```bash
pip install sqlalchemy psycopg2
```

##### Exemplo de código em Python com SQLAlchemy (ORM):

```python

# Configurar a conexão com PostgreSQL
engine = create_engine('postgresql://meu_usuario:minha_senha@localhost/meu_banco')
Base = declarative_base()

# Definir o modelo Cliente
class Cliente(Base):
    __tablename__ = 'clientes'
    id = Column(Integer, primary_key=True)
    nome = Column(String, nullable=False)
    idade = Column(Integer, nullable=False)
    cidade = Column(String, nullable=False)

# Criar uma sessão
Session = sessionmaker(bind=engine)
session = Session()

def run():
    # Criar a tabela no banco de dados
    Base.metadata.create_all(engine)

    # Inserir um cliente usando SQLAlchemy
    joao = Cliente(nome='João', idade=30, cidade='São Paulo')
    session.add(joao)
    session.commit()

    # Consultar clientes usando SQLAlchemy
    clientes = session.query(Cliente).all()
    for cliente in clientes:
        print(f'Cliente: {cliente.nome}, Idade: {cliente.idade}, Cidade: {cliente.cidade}')

    # Fechar a sessão
    session.close()

run()
```

---

### Comparação e Conclusão Geral

Tanto no **Node.js** quanto no **Python**, você pode usar **SQL direto** ou **ORMs** para interagir com o PostgreSQL.

- **SQL Direto**: Você tem controle total sobre as consultas e pode escrever comandos SQL manualmente, o que pode ser útil para otimização e controle fino.
- **ORM (Object-Relational Mapping)**: Abstrai o SQL e permite que você manipule dados como objetos da linguagem, simplificando o desenvolvimento e a manutenção do código, especialmente para operações comuns de CRUD (Create, Read, Update, Delete).

#### Escolha da abordagem:
- Se você precisa de **controle granular** e está lidando com consultas SQL complexas ou otimização de desempenho, usar **SQL direto** pode ser mais adequado.
- Se você quer **produtividade** e preferir trabalhar com objetos em vez de SQL explícito, especialmente para projetos com muitos modelos e relacionamentos, o uso de um **ORM** como **Sequelize** (para JavaScript) ou **SQLAlchemy** (para Python) pode ser a melhor escolha.

Ambas as abordagens são amplamente utilizadas no desenvolvimento de aplicações modernas, e entender as duas é fundamental para aproveitar o melhor de cada uma.
