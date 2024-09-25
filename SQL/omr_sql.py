from sqlalchemy import create_engine, Column, Integer, String
from sqlalchemy.ext.declarative import declarative_base
from sqlalchemy.orm import sessionmaker


engine = create_engine('postgresql://ricardo:3136@localhost/library')
Base = declarative_base()

class Client(Base):
    __tablename__ = 'clients'
    id = Column(Integer, primary_key=True)
    name = Column(String, nullable=False)
    age = Column(Integer, nullable=False)
    city = Column(String, nullable=False)

Session = sessionmaker(bind=engine)
session = Session()

def run():
    Base.metadata.create_all(engine)

    luisa = Client(name='Luísa', age=14, city='Bauru')
    session.add(luisa)
    session.commit()

    clients = session.query(Client).all()
    for client in clients:
        print(f'Client: {client.name}, Age: {client.age}, City: {client.city}')

    session.close()

run()