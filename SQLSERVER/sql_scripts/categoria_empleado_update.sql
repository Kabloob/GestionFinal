
    CREATE TRIGGER trg_categoria_empleado_update
    ON categoria_empleado
    AFTER UPDATE
    AS
    BEGIN
        DECLARE @UsuarioActual NVARCHAR(255) = SYSTEM_USER
        INSERT INTO Auditoria (NombreTabla, UsuarioActual, Accion)
        SELECT 'categoria_empleado', @UsuarioActual, 'UPDATE' FROM inserted
    END
    