
    CREATE TRIGGER trg_Auditoria_update
    ON Auditoria
    AFTER UPDATE
    AS
    BEGIN
        DECLARE @UsuarioActual NVARCHAR(255) = SYSTEM_USER
        INSERT INTO Auditoria (NombreTabla, UsuarioActual, Accion)
        SELECT 'Auditoria', @UsuarioActual, 'UPDATE' FROM inserted
    END
    