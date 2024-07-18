
    CREATE TRIGGER trg_direccion_entrega_update
    ON direccion_entrega
    AFTER UPDATE
    AS
    BEGIN
        DECLARE @UsuarioActual NVARCHAR(255) = SYSTEM_USER
        INSERT INTO Auditoria (NombreTabla, UsuarioActual, Accion)
        SELECT 'direccion_entrega', @UsuarioActual, 'UPDATE' FROM inserted
    END
    