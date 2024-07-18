
    CREATE TRIGGER trg_producto_bodega_insert
    ON producto_bodega
    AFTER INSERT
    AS
    BEGIN
        DECLARE @UsuarioActual NVARCHAR(255) = SYSTEM_USER
        INSERT INTO Auditoria (NombreTabla, UsuarioActual, Accion)
        SELECT 'producto_bodega', @UsuarioActual, 'INSERT' FROM inserted
    END
    