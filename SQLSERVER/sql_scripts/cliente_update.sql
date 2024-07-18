
    CREATE TRIGGER trg_cliente_update
    ON cliente
    AFTER UPDATE
    AS
    BEGIN
        DECLARE @UsuarioActual NVARCHAR(255) = SYSTEM_USER
        INSERT INTO Auditoria (NombreTabla, UsuarioActual, Accion)
        SELECT 'cliente', @UsuarioActual, 'UPDATE' FROM inserted
    END
    