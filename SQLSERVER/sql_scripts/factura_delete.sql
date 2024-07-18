
    CREATE TRIGGER trg_factura_delete
    ON factura
    AFTER DELETE
    AS
    BEGIN
        DECLARE @UsuarioActual NVARCHAR(255) = SYSTEM_USER
        INSERT INTO Auditoria (NombreTabla, UsuarioActual, Accion)
        SELECT 'factura', @UsuarioActual, 'DELETE' FROM deleted
    END
    