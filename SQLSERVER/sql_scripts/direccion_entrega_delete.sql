
    CREATE TRIGGER trg_direccion_entrega_delete
    ON direccion_entrega
    AFTER DELETE
    AS
    BEGIN
        DECLARE @UsuarioActual NVARCHAR(255) = SYSTEM_USER
        INSERT INTO Auditoria (NombreTabla, UsuarioActual, Accion)
        SELECT 'direccion_entrega', @UsuarioActual, 'DELETE' FROM deleted
    END
    