
    CREATE TRIGGER trg_promociones_insert
    ON promociones
    AFTER INSERT
    AS
    BEGIN
        DECLARE @UsuarioActual NVARCHAR(255) = SYSTEM_USER
        INSERT INTO Auditoria (NombreTabla, UsuarioActual, Accion)
        SELECT 'promociones', @UsuarioActual, 'INSERT' FROM inserted
    END
    