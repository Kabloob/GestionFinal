
    CREATE TRIGGER trg_pasillo_insert
    ON pasillo
    AFTER INSERT
    AS
    BEGIN
        DECLARE @UsuarioActual NVARCHAR(255) = SYSTEM_USER
        INSERT INTO Auditoria (NombreTabla, UsuarioActual, Accion)
        SELECT 'pasillo', @UsuarioActual, 'INSERT' FROM inserted
    END
    