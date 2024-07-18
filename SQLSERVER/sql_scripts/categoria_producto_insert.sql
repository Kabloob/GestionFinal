
    CREATE TRIGGER trg_categoria_producto_insert
    ON categoria_producto
    AFTER INSERT
    AS
    BEGIN
        DECLARE @UsuarioActual NVARCHAR(255) = SYSTEM_USER
        INSERT INTO Auditoria (NombreTabla, UsuarioActual, Accion)
        SELECT 'categoria_producto', @UsuarioActual, 'INSERT' FROM inserted
    END
    