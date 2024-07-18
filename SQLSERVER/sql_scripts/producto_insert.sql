
    CREATE TRIGGER trg_producto_insert
    ON producto
    AFTER INSERT
    AS
    BEGIN
        DECLARE @UsuarioActual NVARCHAR(255) = SYSTEM_USER
        INSERT INTO Auditoria (NombreTabla, UsuarioActual, Accion)
        SELECT 'producto', @UsuarioActual, 'INSERT' FROM inserted
    END
    