
    CREATE TRIGGER trg_cliente_insert
    ON cliente
    AFTER INSERT
    AS
    BEGIN
        DECLARE @UsuarioActual NVARCHAR(255) = SYSTEM_USER
        INSERT INTO Auditoria (NombreTabla, UsuarioActual, Accion)
        SELECT 'cliente', @UsuarioActual, 'INSERT' FROM inserted
    END
    