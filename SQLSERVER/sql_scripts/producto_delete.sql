
    CREATE TRIGGER trg_producto_delete
    ON producto
    AFTER DELETE
    AS
    BEGIN
        DECLARE @UsuarioActual NVARCHAR(255) = SYSTEM_USER
        INSERT INTO Auditoria (NombreTabla, UsuarioActual, Accion)
        SELECT 'producto', @UsuarioActual, 'DELETE' FROM deleted
    END
    