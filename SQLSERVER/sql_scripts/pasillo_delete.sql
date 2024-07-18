
    CREATE TRIGGER trg_pasillo_delete
    ON pasillo
    AFTER DELETE
    AS
    BEGIN
        DECLARE @UsuarioActual NVARCHAR(255) = SYSTEM_USER
        INSERT INTO Auditoria (NombreTabla, UsuarioActual, Accion)
        SELECT 'pasillo', @UsuarioActual, 'DELETE' FROM deleted
    END
    