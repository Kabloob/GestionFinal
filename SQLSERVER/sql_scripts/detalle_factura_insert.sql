
    CREATE TRIGGER trg_detalle_factura_insert
    ON detalle_factura
    AFTER INSERT
    AS
    BEGIN
        DECLARE @UsuarioActual NVARCHAR(255) = SYSTEM_USER
        INSERT INTO Auditoria (NombreTabla, UsuarioActual, Accion)
        SELECT 'detalle_factura', @UsuarioActual, 'INSERT' FROM inserted
    END
    