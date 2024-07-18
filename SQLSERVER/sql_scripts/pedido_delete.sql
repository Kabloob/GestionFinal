
    CREATE TRIGGER trg_pedido_delete
    ON pedido
    AFTER DELETE
    AS
    BEGIN
        DECLARE @UsuarioActual NVARCHAR(255) = SYSTEM_USER
        INSERT INTO Auditoria (NombreTabla, UsuarioActual, Accion)
        SELECT 'pedido', @UsuarioActual, 'DELETE' FROM deleted
    END
    