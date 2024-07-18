
    CREATE TRIGGER trg_bodega_update
    ON bodega
    AFTER UPDATE
    AS
    BEGIN
        DECLARE @UsuarioActual NVARCHAR(255) = SYSTEM_USER
        INSERT INTO Auditoria (NombreTabla, UsuarioActual, Accion)
        SELECT 'bodega', @UsuarioActual, 'UPDATE' FROM inserted
    END
    