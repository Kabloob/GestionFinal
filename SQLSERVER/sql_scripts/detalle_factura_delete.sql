
    CREATE TRIGGER trg_detalle_factura_delete
    ON detalle_factura
    AFTER DELETE
    AS
    BEGIN
        DECLARE @UsuarioActual NVARCHAR(255) = SYSTEM_USER
        INSERT INTO Auditoria (NombreTabla, UsuarioActual, Accion)
        SELECT 'detalle_factura', @UsuarioActual, 'DELETE' FROM deleted
    END
    