
    CREATE TRIGGER trg_promociones_delete
    ON promociones
    AFTER DELETE
    AS
    BEGIN
        DECLARE @UsuarioActual NVARCHAR(255) = SYSTEM_USER
        INSERT INTO Auditoria (NombreTabla, UsuarioActual, Accion)
        SELECT 'promociones', @UsuarioActual, 'DELETE' FROM deleted
    END
    