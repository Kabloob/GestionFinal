
    CREATE TRIGGER trg_bodega_delete
    ON bodega
    AFTER DELETE
    AS
    BEGIN
        DECLARE @UsuarioActual NVARCHAR(255) = SYSTEM_USER
        INSERT INTO Auditoria (NombreTabla, UsuarioActual, Accion)
        SELECT 'bodega', @UsuarioActual, 'DELETE' FROM deleted
    END
    