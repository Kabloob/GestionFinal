
    CREATE TRIGGER trg_pedido_insert
    ON pedido
    AFTER INSERT
    AS
    BEGIN
        DECLARE @UsuarioActual NVARCHAR(255) = SYSTEM_USER
        INSERT INTO Auditoria (NombreTabla, UsuarioActual, Accion)
        SELECT 'pedido', @UsuarioActual, 'INSERT' FROM inserted
    END
    