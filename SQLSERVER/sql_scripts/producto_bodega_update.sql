
    CREATE TRIGGER trg_producto_bodega_update
    ON producto_bodega
    AFTER UPDATE
    AS
    BEGIN
        DECLARE @UsuarioActual NVARCHAR(255) = SYSTEM_USER
        INSERT INTO Auditoria (NombreTabla, UsuarioActual, Accion)
        SELECT 'producto_bodega', @UsuarioActual, 'UPDATE' FROM inserted
    END
    