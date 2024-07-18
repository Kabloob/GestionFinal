
    CREATE TRIGGER trg_producto_bodega_delete
    ON producto_bodega
    AFTER DELETE
    AS
    BEGIN
        DECLARE @UsuarioActual NVARCHAR(255) = SYSTEM_USER
        INSERT INTO Auditoria (NombreTabla, UsuarioActual, Accion)
        SELECT 'producto_bodega', @UsuarioActual, 'DELETE' FROM deleted
    END
    