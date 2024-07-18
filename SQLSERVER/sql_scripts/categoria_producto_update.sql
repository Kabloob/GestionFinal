
    CREATE TRIGGER trg_categoria_producto_update
    ON categoria_producto
    AFTER UPDATE
    AS
    BEGIN
        DECLARE @UsuarioActual NVARCHAR(255) = SYSTEM_USER
        INSERT INTO Auditoria (NombreTabla, UsuarioActual, Accion)
        SELECT 'categoria_producto', @UsuarioActual, 'UPDATE' FROM inserted
    END
    