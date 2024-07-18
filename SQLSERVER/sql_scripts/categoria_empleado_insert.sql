
    CREATE TRIGGER trg_categoria_empleado_insert
    ON categoria_empleado
    AFTER INSERT
    AS
    BEGIN
        DECLARE @UsuarioActual NVARCHAR(255) = SYSTEM_USER
        INSERT INTO Auditoria (NombreTabla, UsuarioActual, Accion)
        SELECT 'categoria_empleado', @UsuarioActual, 'INSERT' FROM inserted
    END
    