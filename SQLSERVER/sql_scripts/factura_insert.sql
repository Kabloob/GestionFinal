
    CREATE TRIGGER trg_factura_insert
    ON factura
    AFTER INSERT
    AS
    BEGIN
        DECLARE @UsuarioActual NVARCHAR(255) = SYSTEM_USER
        INSERT INTO Auditoria (NombreTabla, UsuarioActual, Accion)
        SELECT 'factura', @UsuarioActual, 'INSERT' FROM inserted
    END
    