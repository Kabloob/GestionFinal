
    CREATE TRIGGER trg_metodo_pago_update
    ON metodo_pago
    AFTER UPDATE
    AS
    BEGIN
        DECLARE @UsuarioActual NVARCHAR(255) = SYSTEM_USER
        INSERT INTO Auditoria (NombreTabla, UsuarioActual, Accion)
        SELECT 'metodo_pago', @UsuarioActual, 'UPDATE' FROM inserted
    END
    