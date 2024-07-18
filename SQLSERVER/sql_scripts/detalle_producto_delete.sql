
    CREATE TRIGGER trg_detalle_producto_delete
    ON detalle_producto
    AFTER DELETE
    AS
    BEGIN
        DECLARE @UsuarioActual NVARCHAR(255) = SYSTEM_USER
        INSERT INTO Auditoria (NombreTabla, UsuarioActual, Accion)
        SELECT 'detalle_producto', @UsuarioActual, 'DELETE' FROM deleted
    END
    