
    CREATE TRIGGER trg_proveedor_update
    ON proveedor
    AFTER UPDATE
    AS
    BEGIN
        DECLARE @UsuarioActual NVARCHAR(255) = SYSTEM_USER
        INSERT INTO Auditoria (NombreTabla, UsuarioActual, Accion)
        SELECT 'proveedor', @UsuarioActual, 'UPDATE' FROM inserted
    END
    