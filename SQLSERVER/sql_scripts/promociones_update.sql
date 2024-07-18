
    CREATE TRIGGER trg_promociones_update
    ON promociones
    AFTER UPDATE
    AS
    BEGIN
        DECLARE @UsuarioActual NVARCHAR(255) = SYSTEM_USER
        INSERT INTO Auditoria (NombreTabla, UsuarioActual, Accion)
        SELECT 'promociones', @UsuarioActual, 'UPDATE' FROM inserted
    END
    