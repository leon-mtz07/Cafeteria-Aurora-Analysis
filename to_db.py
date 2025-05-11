import pandas as pd
from sqlalchemy import create_engine, text

engine = create_engine('mysql+pymysql://root:leon1824@localhost:3306/coffee_aurora')

productos = pd.read_csv('data/productos.csv')
productos.to_sql('productos', con=engine, if_exists='append', index=False)
print('Productos cargado correctamente')

inventario = pd.read_csv('data/inventario.csv')
inventario.to_sql('inventario', con=engine, if_exists='append', index=False)
print('Inventario cargado correctamente')

ventas = pd.read_csv('data/ventas.csv')
ventas.to_sql('ventas', con=engine, if_exists='append', index=False)
print('Ventas cargado correctamente')