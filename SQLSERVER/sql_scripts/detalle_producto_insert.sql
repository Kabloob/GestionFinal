
    CREATE TRIGGER trg_detalle_producto_insert
    ON detalle_producto
    AFTER INSERT
    AS
    BEGIN
        DECLARE @UsuarioActual NVARCHAR(255) = SYSTEM_USER
        INSERT INTO Auditoria (NombreTabla, UsuarioActual, Accion)
        SELECT 'detalle_producto', @UsuarioActual, 'INSERT' FROM inserted
    END
    