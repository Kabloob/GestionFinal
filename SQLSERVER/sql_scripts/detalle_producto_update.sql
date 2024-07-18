
    CREATE TRIGGER trg_detalle_producto_update
    ON detalle_producto
    AFTER UPDATE
    AS
    BEGIN
        DECLARE @UsuarioActual NVARCHAR(255) = SYSTEM_USER
        INSERT INTO Auditoria (NombreTabla, UsuarioActual, Accion)
        SELECT 'detalle_producto', @UsuarioActual, 'UPDATE' FROM inserted
    END
    