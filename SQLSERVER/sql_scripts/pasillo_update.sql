
    CREATE TRIGGER trg_pasillo_update
    ON pasillo
    AFTER UPDATE
    AS
    BEGIN
        DECLARE @UsuarioActual NVARCHAR(255) = SYSTEM_USER
        INSERT INTO Auditoria (NombreTabla, UsuarioActual, Accion)
        SELECT 'pasillo', @UsuarioActual, 'UPDATE' FROM inserted
    END
    