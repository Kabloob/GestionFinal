
    CREATE TRIGGER trg_proveedor_insert
    ON proveedor
    AFTER INSERT
    AS
    BEGIN
        DECLARE @UsuarioActual NVARCHAR(255) = SYSTEM_USER
        INSERT INTO Auditoria (NombreTabla, UsuarioActual, Accion)
        SELECT 'proveedor', @UsuarioActual, 'INSERT' FROM inserted
    END
    