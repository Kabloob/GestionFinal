
    CREATE TRIGGER trg_categoria_empleado_delete
    ON categoria_empleado
    AFTER DELETE
    AS
    BEGIN
        DECLARE @UsuarioActual NVARCHAR(255) = SYSTEM_USER
        INSERT INTO Auditoria (NombreTabla, UsuarioActual, Accion)
        SELECT 'categoria_empleado', @UsuarioActual, 'DELETE' FROM deleted
    END
    