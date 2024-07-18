
    CREATE TRIGGER trg_cliente_delete
    ON cliente
    AFTER DELETE
    AS
    BEGIN
        DECLARE @UsuarioActual NVARCHAR(255) = SYSTEM_USER
        INSERT INTO Auditoria (NombreTabla, UsuarioActual, Accion)
        SELECT 'cliente', @UsuarioActual, 'DELETE' FROM deleted
    END
    