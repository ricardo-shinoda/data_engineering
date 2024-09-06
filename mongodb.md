# Tutorial MongoDB

## 1. Instalar MongoDB

Abra o terminal e execute os seguintes comandos:

```bash
# Importar a chave GPG pública do MongoDB
wget -qO - https://www.mongodb.org/static/pgp/server-6.0.asc | sudo apt-key add -

# Criar o arquivo de lista do MongoDB
echo "deb [ arch=amd64,arm64 ] https://repo.mongodb.org/apt/ubuntu focal/mongodb-org/6.0 multiverse" | sudo tee /etc/apt/sources.list.d/mongodb-org-6.0.list

# Atualizar os pacotes
sudo apt update

# Instalar MongoDB
sudo apt install -y mongodb-org
```

Para mais detalhes sobre a instalação, consulte a [Documentação Oficial do MongoDB - Instalação no Linux](https://www.mongodb.com/docs/manual/installation/).

---

## 2. Iniciar e parar o MongoDB

Após a instalação, você pode iniciar ou parar o serviço MongoDB usando o `systemctl`:

```bash
# Iniciar o MongoDB
sudo systemctl start mongod

# Verificar se o MongoDB está rodando
sudo systemctl status mongod

# Parar o MongoDB
sudo systemctl stop mongod
```

Para mais detalhes sobre o gerenciamento do MongoDB, veja a [Documentação do MongoDB - Iniciar o MongoDB](https://www.mongodb.com/docs/manual/tutorial/manage-mongodb-processes/).

---

## 3. Acessar o MongoDB Shell (`mongosh`)

Após iniciar o MongoDB, você pode acessar o MongoDB Shell via `mongosh`, o shell interativo do MongoDB, com o seguinte comando:

```bash
mongosh
```

Isso conectará você ao MongoDB localmente. No MongoDB Shell, você interage diretamente com o banco de dados usando **JavaScript**.

> **Nota Importante:**
> Embora o MongoDB Shell use JavaScript para suas operações, **a maioria das interações com MongoDB em aplicações reais é feita usando drivers específicos da linguagem de programação**. Estes drivers traduzem operações para o MongoDB e lidam com a comunicação com o banco de dados. Exemplos incluem o **Mongoose** em **Node.js**, **PyMongo** em **Python**, entre outros. Esses drivers abstraem a interação direta com o MongoDB.

Para mais informações sobre o MongoDB Shell, veja a [Documentação do MongoDB - MongoDB Shell](https://www.mongodb.com/docs/mongodb-shell/).

---

## 4. Criar um banco de dados

Para criar ou selecionar um banco de dados no MongoDB, basta usar o comando `use`. O banco de dados será criado automaticamente quando você inserir dados nele:

```javascript
use meu_banco
```

Para mais informações, veja a [Documentação do MongoDB](https://www.mongodb.com/docs/manual/reference/method/db.createCollection/).

---

## 5. Criar uma coleção e inserir documentos

No MongoDB, tabelas são chamadas de "coleções". Para criar uma coleção chamada `clientes` e inserir documentos, use os seguintes comandos:

```javascript
db.createCollection("clientes")
db.clientes.insertOne({ nome: "João", idade: 30, cidade: "São Paulo" })
db.clientes.insertMany([
  { nome: "Maria", idade: 25, cidade: "Rio de Janeiro" },
  { nome: "Pedro", idade: 40, cidade: "Belo Horizonte" },
  { nome: "Ana", idade: 28, cidade: "Curitiba" },
  { nome: "Carlos", idade: 35, cidade: "Porto Alegre" }
])
```

Para mais detalhes sobre inserção de documentos, consulte a [Documentação do MongoDB - Insert](https://www.mongodb.com/docs/manual/crud/#insert-documents).

---

## 6. Listar todas as coleções

Para listar todas as coleções de um banco de dados, use o seguinte comando no `mongosh`:

```javascript
show collections
```

Isso exibirá todas as coleções criadas no banco de dados atual. Para mais detalhes, veja a [Documentação do MongoDB - List Collections](https://www.mongodb.com/docs/manual/reference/method/db.getCollectionNames/).

---

## 7. Consultar documentos

No MongoDB, o equivalente a um `SELECT` no SQL é o comando `find`. Para consultar todos os documentos da coleção `clientes`, use:

```shell
db.clientes.find().pretty()
```

Para fazer uma consulta com filtro, por exemplo, todos os clientes de São Paulo:

```javascript
db.clientes.find({ cidade: "São Paulo" }).pretty()
```

Para mais detalhes sobre consultas, veja a [Documentação do MongoDB - Query](https://www.mongodb.com/docs/manual/tutorial/query-documents/).

---

## 8. Atualizar documentos

Para atualizar um documento específico, use o `updateOne` ou `updateMany`. Por exemplo, para atualizar a cidade de Maria:

```javascript
db.clientes.updateOne({ nome: "Maria" }, { $set: { cidade: "Salvador" } })
```

Se precisar atualizar todos os documentos que atendem a um critério:

```javascript
db.clientes.updateMany({ cidade: "São Paulo" }, { $set: { cidade: "Campinas" } })
```

Para mais detalhes sobre como atualizar documentos, consulte a [Documentação do MongoDB - Update](https://www.mongodb.com/docs/manual/reference/method/db.collection.updateOne/).

---

## 9. Remover documentos

Para excluir um documento específico, use o comando `deleteOne`:

```javascript
db.clientes.deleteOne({ nome: "Pedro" })
```

Se quiser excluir vários documentos que atendem a um critério:

```javascript
db.clientes.deleteMany({ cidade: "Curitiba" })
```

Para mais detalhes, veja a [Documentação do MongoDB - Delete](https://www.mongodb.com/docs/manual/reference/method/db.collection.deleteOne/).

---

## 10. Relacionamento entre coleções com referência (`reference`)

No MongoDB, relacionamentos podem ser criados usando referências. Para criar um relacionamento entre as coleções `clientes` e `pedidos`, adicione um campo `cliente_id` aos pedidos que referencia o `_id` do cliente:

```javascript
// Inserir um pedido referenciando o cliente
const cliente = db.clientes.findOne({ nome: "João" })
db.pedidos.insertOne({ cliente_id: cliente._id, valor: 150.00, data_pedido: new Date("2024-09-01") })
```

Para mais detalhes, veja a [Documentação do MongoDB - Relacionamentos com Referências](https://www.mongodb.com/docs/manual/tutorial/model-referenced-one-to-many-relationships-between-documents/).

---

## 11. Consultar com `$lookup` (equivalente ao JOIN)

No MongoDB, você pode combinar dados de diferentes coleções usando o operador `$lookup`. Por exemplo, para buscar dados da coleção `pedidos` e trazer informações da coleção `clientes`:

```javascript
db.pedidos.aggregate([
  {
    $lookup: {
      from: "clientes",
      localField: "cliente_id",
      foreignField: "_id",
      as: "cliente_info"
    }
  }
]).pretty()
```

Para mais detalhes sobre o operador `$lookup`, veja a [Documentação do MongoDB - Lookup](https://www.mongodb.com/docs/manual/reference/operator/aggregation/lookup/).

---

## 12. Fazer backup com `mongodump` e restaurar com `mongorestore`

### 12.1 Fazer backup com `mongodump`

O MongoDB oferece a ferramenta `mongodump` para realizar backups do banco de dados. Para fazer o backup de um banco de dados, use:

```bash
mongodump --db meu_banco --out /caminho/para/backup/
```

Esse comando cria um diretório com o nome do banco e armazena o backup.

### 12.2 Restaurar um backup com `mongorestore`

Para restaurar um backup, use a ferramenta `mongorestore`. Execute o seguinte comando:

```bash
mongorestore --db meu_banco_restaurado /caminho/para/backup/meu_banco/
```

Esse comando restaura o banco de dados a partir do backup especificado.

Para mais informações sobre backup e restauração, veja a [Documentação do MongoDB - mongodump](https://www.mongodb.com/docs/database-tools/mongodump/) e [mongorestore](https://www.mongodb.com/docs/database-tools/mongorestore/).

---

Aqui está a conclusão para **MongoDB**, com exemplos de consultas usando **MongoDB diretamente** (com **JavaScript** e **Python**) e também com **ORMs**, como **Mongoose** para **JavaScript (Node.js)** e **Motor** para **Python**. Assim, você poderá comparar as abordagens e ver como realizar operações no MongoDB de maneira direta e também utilizando uma camada de abstração com ORMs.

---

## Conclusão para MongoDB

No MongoDB, você pode interagir diretamente com os dados usando **JavaScript** no MongoDB Shell (`mongosh`) ou através de **drivers nativos** em **JavaScript** e **Python**. Além disso, em aplicações modernas, muitos desenvolvedores usam **ORMs** que abstraem a interação direta com o banco de dados, permitindo trabalhar com documentos MongoDB como objetos na linguagem de programação.

Aqui, vamos mostrar ambas as abordagens: consultas **diretas** em **JavaScript** e **Python**, e também com **ORMs** como **Mongoose** (para JavaScript) e **Motor** (para Python).

---

### Exemplo em JavaScript (Node.js)

#### A) Usando MongoDB Diretamente com o Driver Nativo

O driver oficial de **MongoDB** para **Node.js** permite realizar operações diretamente no banco, sem a necessidade de um ORM.

##### Instalar o driver oficial do MongoDB:

```bash
npm install mongodb
```

##### Exemplo de código em JavaScript com MongoDB direto:

```javascript
const { MongoClient } = require('mongodb');

// URL de conexão
const url = 'mongodb://localhost:27017';
const client = new MongoClient(url);

async function run() {
  try {
    // Conectar ao banco de dados MongoDB
    await client.connect();
    const database = client.db('meu_banco');
    const collection = database.collection('clientes');

    // Inserir um documento
    const insertResult = await collection.insertOne({ nome: 'João', idade: 30, cidade: 'São Paulo' });
    console.log('Documento inserido:', insertResult.insertedId);

    // Consultar documentos
    const clientes = await collection.find({ nome: 'João' }).toArray();
    console.log('Clientes encontrados:', clientes);

  } finally {
    // Fechar a conexão
    await client.close();
  }
}

run().catch(console.error);
```

### B) Usando ORM com Mongoose

**Mongoose** é um popular ORM para MongoDB em **Node.js**, que abstrai a interação com o banco de dados, permitindo que você trabalhe com modelos de dados de forma semelhante a objetos.

##### Instalar o Mongoose:

```bash
npm install mongoose
```

##### Exemplo de código em JavaScript com Mongoose (ORM):

```javascript
const mongoose = require('mongoose');

// Conectar ao MongoDB
mongoose.connect('mongodb://localhost:27017/meu_banco', { useNewUrlParser: true, useUnifiedTopology: true });

// Definir o modelo Cliente
const Cliente = mongoose.model('Cliente', new mongoose.Schema({
  nome: String,
  idade: Number,
  cidade: String,
}));

async function run() {
  try {
    // Inserir um cliente usando Mongoose
    const joao = await Cliente.create({ nome: 'João', idade: 30, cidade: 'São Paulo' });
    console.log('Cliente inserido:', joao);

    // Consultar clientes com Mongoose
    const clientes = await Cliente.find({ nome: 'João' });
    console.log('Clientes encontrados:', clientes);

  } finally {
    // Fechar a conexão
    mongoose.connection.close();
  }
}

run().catch(console.error);
```

---

### Exemplo em Python

#### A) Usando MongoDB Diretamente com o Driver PyMongo

O **PyMongo** é o driver oficial de MongoDB para **Python** e permite realizar operações diretamente no banco de dados.

##### Instalar o PyMongo:

```bash
pip install pymongo
```

##### Exemplo de código em Python com PyMongo (MongoDB direto):

```python
from pymongo import MongoClient

# Conectar ao MongoDB
client = MongoClient('mongodb://localhost:27017/')
db = client['meu_banco']
collection = db['clientes']

# Inserir um cliente
insert_result = collection.insert_one({'nome': 'João', 'idade': 30, 'cidade': 'São Paulo'})
print(f'Documento inserido com ID: {insert_result.inserted_id}')

# Consultar clientes
clientes = collection.find({'nome': 'João'})
for cliente in clientes:
    print(cliente)

# Fechar a conexão
client.close()
```

---

### B) Usando ORM com Motor (Assíncrono)

**Motor** é um ORM assíncrono para **MongoDB** em **Python** que facilita a integração com aplicações assíncronas, como aquelas construídas com **FastAPI** ou **Tornado**.

##### Instalar o Motor:

```bash
pip install motor
```

##### Exemplo de código em Python com Motor (ORM):

```python
import motor.motor_asyncio
import asyncio

# Conectar ao MongoDB com Motor (assíncrono)
client = motor.motor_asyncio.AsyncIOMotorClient('mongodb://localhost:27017/')
db = client['meu_banco']
collection = db['clientes']

async def run():
    # Inserir um cliente usando Motor
    insert_result = await collection.insert_one({'nome': 'João', 'idade': 30, 'cidade': 'São Paulo'})
    print(f'Documento inserido com ID: {insert_result.inserted_id}')

    # Consultar clientes usando Motor
    async for cliente in collection.find({'nome': 'João'}):
        print(cliente)

# Executar a função assíncrona
asyncio.run(run())

# Fechar a conexão (feita automaticamente ao encerrar o programa)
```

---

### Comparação e Conclusão Geral

Tanto em **JavaScript** quanto em **Python**, você pode usar **MongoDB diretamente** ou adotar um **ORM** para facilitar a interação com o banco de dados:

- **MongoDB Direto**: Usando drivers nativos como **mongodb** em Node.js e **PyMongo** em Python, você tem controle total sobre as operações no banco de dados, realizando consultas, inserções e atualizações diretamente no MongoDB.
  
- **ORMs (Mongoose e Motor)**: Essas ferramentas abstraem a complexidade das operações no banco de dados, permitindo que você trabalhe com os dados como se fossem objetos da linguagem. Isso torna o desenvolvimento mais simples, especialmente em projetos com muitas operações de CRUD.

#### Quando usar SQL direto ou ORMs:
- **MongoDB direto (Drivers Nativos)**: É a melhor opção quando você precisa de **flexibilidade** e **controle total** sobre as consultas, ou quando está lidando com operações de banco de dados mais complexas.
  
- **ORMs**: Facilitam a vida do desenvolvedor ao fornecer uma camada de abstração, especialmente útil para operações mais simples e repetitivas, como inserir, consultar e atualizar documentos.
