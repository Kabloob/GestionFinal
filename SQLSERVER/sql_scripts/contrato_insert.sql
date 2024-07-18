
    CREATE TRIGGER trg_contrato_insert
    ON contrato
    AFTER INSERT
    AS
    BEGIN
        DECLARE @UsuarioActual NVARCHAR(255) = SYSTEM_USER
        INSERT INTO Auditoria (NombreTabla, UsuarioActual, Accion)
        SELECT 'contrato', @UsuarioActual, 'INSERT' FROM inserted
    END
    