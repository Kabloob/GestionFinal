
    CREATE TRIGGER trg_direccion_entrega_insert
    ON direccion_entrega
    AFTER INSERT
    AS
    BEGIN
        DECLARE @UsuarioActual NVARCHAR(255) = SYSTEM_USER
        INSERT INTO Auditoria (NombreTabla, UsuarioActual, Accion)
        SELECT 'direccion_entrega', @UsuarioActual, 'INSERT' FROM inserted
    END
    