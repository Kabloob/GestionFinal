
    CREATE TRIGGER trg_metodo_pago_insert
    ON metodo_pago
    AFTER INSERT
    AS
    BEGIN
        DECLARE @UsuarioActual NVARCHAR(255) = SYSTEM_USER
        INSERT INTO Auditoria (NombreTabla, UsuarioActual, Accion)
        SELECT 'metodo_pago', @UsuarioActual, 'INSERT' FROM inserted
    END
    