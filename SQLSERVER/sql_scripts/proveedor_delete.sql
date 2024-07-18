
    CREATE TRIGGER trg_proveedor_delete
    ON proveedor
    AFTER DELETE
    AS
    BEGIN
        DECLARE @UsuarioActual NVARCHAR(255) = SYSTEM_USER
        INSERT INTO Auditoria (NombreTabla, UsuarioActual, Accion)
        SELECT 'proveedor', @UsuarioActual, 'DELETE' FROM deleted
    END
    