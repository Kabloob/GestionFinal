
    CREATE TRIGGER trg_categoria_producto_delete
    ON categoria_producto
    AFTER DELETE
    AS
    BEGIN
        DECLARE @UsuarioActual NVARCHAR(255) = SYSTEM_USER
        INSERT INTO Auditoria (NombreTabla, UsuarioActual, Accion)
        SELECT 'categoria_producto', @UsuarioActual, 'DELETE' FROM deleted
    END
    