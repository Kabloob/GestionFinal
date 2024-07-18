
    CREATE TRIGGER trg_detalle_factura_update
    ON detalle_factura
    AFTER UPDATE
    AS
    BEGIN
        DECLARE @UsuarioActual NVARCHAR(255) = SYSTEM_USER
        INSERT INTO Auditoria (NombreTabla, UsuarioActual, Accion)
        SELECT 'detalle_factura', @UsuarioActual, 'UPDATE' FROM inserted
    END
    