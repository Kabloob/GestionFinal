
    CREATE TRIGGER trg_carrito_compra_delete
    ON carrito_compra
    AFTER DELETE
    AS
    BEGIN
        DECLARE @UsuarioActual NVARCHAR(255) = SYSTEM_USER
        INSERT INTO Auditoria (NombreTabla, UsuarioActual, Accion)
        SELECT 'carrito_compra', @UsuarioActual, 'DELETE' FROM deleted
    END
    