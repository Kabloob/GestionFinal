
    CREATE TRIGGER trg_contrato_delete
    ON contrato
    AFTER DELETE
    AS
    BEGIN
        DECLARE @UsuarioActual NVARCHAR(255) = SYSTEM_USER
        INSERT INTO Auditoria (NombreTabla, UsuarioActual, Accion)
        SELECT 'contrato', @UsuarioActual, 'DELETE' FROM deleted
    END
    