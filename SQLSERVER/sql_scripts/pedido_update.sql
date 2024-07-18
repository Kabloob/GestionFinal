
    CREATE TRIGGER trg_pedido_update
    ON pedido
    AFTER UPDATE
    AS
    BEGIN
        DECLARE @UsuarioActual NVARCHAR(255) = SYSTEM_USER
        INSERT INTO Auditoria (NombreTabla, UsuarioActual, Accion)
        SELECT 'pedido', @UsuarioActual, 'UPDATE' FROM inserted
    END
    