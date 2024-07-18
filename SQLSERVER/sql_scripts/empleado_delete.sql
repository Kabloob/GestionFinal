
    CREATE TRIGGER trg_empleado_delete
    ON empleado
    AFTER DELETE
    AS
    BEGIN
        DECLARE @UsuarioActual NVARCHAR(255) = SYSTEM_USER
        INSERT INTO Auditoria (NombreTabla, UsuarioActual, Accion)
        SELECT 'empleado', @UsuarioActual, 'DELETE' FROM deleted
    END
    