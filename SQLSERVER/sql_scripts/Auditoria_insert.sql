
    CREATE TRIGGER trg_Auditoria_insert
    ON Auditoria
    AFTER INSERT
    AS
    BEGIN
        DECLARE @UsuarioActual NVARCHAR(255) = SYSTEM_USER
        INSERT INTO Auditoria (NombreTabla, UsuarioActual, Accion)
        SELECT 'Auditoria', @UsuarioActual, 'INSERT' FROM inserted
    END
    