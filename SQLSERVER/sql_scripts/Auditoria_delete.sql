
    CREATE TRIGGER trg_Auditoria_delete
    ON Auditoria
    AFTER DELETE
    AS
    BEGIN
        DECLARE @UsuarioActual NVARCHAR(255) = SYSTEM_USER
        INSERT INTO Auditoria (NombreTabla, UsuarioActual, Accion)
        SELECT 'Auditoria', @UsuarioActual, 'DELETE' FROM deleted
    END
    