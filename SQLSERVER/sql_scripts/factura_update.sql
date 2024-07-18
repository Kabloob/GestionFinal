
    CREATE TRIGGER trg_factura_update
    ON factura
    AFTER UPDATE
    AS
    BEGIN
        DECLARE @UsuarioActual NVARCHAR(255) = SYSTEM_USER
        INSERT INTO Auditoria (NombreTabla, UsuarioActual, Accion)
        SELECT 'factura', @UsuarioActual, 'UPDATE' FROM inserted
    END
    