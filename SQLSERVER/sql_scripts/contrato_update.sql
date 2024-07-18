
    CREATE TRIGGER trg_contrato_update
    ON contrato
    AFTER UPDATE
    AS
    BEGIN
        DECLARE @UsuarioActual NVARCHAR(255) = SYSTEM_USER
        INSERT INTO Auditoria (NombreTabla, UsuarioActual, Accion)
        SELECT 'contrato', @UsuarioActual, 'UPDATE' FROM inserted
    END
    