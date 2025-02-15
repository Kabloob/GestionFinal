from flask import Flask, render_template, request, send_file, jsonify
import pyodbc
from reportlab.lib.pagesizes import letter
from reportlab.pdfgen import canvas
import os
import threading
import time

app = Flask(__name__)

# Función para conectar a la base de datos SQL Server
def connect_to_database():
    server = 'CHICHO'
    database = 'IVECO'
    username = 'sa'
    password = '1234'
    conn = pyodbc.connect('DRIVER={SQL Server};SERVER='+server+';DATABASE='+database+';UID='+username+';PWD='+password)
    return conn

@app.route('/')
def index():
    return render_template('index.html')

@app.route('/crear_usuario', methods=['GET', 'POST'])
def crear_usuario():
    if request.method == 'POST':
        new_username = request.form['username']
        new_password = request.form['password']

        try:
            with connect_to_database() as conn:
                with conn.cursor() as cursor:
                    sql_create_user = f"CREATE LOGIN {new_username} WITH PASSWORD = '{new_password}'"
                    cursor.execute(sql_create_user)
                    conn.commit()
            message = {"Crear Usuario": "Nuevo usuario creado con éxito."}
        except Exception as e:
            message = {"Error al crear el usuario": str(e)}
            
        return render_template('result.html', messages=message)
    else:
        return render_template('crear_usuario.html')

@app.route('/modificar_usuario', methods=['GET', 'POST'])
def modificar_usuario():
    if request.method == 'POST':
        current_username = request.form['username']
        new_username = request.form['new_username']
        new_password = request.form['new_password']

        try:
            with connect_to_database() as conn:
                with conn.cursor() as cursor:
                    if new_username:
                        sql_rename_login = f"ALTER LOGIN {current_username} WITH NAME = {new_username}"
                        cursor.execute(sql_rename_login)
                    
                    if new_password:
                        sql_change_password = f"ALTER LOGIN {new_username or current_username} WITH PASSWORD = '{new_password}'"
                        cursor.execute(sql_change_password)
                    
                    conn.commit()
            message = {"Modificar Usuario": "Usuario modificado correctamente."}
        except Exception as e:
            message = {"Error al modificar el usuario": str(e)}

        return render_template('result.html', messages=message)
    else:
        return render_template('modificar_usuario.html')

@app.route('/eliminar_usuario', methods=['GET', 'POST'])
def eliminar_usuario():
    if request.method == 'POST':
        username = request.form['username']

        try:
            with connect_to_database() as conn:
                with conn.cursor() as cursor:
                    sql_delete_user = f"DROP LOGIN {username}"
                    cursor.execute(sql_delete_user)
                    conn.commit()
            message = {"Eliminar Usuario": "Usuario eliminado correctamente"}
        except Exception as e:
            message = {"Error al eliminar el usuario": str(e)}

        return render_template('result.html', messages=message)
    else:
        return render_template('eliminar_usuario.html')

@app.route('/crear_rol', methods=['GET', 'POST'])
def crear_rol():
    if request.method == 'POST':
        new_role_name = request.form['rolename']

        try:
            with connect_to_database() as conn:
                with conn.cursor() as cursor:
                    sql_create_role = f"CREATE SERVER ROLE {new_role_name}"
                    cursor.execute(sql_create_role)
                    conn.commit()
            message = {"Crear Rol": "Rol creado correctamente"}
        except Exception as e:
            message = {"Error al crear el rol": str(e)}

        return render_template('result.html', messages=message)
    else:
        return render_template('crear_rol.html')

@app.route('/consultar_usuarios')
def consultar_usuarios():
    try:
        with connect_to_database() as conn:
            with conn.cursor() as cursor:
                sql_query = "SELECT name FROM sys.server_principals WHERE type IN ('S', 'U', 'G')"
                cursor.execute(sql_query)
                users = [row[0] for row in cursor.fetchall()]
    except Exception as e:
        message = "Error al consultar usuarios: " + str(e)
        users = None

    return render_template('consultar_usuarios.html', users=users)

@app.route('/consultar_roles')
def consultar_roles():
    try:
        with connect_to_database() as conn:
            with conn.cursor() as cursor:
                sql_query = "SELECT name FROM sys.server_principals WHERE type = 'R'"
                cursor.execute(sql_query)
                roles = [row[0] for row in cursor.fetchall()]
    except Exception as e:
        message = "Error al consultar roles: " + str(e)
        roles = None

    return render_template('consultar_roles.html', roles=roles)

@app.route('/asignar_rol', methods=['GET', 'POST'])
def asignar_rol():
    if request.method == 'POST':
        username = request.form['username']
        rol = request.form['rol']

        try:
            with connect_to_database() as conn:
                with conn.cursor() as cursor:
                    sql_asignar_rol = f"ALTER SERVER ROLE {rol} ADD MEMBER {username}"
                    cursor.execute(sql_asignar_rol)
                    conn.commit()
            message = {"Asignar Rol": "Rol asignado correctamente al usuario"}
        except Exception as e:
            message = {"Error": f"Error al asignar el rol: {str(e)}"}

        return render_template('result.html', messages=message)
    else:
        return render_template('asignar_rol.html')

@app.route('/agregar_entidad', methods=['GET', 'POST'])
def agregar_entidad():
    if request.method == 'POST':
        entity_name = request.form['entity_name']
        attributes = request.form['attributes']

        try:
            with connect_to_database() as conn:
                with conn.cursor() as cursor:
                    sql_create_table = f"CREATE TABLE {entity_name} ({attributes})"
                    cursor.execute(sql_create_table)
                    conn.commit()
            message = {"Agregar Entidad": f"Entidad '{entity_name}' creada con éxito."}
        except Exception as e:
            message = {"Error al agregar la entidad": str(e)}

        return render_template('result.html', messages=message)
    else:
        return render_template('agregar_entidad.html')

def listar_entidades():
    with connect_to_database() as conn:
        with conn.cursor() as cursor:
            cursor.execute("SELECT TABLE_NAME FROM INFORMATION_SCHEMA.TABLES WHERE TABLE_TYPE = 'BASE TABLE' AND TABLE_CATALOG = 'IVECO'")
            entidades = [row[0] for row in cursor.fetchall()]
    return entidades

def listar_atributos(entidad):
    with connect_to_database() as conn:
        with conn.cursor() as cursor:
            cursor.execute("SELECT COLUMN_NAME FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME = ?", (entidad,))
            atributos = [row[0] for row in cursor.fetchall()]
    return atributos

@app.route('/listar_entidades')
def listar_entidades_route():
    entidades = listar_entidades()
    return render_template('listar_entidades.html', entidades=entidades)

@app.route('/listar_atributos/<entidad>')
def listar_atributos_route(entidad):
    atributos = listar_atributos(entidad)
    return render_template('listar_atributos.html', entidad=entidad, atributos=atributos)

def generate_pdf(filename, title, data):
    c = canvas.Canvas(filename, pagesize=letter)
    c.setFont("Helvetica", 12)
    
    c.drawString(100, 750, title)
    c.setFont("Helvetica", 10)

    y = 700
    for item in data:
        c.drawString(100, y, item)
        y -= 20

    c.save()

@app.route('/generar_pdf', methods=['GET', 'POST'])
def generar_pdf():
    if request.method == 'POST':
        tabla = request.form['tabla']
        atributos = listar_atributos(tabla)
        filename = f"{tabla}_reporte.pdf"
        generate_pdf(filename, f"Reporte de la tabla {tabla}", atributos)
        return send_file(filename, as_attachment=True)

    else:
        tablas = listar_entidades()
        return render_template('generar_pdf.html', tablas=tablas)

# Función para generar el script SQL de un procedimiento almacenado INSERT compatible con SQL Server
def generate_insert_proc(table_name, columns, primary_key):
    column_list = ', '.join(columns)
    values_list = ', '.join(['@' + col for col in columns])
    sql = f"""
    CREATE PROCEDURE {table_name}_Insert
    (
        {', '.join([f'@{col} NVARCHAR(255)' for col in columns])}
    )
    AS
    BEGIN
        INSERT INTO {table_name} ({column_list}) VALUES ({values_list});
    END
    """
    return sql

# Función para generar el script SQL de un procedimiento almacenado UPDATE compatible con SQL Server
def generate_update_proc(table_name, columns, primary_key):
    set_clause = ', '.join([f'{col} = @{col}' for col in columns if col != primary_key])
    sql = f"""
    CREATE PROCEDURE {table_name}_Update
    (
        @{primary_key} INT,
        {', '.join([f'@{col} NVARCHAR(255)' for col in columns if col != primary_key])}
    )
    AS
    BEGIN
        UPDATE {table_name} SET {set_clause} WHERE {primary_key} = @{primary_key};
    END
    """
    return sql

# Función para generar el script SQL de un procedimiento almacenado DELETE compatible con SQL Server
def generate_delete_proc(table_name, primary_key):
    sql = f"""
    CREATE PROCEDURE {table_name}_Delete
    (
        @{primary_key} INT
    )
    AS
    BEGIN
        DELETE FROM {table_name} WHERE {primary_key} = @{primary_key};
    END
    """
    return sql


# Función para generar el script SQL de un procedimiento almacenado SELECT compatible con SQL Server
def generate_select_proc(table_name, columns):
    sql = f"""
    CREATE PROCEDURE {table_name}_Select
    AS
    BEGIN
        SELECT {', '.join(columns)} FROM {table_name};
    END
    """
    return sql


@app.route('/generar_procedimientos', methods=['POST'])
def generar_procedimientos():
    try:
        with connect_to_database() as conn:
            with conn.cursor() as cursor:
                # Lista de tablas y sus columnas
                tables = {
                    "direccion_entrega": ["calle", "ciudad", "estado", "codigo_postal"],
                    "pedido": ["fecha_pedido", "direccion_entrega_id"],
                    "cliente": ["nombre", "apellido", "email", "cedula", "telefono"],
                    "carrito_compra": ["cliente_id", "pedido_id", "fecha_creacion"],
                    "categoria_empleado": ["nombre", "descripcion"],
                    "empleado": ["nombre", "apellido", "cargo", "salario", "fecha_contrato", "categoria_id"],
                    "promociones": ["nombre", "descripcion", "fecha_inicio", "fecha_fin", "descuento"],
                    "factura": ["fecha_factura", "total", "cliente_id", "empleado_id", "promociones_id"],
                    "contrato": ["empleado_id", "tipo_contrato", "fecha_inicio", "fecha_fin", "salario"],
                    "metodo_pago": ["nombre", "descripcion"],
                    "categoria_producto": ["nombre", "descripcion"],
                    "proveedor": ["nombre", "contacto", "telefono", "email"],
                    "producto": ["proveedor_id", "nombre", "descripcion", "precio", "categoria_id"],
                    "detalle_factura": ["factura_id", "producto_id", "metodo_id", "cantidad", "precio_unitario"],
                    "pasillo": ["nombre"],
                    "detalle_producto": ["producto_id", "pasillo_id", "fecha_ingreso", "cantidad", "precio_compra"],
                    "bodega": ["nombre", "direccion", "ciudad", "estado", "codigo_postal"],
                    "producto_bodega": ["producto_id", "bodega_id", "cantidad"]
                }
                
                for table_name, columns in tables.items():
                    primary_key = "id_" + table_name  # Suponiendo que el nombre de la columna de la clave primaria sigue el formato id_[nombre_de_tabla]
                    insert_proc = generate_insert_proc(table_name, columns, primary_key)
                    update_proc = generate_update_proc(table_name, columns, primary_key)
                    delete_proc = generate_delete_proc(table_name, primary_key)
                    select_proc = generate_select_proc(table_name, columns)
    
    # Ejecutar los scripts SQL para crear los procedimientos almacenados
                    cursor.execute(insert_proc)
                    cursor.execute(update_proc)
                    cursor.execute(delete_proc)
                    cursor.execute(select_proc)

        message = {"Generar Procedimientos": "Procedimientos almacenados generados correctamente."}
    except Exception as e:
        message = {"Error al generar procedimientos": str(e)}
    
    return render_template('result.html', messages=message)



# Crear tabla de auditoría
@app.route('/crear_tabla_auditoria', methods=['GET', 'POST'])
def crear_tabla_auditoria():
    if request.method == 'POST':
        try:
            with connect_to_database() as conn:
                with conn.cursor() as cursor:
                    sql_create_audit_table = """
                    CREATE TABLE Auditoria (
                        ID INT IDENTITY(1,1) PRIMARY KEY,
                        NombreTabla NVARCHAR(255),
                        FechaHora DATETIME DEFAULT GETDATE(),
                        UsuarioActual NVARCHAR(255),
                        Accion NVARCHAR(MAX)
                    )
                    """
                    cursor.execute(sql_create_audit_table)
                    conn.commit()
            message = {"Crear Tabla Auditoría": "Tabla de auditoría creada con éxito."}
        except Exception as e:
            message = {"Error al crear la tabla de auditoría": str(e)}

        return render_template('result.html', messages=message)
    else:
        return render_template('crear_tabla_auditoria.html')

@app.route('/generar_disparadores', methods=['GET', 'POST'])
def generar_disparadores():
    if request.method == 'POST':
        try:
            with connect_to_database() as conn:
                with conn.cursor() as cursor:
                    tables = listar_entidades()
                    
                    for table_name in tables:
                        triggers = generate_triggers(table_name)
                        for trigger_name, trigger_sql in triggers.items():
                            cursor.execute(trigger_sql)
                            
                            # Generar archivo SQL
                            file_path = os.path.join("sql_scripts", f"{table_name}_{trigger_name}.sql")
                            with open(file_path, "w") as file:
                                file.write(trigger_sql)
                    
                    conn.commit()
            message = {"Generar Disparadores": "Disparadores generados con éxito."}
        except Exception as e:
            message = {"Error al generar disparadores": str(e)}

        return render_template('result.html', messages=message)
    else:
        tablas = listar_entidades()
        return render_template('generar_disparadores.html', tablas=tablas)

# Función para generar disparadores
def generate_triggers(table_name):
    triggers = {}

    triggers["insert"] = f"""
    CREATE TRIGGER trg_{table_name}_insert
    ON {table_name}
    AFTER INSERT
    AS
    BEGIN
        DECLARE @UsuarioActual NVARCHAR(255) = SYSTEM_USER
        INSERT INTO Auditoria (NombreTabla, UsuarioActual, Accion)
        SELECT '{table_name}', @UsuarioActual, 'INSERT' FROM inserted
    END
    """

    triggers["update"] = f"""
    CREATE TRIGGER trg_{table_name}_update
    ON {table_name}
    AFTER UPDATE
    AS
    BEGIN
        DECLARE @UsuarioActual NVARCHAR(255) = SYSTEM_USER
        INSERT INTO Auditoria (NombreTabla, UsuarioActual, Accion)
        SELECT '{table_name}', @UsuarioActual, 'UPDATE' FROM inserted
    END
    """

    triggers["delete"] = f"""
    CREATE TRIGGER trg_{table_name}_delete
    ON {table_name}
    AFTER DELETE
    AS
    BEGIN
        DECLARE @UsuarioActual NVARCHAR(255) = SYSTEM_USER
        INSERT INTO Auditoria (NombreTabla, UsuarioActual, Accion)
        SELECT '{table_name}', @UsuarioActual, 'DELETE' FROM deleted
    END
    """

    return triggers

# Función para ejecutar consultas y devolver resultados
def execute_query(query, params=None):
    conn = connect_to_database()
    cursor = conn.cursor()
    start_time = time.time()
    
    try:
        if params:
            cursor.execute(query, params)
        else:
            cursor.execute(query)
        
        columns = [column[0] for column in cursor.description]
        results = [dict(zip(columns, row)) for row in cursor.fetchall()]
        end_time = time.time()
        return results, end_time - start_time
    
    except Exception as e:
        print(f"Error executing query: {query}, Error: {str(e)}")
        return [], 0
    
    finally:
        conn.close()

@app.route('/ejecutar_consultas', methods=['GET'])
def ejecutar_consultas():
    queries = [
        {"query": "SELECT * FROM cliente WHERE id_cliente = ?", "params": (1,)},
        {"query": "SELECT * FROM bodega WHERE id_bodega = ?", "params": (1,)},
    ]

    threads = []
    results = []
    times = []

    def worker(query):
        result, exec_time = execute_query(query["query"], query.get("params"))
        results.extend(result)
        times.append(exec_time)

    for query in queries:
        thread = threading.Thread(target=worker, args=(query,))
        threads.append(thread)
        thread.start()

    for thread in threads:
        thread.join()

    # Convertir resultados a formato JSON serializable
    json_results = []
    for result in results:
        json_result = {key: str(value) for key, value in result.items()}
        json_results.append(json_result)

    return jsonify({
        "results": json_results,
        "times": times
    })

if __name__ == '__main__':
    if not os.path.exists("sql_scripts"):
        os.makedirs("sql_scripts")
    app.run(debug=True)