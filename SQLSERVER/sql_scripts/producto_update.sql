
    CREATE TRIGGER trg_producto_update
    ON producto
    AFTER UPDATE
    AS
    BEGIN
        DECLARE @UsuarioActual NVARCHAR(255) = SYSTEM_USER
        INSERT INTO Auditoria (NombreTabla, UsuarioActual, Accion)
        SELECT 'producto', @UsuarioActual, 'UPDATE' FROM inserted
    END
    