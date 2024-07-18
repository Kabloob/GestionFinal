
    CREATE TRIGGER trg_bodega_insert
    ON bodega
    AFTER INSERT
    AS
    BEGIN
        DECLARE @UsuarioActual NVARCHAR(255) = SYSTEM_USER
        INSERT INTO Auditoria (NombreTabla, UsuarioActual, Accion)
        SELECT 'bodega', @UsuarioActual, 'INSERT' FROM inserted
    END
    